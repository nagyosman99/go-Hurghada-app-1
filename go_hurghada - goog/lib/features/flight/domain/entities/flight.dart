import 'package:freezed_annotation/freezed_annotation.dart';

part 'flight.freezed.dart';
part 'flight.g.dart';

@freezed
class Flight with _$Flight {
  const factory Flight({
    required String id,
    required String airlineCode,
    required String airlineName,
    required String origin,
    required String destination,
    required DateTime departureTime,
    required DateTime arrivalTime,
    required int durationMinutes,
    required int stops,
    required double price,
    required String currency,
    required String bookingUrl,
    String? flightNumber,
    String? aircraftType,
  }) = _Flight;

  factory Flight.fromJson(Map<String, dynamic> json) => _$FlightFromJson(json);
}
