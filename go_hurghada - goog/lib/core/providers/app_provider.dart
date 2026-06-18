import 'package:flutter/material.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/settings_viewmodel.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/profile_viewmodel.dart';
import 'package:go_hurghada/features/flight/presentation/viewmodels/flight_search_viewmodel.dart';
import 'package:go_hurghada/features/hotel/data/hotel_repository.dart';
import 'package:go_hurghada/features/hotel/presentation/viewmodels/hotel_search_viewmodel.dart';
import 'package:go_hurghada/features/hotel/presentation/viewmodels/hotel_details_viewmodel.dart';
import 'package:go_hurghada/features/activities/domain/repository/activities_repository.dart';
import 'package:go_hurghada/features/activities/presentation/viewmodels/activities_viewmodel.dart';
import 'package:go_hurghada/features/activities/presentation/viewmodels/activity_booking_viewmodel.dart';
import 'package:go_hurghada/features/booking/data/booking_repository.dart';
import 'package:go_hurghada/features/booking/presentation/viewmodels/my_bookings_viewmodel.dart';
import 'package:go_hurghada/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:go_hurghada/features/payment/presentation/viewmodels/payment_viewmodel.dart';
import 'package:go_hurghada/core/services/payment_service.dart';
import 'package:go_hurghada/core/services/currency_service.dart';
import 'package:go_hurghada/features/ai_assistant/presentation/viewmodels/ai_chat_viewmodel.dart';
import 'package:go_hurghada/features/home/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:go_hurghada/features/flight/domain/repositories/flight_repository.dart';

import 'package:go_hurghada/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:go_hurghada/config/routes/app_router.dart';

class AppProvider extends InheritedWidget {
  final AppRouter appRouter;
  final AuthViewModel authViewModel;
  final SettingsViewModel settingsViewModel;
  final ProfileViewModel profileViewModel;
  final FlightSearchViewModel flightSearchViewModel;
  final FlightRepository flightRepository;
  final HotelSearchViewModel hotelSearchViewModel;
  final HotelDetailsViewModel hotelDetailsViewModel;
  final HotelRepository hotelRepository;
  final ActivitiesRepository activitiesRepository;
  final ActivitiesViewModel activitiesViewModel;
  final ActivityBookingViewModel activityBookingViewModel;
  final BookingRepository bookingRepository;
  final MyBookingsViewModel myBookingsViewModel;
  final HomeViewModel homeViewModel;
  final PaymentViewModel paymentViewModel;
  final PaymentService paymentService;
  final CurrencyService currencyService;
  final AIChatViewModel aiChatViewModel;
  final FavoritesViewModel favoritesViewModel;

  const AppProvider({
    super.key,
    required this.appRouter,
    required this.authViewModel,
    required this.settingsViewModel,
    required this.profileViewModel,
    required this.flightSearchViewModel,
    required this.flightRepository,
    required this.hotelSearchViewModel,
    required this.hotelDetailsViewModel,
    required this.hotelRepository,
    required this.activitiesRepository,
    required this.activitiesViewModel,
    required this.activityBookingViewModel,
    required this.bookingRepository,
    required this.myBookingsViewModel,
    required this.homeViewModel,
    required this.paymentViewModel,
    required this.paymentService,
    required this.currencyService,
    required this.aiChatViewModel,
    required this.favoritesViewModel,
    required super.child,
  });

  static AppProvider of(BuildContext context, {bool listen = true}) {
    final result = listen
        ? context.dependOnInheritedWidgetOfExactType<AppProvider>()
        : context
            .getElementForInheritedWidgetOfExactType<AppProvider>()
            ?.widget as AppProvider?;
    if (result == null) {
      throw FlutterError(
        'AppProvider.of() called with a context that does not contain an AppProvider.\n'
        'No AppProvider ancestor could be found starting from the context that was passed to AppProvider.of().',
      );
    }
    return result;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return authViewModel != oldWidget.authViewModel ||
        settingsViewModel != oldWidget.settingsViewModel ||
        profileViewModel != oldWidget.profileViewModel ||
        flightSearchViewModel != oldWidget.flightSearchViewModel ||
        flightRepository != oldWidget.flightRepository ||
        hotelSearchViewModel != oldWidget.hotelSearchViewModel ||
        hotelDetailsViewModel != oldWidget.hotelDetailsViewModel ||
        hotelRepository != oldWidget.hotelRepository ||
        activitiesRepository != oldWidget.activitiesRepository ||
        activitiesViewModel != oldWidget.activitiesViewModel ||
        activityBookingViewModel != oldWidget.activityBookingViewModel ||
        bookingRepository != oldWidget.bookingRepository ||
        myBookingsViewModel != oldWidget.myBookingsViewModel ||
        homeViewModel != oldWidget.homeViewModel ||
        paymentViewModel != oldWidget.paymentViewModel ||
        paymentService != oldWidget.paymentService ||
        currencyService != oldWidget.currencyService ||
        aiChatViewModel != oldWidget.aiChatViewModel ||
        favoritesViewModel != oldWidget.favoritesViewModel;
  }
}
