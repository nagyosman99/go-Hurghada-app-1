import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_hurghada/features/activities/domain/entities/pickup_info.dart';

part 'pickup_info_model.freezed.dart';
part 'pickup_info_model.g.dart';

@freezed
class PickupInfoModel with _$PickupInfoModel {
  const PickupInfoModel._();

  const factory PickupInfoModel({
    required String timeWindow,
    required List<String> locations,
    required String contactMethod,
    required String contactTiming,
  }) = _PickupInfoModel;

  factory PickupInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PickupInfoModelFromJson(json);

  PickupInfo toDomain() {
    return PickupInfo(
      timeWindow: timeWindow,
      locations: locations,
      contactMethod: contactMethod,
      contactTiming: contactTiming,
    );
  }
}
