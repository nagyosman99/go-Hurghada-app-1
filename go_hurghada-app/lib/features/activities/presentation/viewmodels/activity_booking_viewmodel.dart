import 'package:flutter/material.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity_booking.dart';
import 'package:go_hurghada/features/activities/domain/repository/activities_repository.dart';

class ActivityBookingState {
  final DateTime? selectedDate;
  final int persons;
  final String pickupLocation;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String specialRequests;
  final double totalPrice;
  final bool isSubmitting;
  final String? error;

  const ActivityBookingState({
    this.selectedDate,
    this.persons = 1,
    this.pickupLocation = '',
    this.userName = '',
    this.userEmail = '',
    this.userPhone = '',
    this.specialRequests = '',
    this.totalPrice = 0.0,
    this.isSubmitting = false,
    this.error,
  });

  ActivityBookingState copyWith({
    DateTime? selectedDate,
    int? persons,
    String? pickupLocation,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? specialRequests,
    double? totalPrice,
    bool? isSubmitting,
    String? error,
  }) {
    return ActivityBookingState(
      selectedDate: selectedDate ?? this.selectedDate,
      persons: persons ?? this.persons,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      specialRequests: specialRequests ?? this.specialRequests,
      totalPrice: totalPrice ?? this.totalPrice,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

/// ViewModel for managing the booking process for a specific activity.
class ActivityBookingViewModel extends ChangeNotifier {
  final ActivitiesRepository _repository;
  ActivityBookingState _state = const ActivityBookingState();
  double _pricePerPerson = 0.0;

  ActivityBookingViewModel({required ActivitiesRepository repository})
    : _repository = repository;

  /// The current state of the activity booking form.
  ActivityBookingState get state => _state;

  ActivityPriceCalculator get calculator => ActivityPriceCalculator(
    basePricePerUnit: _pricePerPerson,
    params: BookingParams(adults: _state.persons, children: 0),
  );

  void initialize(double pricePerPerson) {
    _pricePerPerson = pricePerPerson;
    _state = const ActivityBookingState(); // Reset state
    _calculateTotal();
    notifyListeners();
  }

  void setDate(DateTime date) {
    _state = _state.copyWith(selectedDate: date);
    notifyListeners();
  }

  void setPersons(int count) {
    if (count < 1) return;
    _state = _state.copyWith(persons: count);
    _calculateTotal();
    notifyListeners();
  }

  void setPickupLocation(String location) {
    _state = _state.copyWith(pickupLocation: location);
    notifyListeners();
  }

  void setUserName(String name) {
    _state = _state.copyWith(userName: name);
    notifyListeners();
  }

  void setUserEmail(String email) {
    _state = _state.copyWith(userEmail: email);
    notifyListeners();
  }

  void setUserPhone(String phone) {
    _state = _state.copyWith(userPhone: phone);
    notifyListeners();
  }

  void setSpecialRequests(String requests) {
    _state = _state.copyWith(specialRequests: requests);
    notifyListeners();
  }

  void _calculateTotal() {
    final calculator = ActivityPriceCalculator(
      basePricePerUnit: _pricePerPerson,
      params: BookingParams(adults: _state.persons, children: 0),
    );
    _state = _state.copyWith(totalPrice: calculator.totalPrice);
  }

  bool validate() {
    if (_state.selectedDate == null) {
      _state = _state.copyWith(error: 'Please select a date');
      notifyListeners();
      return false;
    }
    if (_state.userName.trim().isEmpty) {
      _state = _state.copyWith(error: 'Please enter your name');
      notifyListeners();
      return false;
    }
    if (_state.userEmail.trim().isEmpty) {
      _state = _state.copyWith(error: 'Please enter your email');
      notifyListeners();
      return false;
    }
    if (_state.userPhone.trim().isEmpty) {
      _state = _state.copyWith(error: 'Please enter your phone number');
      notifyListeners();
      return false;
    }
    _state = _state.copyWith(error: null);
    notifyListeners();
    return true;
  }

  /// Confirms the activity booking and saves it to the repository.
  Future<String?> confirmBooking({
    required String activityId,
    required String activityName,
  }) async {
    if (!validate()) return null;

    _state = _state.copyWith(isSubmitting: true, error: null);
    notifyListeners();

    try {
      final booking = ActivityBooking(
        bookingId:
            'ACT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        activityId: activityId,
        selectedDate: _state.selectedDate!,
        persons: _state.persons,
        totalPrice: _state.totalPrice,
        status: 'confirmed',
      );

      final confirmedBooking = await _repository.createBooking(
        booking: booking,
        guestName: _state.userName,
        guestEmail: _state.userEmail,
        guestPhone: _state.userPhone,
        pickupLocation: _state.pickupLocation,
        activityName: activityName,
      );
      _state = _state.copyWith(isSubmitting: false);
      notifyListeners();
      return confirmedBooking.bookingId;
    } catch (e) {
      _state = _state.copyWith(isSubmitting: false, error: e.toString());
      notifyListeners();
      return null;
    }
  }
}
