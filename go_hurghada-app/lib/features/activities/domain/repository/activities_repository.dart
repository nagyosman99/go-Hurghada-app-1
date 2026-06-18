import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity_booking.dart';

/// Repository interface for managing activities and their bookings.
abstract class ActivitiesRepository {
  /// Retrieves all available activities.
  Future<List<Activity>> getAllActivities();
  Future<List<Activity>> getActivitiesByCategory(String category);
  Future<List<Activity>> searchActivities(String query);
  Future<ActivityBooking> createBooking({
    required ActivityBooking booking,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    String? pickupLocation,
    required String activityName,
  });
}
