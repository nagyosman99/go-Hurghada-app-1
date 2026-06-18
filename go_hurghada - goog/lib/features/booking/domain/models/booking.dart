import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

enum BookingType {
  @JsonValue('hotel')
  hotel,
  @JsonValue('activity')
  activity,
}

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    @Default(BookingType.hotel) BookingType type,

    // Hotel specific (optional for Activity)
    String? hotelId,
    String? hotelName,
    String? roomId,
    String? roomName,
    DateTime? checkInDate,
    DateTime? checkOutDate,

    // Activity specific (optional for Hotel)
    String? activityId,
    String? activityName,
    DateTime? selectedDate,
    int? persons,
    String? pickupLocation,

    // Common
    required double totalPrice,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    @Default(2) int adults, // Can represent persons for activities
    @Default(0) int children,
    @Default(1) int roomsCount,
    required String status, // 'confirmed', 'cancelled', 'pending'
    required DateTime createdAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}
