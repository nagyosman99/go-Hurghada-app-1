import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_booking_model.freezed.dart';
part 'activity_booking_model.g.dart';

@freezed
class ActivityBookingModel with _$ActivityBookingModel {
  const factory ActivityBookingModel({
    required String bookingId,
    required String activityId,
    required DateTime selectedDate,
    required int persons,
    required double totalPrice,
    required String status, // 'confirmed', 'pending', 'cancelled'
  }) = _ActivityBookingModel;

  factory ActivityBookingModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityBookingModelFromJson(json);
}
