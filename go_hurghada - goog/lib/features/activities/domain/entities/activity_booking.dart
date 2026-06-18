import 'package:equatable/equatable.dart';

class ActivityBooking extends Equatable {
  final String bookingId;
  final String activityId;
  final DateTime selectedDate;
  final int persons;
  final double totalPrice;
  final String status;

  const ActivityBooking({
    required this.bookingId,
    required this.activityId,
    required this.selectedDate,
    required this.persons,
    required this.totalPrice,
    required this.status,
  });

  @override
  List<Object?> get props => [
    bookingId,
    activityId,
    selectedDate,
    persons,
    totalPrice,
    status,
  ];

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'activityId': activityId,
      'selectedDate': selectedDate.toIso8601String(),
      'persons': persons,
      'totalPrice': totalPrice,
      'status': status,
    };
  }

  factory ActivityBooking.fromJson(Map<String, dynamic> json) {
    return ActivityBooking(
      bookingId: json['bookingId'] ?? '',
      activityId: json['activityId'] ?? '',
      selectedDate: DateTime.parse(json['selectedDate']),
      persons: json['persons'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
    );
  }

  ActivityBooking copyWith({
    String? bookingId,
    String? activityId,
    DateTime? selectedDate,
    int? persons,
    double? totalPrice,
    String? status,
  }) {
    return ActivityBooking(
      bookingId: bookingId ?? this.bookingId,
      activityId: activityId ?? this.activityId,
      selectedDate: selectedDate ?? this.selectedDate,
      persons: persons ?? this.persons,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
    );
  }
}
