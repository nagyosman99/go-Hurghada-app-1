import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_params.freezed.dart';
part 'search_params.g.dart';

@freezed
class SearchParams with _$SearchParams {
  const factory SearchParams({
    required String origin,
    required String destination,
    required DateTime departureDate,
    DateTime? returnDate,
    @Default(1) int adults,
    @Default('Economy') String travelClass,
    @Default(false) bool isRoundTrip,
  }) = _SearchParams;

  factory SearchParams.fromJson(Map<String, dynamic> json) =>
      _$SearchParamsFromJson(json);
}
