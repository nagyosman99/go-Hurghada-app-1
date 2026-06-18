import 'package:flutter/material.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';
import 'package:go_hurghada/features/booking/data/booking_repository.dart';
import 'package:go_hurghada/features/booking/data/firebase_booking_repository.dart';
import 'package:go_hurghada/core/services/booking_api_service.dart';

class MyBookingsState {
  final List<Booking> bookings;
  final bool isLoading;
  final String? error;

  const MyBookingsState({
    this.bookings = const [],
    this.isLoading = false,
    this.error,
  });

  MyBookingsState copyWith({
    List<Booking>? bookings,
    bool? isLoading,
    String? error,
  }) {
    return MyBookingsState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// ViewModel for managing and displaying the user's booking history.
class MyBookingsViewModel extends ChangeNotifier {
  final BookingRepository _repository;
  MyBookingsState _state = const MyBookingsState();

  MyBookingsViewModel({required BookingRepository repository})
      : _repository = repository;

  MyBookingsState get state => _state;

  /// Loads bookings from Firestore (filtered by current userId).
  Future<void> loadBookings() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final bookings = await _repository.getBookings();
      _state = _state.copyWith(bookings: bookings, isLoading: false);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
    }
  }

  /// Creates a hotel booking via the Express backend (atomic transaction).
  /// Returns the [bookingId].
  /// Throws [RoomNotAvailableException] if any date is fully booked.
  Future<String> createHotelBooking({
    required String hotelId,
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required String guestName,
    required String guestEmail,
    required String hotelName,
    required String roomName,
    required double totalPrice,
  }) async {
    final BookingRepository repo = _repository;
    if (repo is! FirebaseBookingRepository) {
      throw Exception('Hotel bookings require FirebaseBookingRepository.');
    }

    return repo.createHotelBooking(
      hotelId: hotelId,
      roomId: roomId,
      checkIn: checkIn,
      checkOut: checkOut,
      guestName: guestName,
      guestEmail: guestEmail,
      hotelName: hotelName,
      roomName: roomName,
      totalPrice: totalPrice,
    );
  }

  /// Saves an activity booking to Firestore.
  Future<void> createBooking(Booking booking) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _repository.saveBooking(booking);
      await loadBookings();
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
      rethrow;
    }
  }

  /// Cancels a booking.
  /// For hotel bookings → calls backend PATCH (restores availability).
  /// For activity bookings → updates Firestore status.
  Future<void> cancelBooking(String bookingId) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _repository.cancelBooking(bookingId);
      await loadBookings();
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _repository.deleteBooking(bookingId);
      await loadBookings();
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
    }
  }
}
