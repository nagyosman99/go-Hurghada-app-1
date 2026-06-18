import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';

/// Repository interface for managing user bookings.
abstract class BookingRepository {
  /// Saves a new booking or updates an existing one.
  Future<void> saveBooking(Booking booking);
  Future<List<Booking>> getBookings();
  Future<void> cancelBooking(String bookingId);
  Future<void> deleteBooking(String bookingId);
}

/// Hive-based implementation of [BookingRepository] for local persistence.
class HiveBookingRepository implements BookingRepository {
  static const String boxName = 'bookings';

  Box _getBox() {
    // Box is already opened in main.dart, just get it
    return Hive.box(boxName);
  }

  @override
  Future<void> saveBooking(Booking booking) async {
    final box = _getBox();
    // Store booking as JSON
    await box.put(booking.id, booking.toJson());
  }

  @override
  Future<List<Booking>> getBookings() async {
    final box = _getBox();
    final bookings = <Booking>[];

    for (var key in box.keys) {
      try {
        final json = box.get(key) as Map<dynamic, dynamic>;
        // Convert dynamic map to Map<String, dynamic>
        final bookingJson = Map<String, dynamic>.from(json);
        bookings.add(Booking.fromJson(bookingJson));
      } catch (e) {
        debugPrint('Error loading booking $key: $e');
      }
    }

    // Sort by creation date (newest first)
    bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return bookings;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    final box = _getBox();
    final json = box.get(bookingId);
    if (json != null) {
      final bookingJson = Map<String, dynamic>.from(json as Map);
      final booking = Booking.fromJson(bookingJson);
      final updatedBooking = booking.copyWith(status: 'cancelled');
      await box.put(bookingId, updatedBooking.toJson());
    }
  }

  @override
  Future<void> deleteBooking(String bookingId) async {
    final box = _getBox();
    await box.delete(bookingId);
  }
}
