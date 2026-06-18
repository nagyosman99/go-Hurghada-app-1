import 'package:flutter_test/flutter_test.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:dartz/dartz.dart';
import 'package:go_hurghada/features/ai_assistant/domain/chat_bot_logic.dart';
import 'package:go_hurghada/features/ai_assistant/presentation/viewmodels/ai_chat_viewmodel.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity_booking.dart';
import 'package:go_hurghada/features/activities/domain/repository/activities_repository.dart';
import 'package:go_hurghada/features/hotel/data/hotel_repository.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/flight/domain/repositories/flight_repository.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/flight/domain/entities/search_params.dart';

// ─── محاكاة سيرفر جيمني بدون إنترنت ───
class MockGeminiService implements GeminiService {
  @override
  bool isReady = true;

  String mockResponseText = '';
  List<FunctionCall> mockFunctionCalls = [];

  @override
  Future<void> init() async {}

  @override
  void clearHistory() {}

  @override
  Future<GenerateContentResponse> sendMessage(String message) async {
    return GenerateContentResponse([
      Candidate(
        Content('model', [
          if (mockFunctionCalls.isNotEmpty)
            ...mockFunctionCalls
          else
            TextPart(mockResponseText),
        ]),
        null,
        null,
        null,
        null,
      ),
    ], null);
  }

  @override
  Future<GenerateContentResponse> sendFunctionResponse(
    String functionName,
    Map<String, Object?> responseMap,
  ) async {
    return GenerateContentResponse([
      Candidate(
        Content('model', [TextPart(mockResponseText)]),
        null,
        null,
        null,
        null,
      ),
    ], null);
  }
}

// ─── كلاسات محاكاة الـ Repositories ───
class MockHotelRepositoryImpl implements HotelRepository {
  final List<HotelSearchResult> mockSearchResults;

  MockHotelRepositoryImpl({this.mockSearchResults = const []});

  @override
  Future<List<HotelSearchResult>> searchHotels(
    String query, {
    DateTime? checkIn,
    DateTime? checkOut,
    int rooms = 1,
    int adults = 1,
    int children = 0,
  }) async {
    if (query.isEmpty) return mockSearchResults;
    return mockSearchResults
        .where(
          (h) =>
              h.name.toLowerCase().contains(query.toLowerCase()) ||
              h.address.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<HotelDetails?> getHotelById(String id) async => null;

  @override
  Future<HotelOffer?> getOfferById(String id) async => null;

  @override
  Future<List<Room>> getRoomsForHotel(String hotelId) async => const [];
}

class MockActivitiesRepositoryImpl implements ActivitiesRepository {
  final List<Activity> mockActivities;

  MockActivitiesRepositoryImpl({this.mockActivities = const []});

  @override
  Future<List<Activity>> getAllActivities() async => mockActivities;

  @override
  Future<List<Activity>> getActivitiesByCategory(String category) async {
    return mockActivities.where((a) => a.category == category).toList();
  }

  @override
  Future<List<Activity>> searchActivities(String query) async {
    if (query.isEmpty) return mockActivities;
    return mockActivities
        .where((a) => a.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<ActivityBooking> createBooking({
    required ActivityBooking booking,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    String? pickupLocation,
    required String activityName,
  }) async => booking;
}

class MockFlightRepositoryImpl implements FlightRepository {
  @override
  Future<Either<String, List<Flight>>> searchFlights(SearchParams params) async {
    return const Right([]);
  }

  @override
  Future<Either<String, List<Flight>>> getFlightsByRoute(String origin, String destination) async {
    return const Right([]);
  }
}

void main() {
  late MockHotelRepositoryImpl hotelRepository;
  late MockActivitiesRepositoryImpl activitiesRepository;
  late MockFlightRepositoryImpl flightRepository;
  late MockGeminiService mockGeminiService;
  late ChatBotLogic chatBotLogic;

  final sampleHotel = HotelSearchResult(
    id: 'h1',
    name: 'Steigenberger Resort',
    address: 'Al Mamsha, Hurghada',
    rating: 4.8,
    pricePerNight: 150.0,
    imageUrl: 'https://example.com/hotel.jpg',
    amenities: const ['Free WiFi', 'Pool'],
    isAllInclusive: true,
  );

  final sampleActivity = Activity(
    id: 'a1',
    title: 'Super Desert Safari',
    description: 'Adventure in the desert',
    price: 45.0,
    location: 'Hurghada Desert',
    duration: '5 hours',
    rating: 4.7,
    images: const ['https://example.com/safari.jpg'],
    category: 'Safari',
    availableDates: const [],
    ageRequirement: '6+',
    pickupIncluded: true,
    languages: const ['English', 'German'],
    instantConfirmation: true,
    freeCancellation: true,
    fullDescription: 'Long description of desert safari',
    whatsIncluded: const ['Hotel pickup', 'Dinner'],
    whatsNotIncluded: const ['Photos', 'Tips'],
  );

  setUp(() {
    hotelRepository = MockHotelRepositoryImpl(mockSearchResults: [sampleHotel]);
    activitiesRepository = MockActivitiesRepositoryImpl(
      mockActivities: [sampleActivity],
    );
    flightRepository = MockFlightRepositoryImpl();
    mockGeminiService = MockGeminiService();

    // تمرير الـ Mock هنا يمنع الاتصال بالإنترنت تماماً أثناء الفحص
    chatBotLogic = ChatBotLogic(
      hotelRepository: hotelRepository,
      activitiesRepository: activitiesRepository,
      flightRepository: flightRepository,
      geminiService: mockGeminiService,
    );
  });

  group('ChatBotLogic & Function Calling Tests', () {
    test(
      'Gemini triggers search_hotels tool and returns attachments',
      () async {
        mockGeminiService.mockFunctionCalls = [
          FunctionCall('search_hotels', {'query': 'Al Mamsha'}),
        ];
        mockGeminiService.mockResponseText =
            'Here are the hotels in Al Mamsha:';

        final response = await chatBotLogic.processMessage(
          'Show me hotels in Al Mamsha',
        );

        expect(response.text, contains('hotels'));
        expect(response.attachments.length, 1);
        expect(response.attachments.first, isA<HotelSearchResult>());
        expect(
          (response.attachments.first as HotelSearchResult).name,
          'Steigenberger Resort',
        );
      },
    );

    test(
      'Gemini triggers search_activities tool and returns attachments',
      () async {
        mockGeminiService.mockFunctionCalls = [
          FunctionCall('search_activities', {'query': 'safari'}),
        ];
        mockGeminiService.mockResponseText = 'I found these activities:';

        final response = await chatBotLogic.processMessage(
          'I want a desert safari',
        );

        expect(response.text, contains('activities'));
        expect(response.attachments.length, 1);
        expect(response.attachments.first, isA<Activity>());
        expect(
          (response.attachments.first as Activity).title,
          'Super Desert Safari',
        );
      },
    );
  });

  group('AIChatViewModel Tests', () {
    test('Initial greeting message is added on creation', () {
      final viewModel = AIChatViewModel(logic: chatBotLogic);
      expect(viewModel.messages.length, 1);
      expect(viewModel.messages.first.isUser, false);
      expect(
        viewModel.messages.first.text,
        contains('Hurghada travel assistant'),
      );
    });

    test(
      'sendMessage adds user message, updates loading, and appends bot response',
      () async {
        final viewModel = AIChatViewModel(logic: chatBotLogic);
        mockGeminiService.mockFunctionCalls = [];
        mockGeminiService.mockResponseText =
            'Welcome! I am your Hurghada travel assistant.';

        final future = viewModel.sendMessage('Hi');

        expect(viewModel.isLoading, true);
        expect(viewModel.messages.length, 2);
        expect(viewModel.messages[1].text, 'Hi');
        expect(viewModel.messages[1].isUser, true);

        await future;

        expect(viewModel.isLoading, false);
        expect(viewModel.messages.length, 3);
        expect(viewModel.messages[2].isUser, false);
        expect(
          viewModel.messages[2].text,
          contains('Hurghada travel assistant'),
        );
      },
    );

    test('clearMessages clears history and restores greeting', () async {
      final viewModel = AIChatViewModel(logic: chatBotLogic);
      await viewModel.sendMessage('Hi');
      expect(viewModel.messages.length, 3);

      viewModel.clearMessages();
      expect(viewModel.messages.length, 1);
      expect(viewModel.messages.first.isUser, false);
    });
  });
}
