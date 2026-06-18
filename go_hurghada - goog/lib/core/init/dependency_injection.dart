import 'package:flutter/widgets.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/hotel/data/firebase_hotel_repository.dart';
import 'package:go_hurghada/features/auth/data/firebase_auth_repository.dart';
import 'package:go_hurghada/features/flight/data/amadeus_flight_repository.dart';
import 'package:go_hurghada/features/activities/data/firebase_activities_repository.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/settings_viewmodel.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/profile_viewmodel.dart';
import 'package:go_hurghada/features/flight/presentation/viewmodels/flight_search_viewmodel.dart';
import 'package:go_hurghada/features/hotel/presentation/viewmodels/hotel_search_viewmodel.dart';
import 'package:go_hurghada/features/hotel/presentation/viewmodels/hotel_details_viewmodel.dart';
import 'package:go_hurghada/features/activities/presentation/viewmodels/activities_viewmodel.dart';
import 'package:go_hurghada/features/activities/presentation/viewmodels/activity_booking_viewmodel.dart';
import 'package:go_hurghada/features/booking/data/firebase_booking_repository.dart';
import 'package:go_hurghada/features/booking/presentation/viewmodels/my_bookings_viewmodel.dart';
import 'package:go_hurghada/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:go_hurghada/features/payment/presentation/viewmodels/payment_viewmodel.dart';
import 'package:go_hurghada/core/services/payment_service.dart';
import 'package:go_hurghada/core/services/currency_service.dart';
import 'package:go_hurghada/core/services/booking_api_service.dart';
import 'package:go_hurghada/features/ai_assistant/domain/chat_bot_logic.dart';
import 'package:go_hurghada/features/ai_assistant/presentation/viewmodels/ai_chat_viewmodel.dart';
import 'package:go_hurghada/features/home/data/favorites_repository.dart';
import 'package:go_hurghada/features/home/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:go_hurghada/core/services/amadeus_token_service.dart';
import 'package:go_hurghada/features/flight/data/amadeus_flight_service.dart';

class DependencyInjection {
  static Future<AppProvider> createProvider({required Widget child}) async {
    // 1. Services
    final bookingApiService = BookingApiService();
    final currencyService = CurrencyService();
    final amadeusTokenService = AmadeusTokenService();
    final amadeusFlightService = AmadeusFlightService(amadeusTokenService);

    // 2. Repositories
    final authRepository = FirebaseAuthRepository();
    // Use Firebase for hotels so Firestore hotels (e.g. M2zl5ngcAKfEQR7tohYo) are visible
    final hotelRepository = FirebaseHotelRepository();
    final bookingRepository = FirebaseBookingRepository(api: bookingApiService);
    final activitiesRepository = FirebaseActivitiesRepository();
    final favoritesRepository = FavoritesRepository();
    final flightRepository = AmadeusFlightRepository(amadeusFlightService);

    // 3. Initialize Repositories (Async)
    await favoritesRepository.init();
    await currencyService.init();

    // Background fetch (fire and forget)
    currencyService.fetchLatestRates().catchError(
      (e) => debugPrint('Initial currency fetch error: $e'),
    );

    // 4. ViewModels
    final authViewModel = AuthViewModel(repository: authRepository);

    final settingsViewModel = SettingsViewModel(repository: authRepository);
    await settingsViewModel.loadSettings();

    final profileViewModel = ProfileViewModel(repository: authRepository);
    await profileViewModel.loadProfile();

    final homeViewModel = HomeViewModel(
      activitiesRepository: activitiesRepository,
    );
    final flightSearchViewModel = FlightSearchViewModel(
      flightService: amadeusFlightService,
    );
    final hotelSearchViewModel = HotelSearchViewModel();
    final hotelDetailsViewModel = HotelDetailsViewModel(
      repository: hotelRepository,
    );
    final myBookingsViewModel = MyBookingsViewModel(
      repository: bookingRepository,
    );
    final activitiesViewModel = ActivitiesViewModel(
      repository: activitiesRepository,
    );
    final activityBookingViewModel = ActivityBookingViewModel(
      repository: activitiesRepository,
    );

    final paymentService = PayMobPaymentService();
    final paymentViewModel = PaymentViewModel(paymentService: paymentService);

    // AI Logic
    final chatBotLogic = ChatBotLogic(
      hotelRepository: hotelRepository,
      activitiesRepository: activitiesRepository,
      flightRepository: flightRepository,
    );
    final aiChatViewModel = AIChatViewModel(logic: chatBotLogic);

    final favoritesViewModel = FavoritesViewModel(favoritesRepository);

    // 5. App Router
    final appRouter = AppRouter(authViewModel, profileViewModel);

    // 6. Return the configured AppProvider
    return AppProvider(
      appRouter: appRouter,
      authViewModel: authViewModel,
      settingsViewModel: settingsViewModel,
      profileViewModel: profileViewModel,
      flightSearchViewModel: flightSearchViewModel,
      flightRepository: flightRepository,
      hotelSearchViewModel: hotelSearchViewModel,
      hotelDetailsViewModel: hotelDetailsViewModel,
      hotelRepository: hotelRepository,
      activitiesRepository: activitiesRepository,
      activitiesViewModel: activitiesViewModel,
      activityBookingViewModel: activityBookingViewModel,
      bookingRepository: bookingRepository,
      myBookingsViewModel: myBookingsViewModel,
      homeViewModel: homeViewModel,
      paymentViewModel: paymentViewModel,
      paymentService: paymentService,
      currencyService: currencyService,
      aiChatViewModel: aiChatViewModel,
      favoritesViewModel: favoritesViewModel,
      child: child,
    );
  }
}
