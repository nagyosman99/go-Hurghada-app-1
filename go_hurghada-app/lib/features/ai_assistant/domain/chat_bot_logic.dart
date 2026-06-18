import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:go_hurghada/features/activities/domain/repository/activities_repository.dart';
import 'package:go_hurghada/features/hotel/data/hotel_repository.dart';
import 'package:go_hurghada/features/flight/domain/repositories/flight_repository.dart';

// ─── 1. CLASS RESPONSES ───
class ChatResponse {
  final String text;
  final List<dynamic> attachments;

  ChatResponse(this.text, [this.attachments = const []]);
}

// ─── 2. GEMINI TOOLS DEFINITION ───
class ChatTools {
  static Tool get travelTools => Tool(
    functionDeclarations: [
      // أداة البحث عن الفنادق
      FunctionDeclaration(
        'search_hotels',
        'Search for hotels in Hurghada or specific areas like El Gouna, Makadi Bay, Sahl Hasheesh based on location or budget keywords.',
        Schema(
          SchemaType.object,
          properties: {
            'query': Schema(
              SchemaType.string,
              description:
                  'The location, area, or budget keyword (e.g., "El Gouna", "cheap", "luxury").',
            ),
          },
        ),
      ),

      // أداة جلب غرف فندق معين
      FunctionDeclaration(
        'get_hotel_rooms',
        'Fetch available rooms for a specific hotel using its hotel ID.',
        Schema(
          SchemaType.object,
          properties: {
            'hotelId': Schema(
              SchemaType.string,
              description: 'The exact unique ID of the hotel.',
            ),
          },
          requiredProperties: ['hotelId'],
        ),
      ),

      // أداة البحث عن الأنشطة والرحلات
      FunctionDeclaration(
        'search_activities',
        'Search for trips, tours, and activities in Hurghada like safari, diving, snorkeling, or boat trips.',
        Schema(
          SchemaType.object,
          properties: {
            'query': Schema(
              SchemaType.string,
              description:
                  'The type of activity (e.g., "safari", "diving"). If general request, leave empty.',
            ),
          },
        ),
      ),

      // أداة البحث عن الرحلات الجوية
      FunctionDeclaration(
        'search_flights',
        'Search for domestic flights between Egyptian cities (e.g. Cairo (CAI), Hurghada (HRG), Luxor (LXR), Aswan (ASW), Alexandria (HBE), Sharm El Sheikh (SSH)).',
        Schema(
          SchemaType.object,
          properties: {
            'origin': Schema(
              SchemaType.string,
              description: 'The origin city name or IATA code (e.g. "Cairo" or "CAI").',
            ),
            'destination': Schema(
              SchemaType.string,
              description: 'The destination city name or IATA code (e.g. "Hurghada" or "HRG").',
            ),
          },
          requiredProperties: ['origin', 'destination'],
        ),
      ),
    ],
  );
}

// ─── 3. GEMINI CORE SERVICE ───
class GeminiService {
  GenerativeModel? _model;
  ChatSession? _chatSession;

  bool get isReady => _model != null && _chatSession != null;

  Future<void> init() async {
    try {
      if (!dotenv.isInitialized) throw Exception('dotenv is not initialized.');
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY is missing.');
      }

      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        tools: [ChatTools.travelTools],
        systemInstruction: Content.system('''
  أنت "مساعد الغردقة الذكي" — رفيق السفر المبتكر لتطبيق Go Hurghada.
  بتتكلم عربي وإنجليزي وبتفهم العامية المصرية (اللهجة المصرية الدارجة) كويس جداً.

  ══════════════════════════════════
  الأدوات المتاحة عندك:
  ══════════════════════════════════
  - search_hotels 🏨: البحث عن الفنادق وعرضها
  - get_hotel_rooms 🔑: جلب الأوض المتاحة بفندق معين
  - search_activities 🌴: البحث عن رحلات ترفيهية وسفاري وغطس
  - search_flights ✈️: البحث عن رحلات طيران داخل مصر

  ══════════════════════════════════
  ترجمة العامية للأكشن:
  ══════════════════════════════════
  "عايز فندق" / "فيه فنادق إيه؟" / "أرخص فندق" / "مكان حلو للاسترخاء" -> search_hotels
  "الرحلات إيه؟" / "عايز سفاري" / "رحلة غطس" / "عايز أتفسح" -> search_activities
  "طيران" / "عايز أسافر" / "سفر للغردقة" / "رحلة طيران من القاهرة" -> search_flights
  "الأوض بكام" / "عايز أشوف الأوض" / "فيه حجز أوض؟" -> get_hotel_rooms

  ══════════════════════════════════
  قواعد أساسية:
  ══════════════════════════════════
  1. استخدم الأدوات دايماً — ماتخمنش أي بيانات. الداتا بتيجي من الـ database فقط.
  2. لو معلومة ناقصة (زي مطار المغادرة أو الوصول للرحلة) — اسأل عنها بأسلوب ودود ولطيف.
  3. فرمت الردود بـ Markdown: جداول للقوائم والمقارنات، **bold** للأسعار والأسماء، واستخدم الإيموجيز المناسبة (🏨، ✈️، 🌴، ✅، ❌).
  4. رد بنفس لغة المستخدم — لو اتكلم عامية مصرية، رد عليه بعامية مصرية ودودة جداً ولطيفة وما تبقاش روبوت رسمي زيادة عن اللزوم.
  '''),
      );

      _chatSession = _model!.startChat();
      debugPrint('[GeminiService] ✅ Initialized successfully with Tools.');
    } catch (e) {
      debugPrint('[GeminiService] ❌ Initialization error: $e');
      rethrow;
    }
  }

  void clearHistory() {
    if (_model != null) {
      _chatSession = _model!.startChat();
    }
  }

  Future<GenerateContentResponse> sendMessage(String message) async {
    if (_chatSession == null) throw Exception('Chat session not initialized.');
    return await _chatSession!.sendMessage(Content.text(message));
  }

  Future<GenerateContentResponse> sendFunctionResponse(
    String functionName,
    Map<String, Object?> responseMap,
  ) async {
    if (_chatSession == null) throw Exception('Chat session not initialized.');
    return await _chatSession!.sendMessage(
      Content.functionResponse(functionName, responseMap),
    );
  }
}

// ─── 4. MAIN CHATBOT LOGIC (CONTROLLER) ───
class ChatBotLogic {
  final HotelRepository hotelRepository;
  final ActivitiesRepository activitiesRepository;
  final FlightRepository flightRepository;
  final GeminiService _geminiService;

  bool _isInitializing = false;
  String _initStatusMessage = 'Initializing...';

  bool get isGeminiReady => _geminiService.isReady;
  String get initStatusMessage => _initStatusMessage;

  ChatBotLogic({
    required this.hotelRepository,
    required this.activitiesRepository,
    required this.flightRepository,
    GeminiService? geminiService,
  }) : _geminiService = geminiService ?? GeminiService() {
    _initBot();
  }

  Future<void> _initBot() async {
    if (_isInitializing) return;
    _isInitializing = true;
    try {
      await _geminiService.init();
      _initStatusMessage = 'Gemini initialized successfully.';
    } catch (e) {
      _initStatusMessage = 'Initialization error: $e';
    } finally {
      _isInitializing = false;
    }
  }

  void clearHistory() => _geminiService.clearHistory();

  Future<ChatResponse> processMessage(String message) async {
    if (!_geminiService.isReady) {
      await _initBot();
      if (!_geminiService.isReady) {
        return ChatResponse('عذرًا، البوت غير جاهز حاليًا. حاول مرة أخرى.');
      }
    }

    try {
      debugPrint('[ChatBotLogic] Sending to Gemini: "$message"');
      var response = await _geminiService.sendMessage(message);
      final attachments = <dynamic>[];

      // Loop التعامل مع الـ Function Calling المتبادل
      while (response.functionCalls.isNotEmpty) {
        final call = response.functionCalls.first;
        final functionName = call.name;
        final args = call.args;

        debugPrint(
          '[ChatBotLogic] 🤖 Gemini requested tool: $functionName with args: $args',
        );
        Map<String, Object?> resultData = {};

        // 1. أداة الفنادق
        if (functionName == 'search_hotels') {
          final query = args['query'] as String? ?? '';
          final hotels = await hotelRepository.searchHotels(query);
          attachments.addAll(hotels);

          resultData = {
            'status': 'success',
            'found_count': hotels.length,
            'hotels':
                hotels
                    .map(
                      (h) => {
                        'id': h.id,
                        'name': h.name,
                        'price': h.pricePerNight,
                      },
                    )
                    .toList(),
          };
        }
        // 2. أداة الغرف
        else if (functionName == 'get_hotel_rooms') {
          final hotelId = args['hotelId'] as String? ?? '';
          final rooms = await hotelRepository.getRoomsForHotel(hotelId);
          attachments.addAll(rooms);

          resultData = {
            'status': 'success',
            'found_count': rooms.length,
            'rooms':
                rooms.map((r) => {'name': r.name, 'price': r.price}).toList(),
          };
        }
        // 3. أداة الأنشطة
        else if (functionName == 'search_activities') {
          final query = args['query'] as String? ?? '';
          var activities = await activitiesRepository.searchActivities(query);
          if (activities.isEmpty) {
            activities = await activitiesRepository.getAllActivities();
          }
          attachments.addAll(activities);

          resultData = {
            'status': 'success',
            'found_count': activities.length,
            'activities':
                activities
                    .map(
                      (a) => {
                        'id': a.id,
                        'name': a.title,
                        'price': a.price,
                        'duration': a.duration,
                        'description': a.description,
                      },
                    )
                    .toList(),
          };
        }
        // 4. أداة الرحلات الجوية
        else if (functionName == 'search_flights') {
          final origin = args['origin'] as String? ?? '';
          final destination = args['destination'] as String? ?? '';
          final flightResult = await flightRepository.getFlightsByRoute(origin, destination);
          
          List<dynamic> flights = [];
          flightResult.fold(
            (error) => debugPrint('[ChatBotLogic] Flights error: $error'),
            (list) {
              flights = list;
              attachments.addAll(list);
            },
          );

          resultData = {
            'status': 'success',
            'found_count': flights.length,
            'flights': flights.map((f) => {
              'id': f.id,
              'airline': f.airlineName,
              'price': f.price,
              'origin': f.origin,
              'destination': f.destination,
              'stops': f.stops,
              'bookingUrl': f.bookingUrl,
            }).toList(),
          };
        }

        // إرسال البيانات المستخرجة لـ Gemini عشان يصيغها للمستخدم
        response = await _geminiService.sendFunctionResponse(
          functionName,
          resultData,
        );
      }

      return ChatResponse(response.text ?? '', attachments);
    } catch (e, stackTrace) {
      final errorStr = e.toString();
      debugPrint('[ChatBotLogic] ❌ FULL ERROR: $errorStr');
      debugPrint('[ChatBotLogic] ❌ StackTrace: $stackTrace');

      if (errorStr.contains('RESOURCE_EXHAUSTED') ||
          errorStr.contains('429') ||
          errorStr.contains('Quota exceeded')) {
        return ChatResponse(
          'لقد تجاوزت الحد الأقصى للرسائل في النسخة المجانية. يرجى الانتظار دقيقة والمحاولة مرة أخرى. ⏳',
        );
      }

      return ChatResponse(
        'عذرًا، حدث خطأ أثناء التواصل مع خوادم الذكاء الاصطناعي. يرجى المحاولة مرة أخرى.',
      );
    }
  }
}

