import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_hurghada/features/activities/data/models/pickup_info_model.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

@freezed
class ActivityModel with _$ActivityModel {
  const ActivityModel._();

  const factory ActivityModel({
    required String id,
    required String title,
    required String description,
    required double price,
    required String location,
    required String duration,
    required double rating,
    required List<String> images,
    required String category,
    required List<DateTime> availableDates,
    required String ageRequirement,
    required bool pickupIncluded,
    required List<String> languages,
    required bool instantConfirmation,
    required bool freeCancellation,
    required String fullDescription,
    required List<String> whatsIncluded,
    required List<String> whatsNotIncluded,
    PickupInfoModel? pickupInfo,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Activity toDomain() {
    return Activity(
      id: id,
      title: title,
      description: description,
      price: price,
      location: location,
      duration: duration,
      rating: rating,
      images: images,
      category: category,
      availableDates: availableDates,
      ageRequirement: ageRequirement,
      pickupIncluded: pickupIncluded,
      languages: languages,
      instantConfirmation: instantConfirmation,
      freeCancellation: freeCancellation,
      fullDescription: fullDescription,
      whatsIncluded: whatsIncluded,
      whatsNotIncluded: whatsNotIncluded,
      pickupInfo: pickupInfo?.toDomain(),
    );
  }
}
