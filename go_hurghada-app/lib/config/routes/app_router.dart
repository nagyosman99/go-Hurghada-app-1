import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_hurghada/features/activities/presentation/pages/booking_summary_page.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/profile_viewmodel.dart';
import 'package:go_hurghada/features/hotel/presentation/screens/hotel_results_screen.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/screens/offers/hotel_offer_results_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/features/auth/presentation/screens/splash_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/onboarding1_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/onboarding2_screen.dart';
import 'package:go_hurghada/features/home/presentation/screens/home_screen.dart';
import 'package:go_hurghada/features/flight/presentation/screens/flight_search_screen.dart';
import 'package:go_hurghada/features/flight/presentation/screens/search_results_screen.dart';
import 'package:go_hurghada/features/flight/presentation/screens/date_selection_screen.dart';
import 'package:go_hurghada/features/flight/domain/entities/search_params.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/auth/presentation/screens/profile_screen.dart';
import 'package:go_hurghada/features/home/presentation/screens/favorites_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/landing_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/new_password_screen.dart';
import 'package:go_hurghada/features/hotel/presentation/screens/hotel_search_screen.dart';
import 'package:go_hurghada/features/hotel/presentation/screens/hotel_details_screen.dart';
import 'package:go_hurghada/features/hotel/presentation/screens/room_selection_screen.dart';
import 'package:go_hurghada/features/booking/presentation/screens/booking_form_screen.dart';
import 'package:go_hurghada/features/payment/presentation/screens/payment_screen.dart';
import 'package:go_hurghada/features/booking/presentation/screens/booking_confirmation_screen.dart';
import 'package:go_hurghada/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:go_hurghada/features/booking/presentation/screens/booking_details_screen.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';
import 'package:go_hurghada/features/hotel/presentation/screens/offers/select_room_screen.dart';
import 'package:go_hurghada/features/activities/presentation/pages/activities_list_page.dart';
import 'package:go_hurghada/features/activities/presentation/pages/activity_details_page.dart';
import 'package:go_hurghada/features/activities/presentation/pages/booking_page.dart';
import 'package:go_hurghada/features/ai_assistant/presentation/screens/ai_chat_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/edit_profile_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/app_settings_screen.dart';
import 'package:go_hurghada/features/auth/presentation/screens/currency_settings_screen.dart';
import 'package:go_hurghada/features/home/presentation/screens/all_offers_screen.dart';
import 'package:go_hurghada/features/home/presentation/screens/main_scaffold_screen.dart';

class AppRouter {
  final AuthViewModel authViewModel;
  final ProfileViewModel profileViewModel;

  AppRouter(this.authViewModel, this.profileViewModel);

  static const String splash = '/splash';
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String landing = '/landing';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/otp-verification';
  static const String newPassword = '/new-password';
  static const String home = '/home';
  static const String flightSearch = '/home/flight-search';
  static const String searchResults = '/home/search-results';
  static const String dateSelection = '/home/date-selection';
  static const String hotel = '/home/hotel';
  static const String hotelResults = '/home/hotel-results';
  static const String aiAssistant = '/ai-assistant';

  static const String profile = '/profile';
  static const String hotelOfferResults = '/home/hotel-offer-results';
  static const String activities = '/home/activities';
  static const String activityDetails = '/home/activity';

  static const String editProfile = '/profile/edit-profile';
  static const String settings = '/profile/settings';
  static const String currencySettings = '/profile/currency-settings';
  static const String myBookings = '/my-bookings';
  static const String bookingDetails = '/my-bookings/booking-details';
  static const String favorites = '/favorites';
  static const String allOffers = '/home/all-offers';
  static const String hotelDetails = '/home/hotel-details';
  static const String hotelRooms = '/home/hotel-rooms';
  static const String selectRoom = '/home/select-room';

  // Root Routes
  static const String bookingForm = '/booking-form';
  static const String payment = '/payment';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String activityBooking = '/activity/:id/booking';
  static const String activityBookingSummary = '/activity/:id/booking/summary';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellHome',
  );
  static final _shellNavigatorFavoritesKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellFavorites',
  );
  static final _shellNavigatorBookingsKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellBookings',
  );
  static final _shellNavigatorSupportKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellSupport',
  );
  static final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellProfile',
  );

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: splash,
    refreshListenable: Listenable.merge([authViewModel, profileViewModel]),
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;

      final isLoggingIn =
          state.uri.toString() == signIn ||
          state.uri.toString() == signUp ||
          state.uri.toString() == landing ||
          state.uri.toString() == splash ||
          state.uri.toString() == onboarding1 ||
          state.uri.toString() == onboarding2 ||
          state.uri.toString() == resetPassword ||
          state.uri.toString() == otpVerification ||
          state.uri.toString() == newPassword;

      if (!isLoggedIn && !isLoggingIn) {
        // Redirect to Landing or SignIn if not logged in and trying to access protected route
        return landing;
      }

      if (isLoggedIn && isLoggingIn) {
        // Redirect to Home if logged in and trying to access auth routes
        // Exception: Splash might need to run check first, but verified user should go home
        if (state.uri.toString() == splash) {
          return null; // Let splash handle initial check if needed, or just go home
        }
        return home;
      }

      return null;
    },
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: onboarding1, builder: (context, state) => const Onboard1()),
      GoRoute(path: onboarding2, builder: (context, state) => const Onboard2()),
      GoRoute(
        path: landing,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(path: signIn, builder: (context, state) => const SignInScreen()),
      GoRoute(path: signUp, builder: (context, state) => const SignUpScreen()),
      GoRoute(
        path: resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: newPassword,
        builder: (context, state) => const NewPasswordScreen(),
      ),

      // Persistent Bottom Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'flight-search', // Relative path
                    builder: (context, state) => const FlightSearchScreen(),
                  ),
                  GoRoute(
                    path: 'search-results',
                    builder: (context, state) {
                      final params = state.extra as SearchParams;
                      return SearchResultsScreen(searchParams: params);
                    },
                  ),
                  GoRoute(
                    path: 'date-selection',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return DateSelectionScreen(
                        isSelectingDeparture:
                            extra['isSelectingDeparture'] as bool,
                        initialDate: extra['initialDate'] as DateTime?,
                        routeTitle: extra['routeTitle'] as String?,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'hotel',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final initialLocation =
                          extra?['initialLocation'] as String?;
                      return HotelSearchScreen(
                        initialLocation: initialLocation,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'hotel-results',
                    builder: (context, state) => const HotelResultsScreen(),
                  ),
                  GoRoute(
                    path: 'hotel-details/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final extra = state.extra as Map<String, dynamic>?;
                      return HotelDetailsScreen(
                        hotelId: id,
                        checkIn: extra?['checkIn'] as DateTime?,
                        checkOut: extra?['checkOut'] as DateTime?,
                        adults: extra?['adults'] as int?,
                        children: extra?['children'] as int?,
                        rooms: extra?['rooms'] as int?,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'hotel-offer-results',
                    builder: (context, state) {
                      if (state.extra is! OfferCardModel) {
                        return const Scaffold(
                          body: Center(
                            child: Text('Error: Invalid offer data'),
                          ),
                        );
                      }
                      final offer = state.extra as OfferCardModel;
                      return HotelOfferResultsScreen(offer: offer);
                    },
                  ),
                  GoRoute(
                    path: 'activities',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final initialCategory =
                          extra?['initialCategory'] as String?;
                      return ActivitiesListPage(
                        initialCategory: initialCategory,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'activity/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ActivityDetailsPage(activityId: id);
                    },
                  ),
                  GoRoute(
                    path: 'all-offers',
                    builder: (context, state) => const AllOffersScreen(),
                  ),
                  // Hotel Rooms Selection (Deep Link from Details)
                  GoRoute(
                    path: 'hotel-rooms/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final extra = state.extra as Map<String, dynamic>?;
                      return RoomSelectionScreen(
                        hotelId: id,
                        checkIn: extra?['checkIn'] as DateTime?,
                        checkOut: extra?['checkOut'] as DateTime?,
                        adults: extra?['adults'] as int?,
                        children: extra?['children'] as int?,
                        rooms: extra?['rooms'] as int?,
                        discountPercentage:
                            extra?['discountPercentage'] as double?,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'select-room',
                    builder: (context, state) {
                      if (state.extra is! OfferCardModel) {
                        return const Scaffold(
                          body: Center(
                            child: Text('Error: Invalid offer data'),
                          ),
                        );
                      }
                      final offer = state.extra as OfferCardModel;
                      return SelectRoomScreen(offer: offer);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 1: Favorites
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFavoritesKey,
            routes: [
              GoRoute(
                path: favorites,
                builder: (context, state) => const FavoritesScreen(),
                routes: [
                  GoRoute(
                    path: 'hotel-offer-results',
                    builder: (context, state) {
                      if (state.extra is! OfferCardModel) {
                        return const Scaffold(
                          body: Center(
                            child: Text('Error: Invalid offer data'),
                          ),
                        );
                      }
                      final offer = state.extra as OfferCardModel;
                      return HotelOfferResultsScreen(offer: offer);
                    },
                  ),
                  GoRoute(
                    path: 'hotel-details/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final extra = state.extra as Map<String, dynamic>?;
                      return HotelDetailsScreen(
                        hotelId: id,
                        checkIn: extra?['checkIn'] as DateTime?,
                        checkOut: extra?['checkOut'] as DateTime?,
                        adults: extra?['adults'] as int?,
                        children: extra?['children'] as int?,
                        rooms: extra?['rooms'] as int?,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'activity/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ActivityDetailsPage(activityId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 2: My Bookings
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBookingsKey,
            routes: [
              GoRoute(
                path: myBookings,
                builder: (context, state) => const MyBookingsScreen(),
                routes: [
                  GoRoute(
                    path: 'booking-details/:id', // Relative path
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return BookingDetailsScreen(bookingId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 3: Support (AI Assistant)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSupportKey,
            routes: [
              GoRoute(
                path: aiAssistant,
                builder: (context, state) => const AIChatScreen(),
              ),
            ],
          ),

          // Branch 4: Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit-profile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const AppSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'currency-settings',
                    builder: (context, state) => const CurrencySettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Root Routes (Fullscreen, checkouts, etc.)
      GoRoute(
        path: bookingForm,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final hotelId = extra['hotelId'] as String;
          final roomId = extra['roomId'] as String;
          return BookingFormScreen(
            hotelId: hotelId,
            roomId: roomId,
            checkIn: extra['checkIn'] as DateTime?,
            checkOut: extra['checkOut'] as DateTime?,
            adults: extra['adults'] as int?,
            children: extra['children'] as int?,
            rooms: extra['rooms'] as int?,
            discountPercentage: extra['discountPercentage'] as double?,
          );
        },
      ),
      GoRoute(
        path: payment,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final bookingDetails = state.extra as Map<String, dynamic>;
          return PaymentScreen(bookingDetails: bookingDetails);
        },
      ),
      GoRoute(
        path: bookingConfirmation,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final booking = state.extra as Booking;
          return BookingConfirmationScreen(booking: booking);
        },
      ),
      GoRoute(
        path: activityBooking,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookingPage(activityId: id);
        },
      ),
      GoRoute(
        path: activityBookingSummary,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BookingSummaryPage(activity: extra['activity']);
        },
      ),
    ],
  );
}
