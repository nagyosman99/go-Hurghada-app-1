import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// One-time utility that adds `totalCount` to all rooms that are missing it.
///
/// Call this once from a debug button in the app (e.g. admin screen) or
/// from the Firebase console using the Admin SDK.
///
/// Usage:
///   await RoomMigrationHelper.addTotalCountToAllRooms(defaultCount: 5);
class RoomMigrationHelper {
  static Future<void> addTotalCountToAllRooms({int defaultCount = 5}) async {
    final firestore = FirebaseFirestore.instance;

    debugPrint('[Migration] Starting totalCount migration...');
    int updated = 0;

    final hotelsSnap = await firestore.collection('hotels').get();

    for (final hotelDoc in hotelsSnap.docs) {
      final roomsSnap = await hotelDoc.reference.collection('rooms').get();

      for (final roomDoc in roomsSnap.docs) {
        final data = roomDoc.data();

        if (data['totalCount'] == null) {
          await roomDoc.reference.update({'totalCount': defaultCount});
          debugPrint(
              '[Migration] Updated ${hotelDoc.id}/${roomDoc.id} → totalCount=$defaultCount');
          updated++;
        }
      }
    }

    debugPrint('[Migration] Done. Updated $updated rooms.');
  }

  /// Adds/updates totalCount for a SPECIFIC hotel's rooms.
  static Future<void> setTotalCountForHotel(
    String hotelId, {
    int defaultCount = 5,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final roomsSnap = await firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('rooms')
        .get();

    for (final roomDoc in roomsSnap.docs) {
      await roomDoc.reference.update({'totalCount': defaultCount});
      debugPrint(
          '[Migration] Set totalCount=$defaultCount on $hotelId/${roomDoc.id}');
    }

    debugPrint('[Migration] Done for hotel $hotelId.');
  }
}
