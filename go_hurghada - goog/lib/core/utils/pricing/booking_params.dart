import 'package:flutter/foundation.dart';

/// Value object for booking parameters
/// Designed to match real hotel booking apps (Booking.com, Expedia patterns)
@immutable
class BookingParams {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int adults;
  final int children;
  final int rooms;

  const BookingParams({
    this.checkIn,
    this.checkOut,
    this.adults = 2, // Industry standard: 2 adults default
    this.children = 0,
    this.rooms = 1,
  });

  int get totalGuests => adults + children;

  int get nights {
    if (checkIn == null || checkOut == null) return 1;
    final diff = checkOut!.difference(checkIn!).inDays;
    if (diff <= 0) return 1;
    return diff.clamp(1, 365);
  }

  /// Real apps enforce: at least 1 adult, can't have negative values
  void validate() {
    if (checkIn != null && checkOut != null) {
      if (checkOut!.isBefore(checkIn!)) {
        throw ArgumentError('Check-out date must be after check-in date');
      }
    }
    if (adults < 1) {
      throw ArgumentError('At least 1 adult is required');
    }
    if (children < 0 || rooms < 1) {
      throw ArgumentError('Invalid guest or room count');
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookingParams &&
        other.checkIn == checkIn &&
        other.checkOut == checkOut &&
        other.adults == adults &&
        other.children == children &&
        other.rooms == rooms;
  }

  @override
  int get hashCode => Object.hash(checkIn, checkOut, adults, children, rooms);
}
