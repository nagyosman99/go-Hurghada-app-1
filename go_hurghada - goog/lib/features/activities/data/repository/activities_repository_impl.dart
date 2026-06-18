import 'package:go_hurghada/features/activities/data/data_source/activities_local_source.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity_booking.dart';
import 'package:go_hurghada/features/activities/domain/repository/activities_repository.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';
import 'package:go_hurghada/features/booking/data/booking_repository.dart';

class ActivitiesRepositoryImpl implements ActivitiesRepository {
  final ActivitiesLocalSource _localSource;
  final BookingRepository _bookingRepository;

  ActivitiesRepositoryImpl(this._localSource, this._bookingRepository);

  @override
  Future<List<Activity>> getAllActivities() async {
    final models = await _localSource.getActivities();
    return models.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Activity>> getActivitiesByCategory(String category) async {
    final models = await _localSource.getActivities();
    if (category == 'All') {
      return models.map((e) => e.toDomain()).toList();
    }
    return models
        .where((e) => e.category == category)
        .map((e) => e.toDomain())
        .toList();
  }

  @override
  Future<List<Activity>> searchActivities(String query) async {
    final models = await _localSource.getActivities();
    final lowerQuery = query.toLowerCase();
    return models
        .where(
          (e) =>
              e.title.toLowerCase().contains(lowerQuery) ||
              e.description.toLowerCase().contains(lowerQuery),
        )
        .map((e) => e.toDomain())
        .toList();
  }

  @override
  Future<ActivityBooking> createBooking({
    required ActivityBooking booking,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    String? pickupLocation,
    required String activityName,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    final confirmedBooking = booking.copyWith(status: 'confirmed');

    // Persist to unified booking repository
    final persistentBooking = Booking(
      id: confirmedBooking.bookingId,
      type: BookingType.activity,
      activityId: confirmedBooking.activityId,
      activityName: activityName,
      selectedDate: confirmedBooking.selectedDate,
      persons: confirmedBooking.persons,
      pickupLocation: pickupLocation,
      totalPrice: confirmedBooking.totalPrice,
      guestName: guestName,
      guestEmail: guestEmail,
      guestPhone: guestPhone,
      status: confirmedBooking.status,
      createdAt: DateTime.now(),
    );

    await _bookingRepository.saveBooking(persistentBooking);

    return confirmedBooking;
  }
}

// Extension to add copyWith to ActivityBooking entity since it's not a Freezed class
extension ActivityBookingCopyWith on ActivityBooking {
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
