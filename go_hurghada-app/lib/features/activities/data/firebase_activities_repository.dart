import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_hurghada/features/activities/domain/repository/activities_repository.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity_booking.dart';

class FirebaseActivitiesRepository implements ActivitiesRepository {
  final FirebaseFirestore _firestore;

  FirebaseActivitiesRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Activity>> getAllActivities() async {
    try {
      final snapshot = await _firestore.collection('activities').get();
      debugPrint('[FirebaseActivitiesRepository] Found ${snapshot.docs.length} activities');
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Activity.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('[FirebaseActivitiesRepository] Error fetching activities: $e');
      rethrow;
    }
  }

  @override
  Future<List<Activity>> getActivitiesByCategory(String category) async {
    final snapshot = await _firestore
        .collection('activities')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs
        .map((doc) => Activity.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<List<Activity>> searchActivities(String query) async {
    final all = await getAllActivities();
    if (query.isEmpty) return all;
    final lowerQuery = query.toLowerCase();
    final filtered = all
        .where((a) =>
            a.title.toLowerCase().contains(lowerQuery) ||
            a.category.toLowerCase().contains(lowerQuery) ||
            a.description.toLowerCase().contains(lowerQuery))
        .toList();
    // Fallback to all if no match (handles broad AI queries)
    return filtered.isEmpty ? all : filtered;
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
    final data = {
      ...booking.toJson(),
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
      'pickupLocation': pickupLocation,
      'activityName': activityName,
      'createdAt': FieldValue.serverTimestamp(),
    };

    debugPrint('[FirebaseActivitiesRepository] Saving booking for user: ${data['userId']}');

    data['type'] = 'activity';
    data['status'] = 'confirmed';

    final docRef = await _firestore.collection('bookings').add(data);
    return booking.copyWith(bookingId: docRef.id);
  }
}
