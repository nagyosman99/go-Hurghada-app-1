import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_hurghada/core/services/booking_api_service.dart';
import 'package:go_hurghada/features/booking/data/booking_repository.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';

/// Firestore-backed [BookingRepository].
///
/// * Hotel booking creation → Express backend (atomic Firestore transaction)
/// * Cancellation          → Express backend (restores availability atomically)
/// * Read bookings         → Firestore top-level `bookings` collection
///   (filtered by current userId)
class FirebaseBookingRepository implements BookingRepository {
  final FirebaseFirestore _firestore;
  late final FirebaseAuth? _auth;
  final BookingApiService _api;

  FirebaseBookingRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    BookingApiService? api,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _api = api ?? BookingApiService() {
    FirebaseAuth? authInstance;
    try {
      authInstance = auth ?? FirebaseAuth.instance;
    } catch (_) {
      // Fallback for Windows
    }
    _auth = authInstance;
  }

  // ─── Read ────────────────────────────────────────────────────────────────

  @override
  Future<List<Booking>> getBookings() async {
    final uid = _auth?.currentUser?.uid;
    if (uid == null) return [];

    try {
      final snap = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs.map((doc) {
        final data = doc.data();
        return _fromFirestoreMap(doc.id, data);
      }).toList();
    } catch (e) {
      debugPrint('[FirebaseBookingRepository] getBookings error: $e');
      return [];
    }
  }

  // ─── Create (hotel bookings via backend) ─────────────────────────────────

  /// Creates a hotel booking via the Express backend.
  /// Returns the generated [bookingId].
  /// Throws [RoomNotAvailableException] if any date is fully booked.
  Future<String> createHotelBooking({
    required String hotelId,
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required String guestName,
    required String guestEmail,
    required String hotelName,
    required String roomName,
    required double totalPrice,
  }) async {
    final uid = _auth?.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in.');

    final checkInStr = BookingApiService.toDateString(checkIn);
    final checkOutStr = BookingApiService.toDateString(checkOut);

    return _api.createBooking(
      hotelId: hotelId,
      roomId: roomId,
      checkIn: checkInStr,
      checkOut: checkOutStr,
      userId: uid,
      guestName: guestName,
      guestEmail: guestEmail,
      hotelName: hotelName,
      roomName: roomName,
      totalPrice: totalPrice,
    );
  }

  // ─── saveBooking (used for activity bookings — still stored locally or in
  //     a user subcollection, unchanged from before) ────────────────────────

  @override
  Future<void> saveBooking(Booking booking) async {
    final uid = _auth?.currentUser?.uid;
    if (uid == null) return;

    try {
      // Activity bookings go to users/{uid}/bookings subcollection
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookings')
          .doc(booking.id)
          .set(_toFirestoreMap(booking));
    } catch (e) {
      debugPrint('[FirebaseBookingRepository] saveBooking error: $e');
      rethrow;
    }
  }

  // ─── Cancel ──────────────────────────────────────────────────────────────

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      // Try backend cancel first (hotel bookings in top-level collection)
      await _api.cancelBooking(bookingId);
    } catch (e) {
      if (e is BookingApiException && e.statusCode == 404) {
        // Fallback: activity booking in user subcollection
        await _cancelActivityBooking(bookingId);
      } else {
        rethrow;
      }
    }
  }

  Future<void> _cancelActivityBooking(String bookingId) async {
    final uid = _auth?.currentUser?.uid;
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('bookings')
        .doc(bookingId)
        .update({'status': 'cancelled'});
  }

  // ─── Delete (UI only — removes from user subcollection) ──────────────────

  @override
  Future<void> deleteBooking(String bookingId) async {
    final uid = _auth?.currentUser?.uid;
    if (uid == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookings')
          .doc(bookingId)
          .delete();
    } catch (_) {
      // If not in subcollection, silently ignore
    }
  }

  // ─── Conversion helpers ───────────────────────────────────────────────────

  static Booking _fromFirestoreMap(String id, Map<String, dynamic> data) {
    DateTime? parseTs(dynamic v) {
      if (v == null) return null;
      if (v is Timestamp) return v.toDate();
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    DateTime parseDate(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is String) {
        // YYYY-MM-DD → treat as UTC noon to avoid timezone issues
        final parts = v.split('-');
        if (parts.length == 3) {
          return DateTime.utc(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
            12,
          );
        }
        return DateTime.tryParse(v) ?? DateTime.now();
      }
      return DateTime.now();
    }

    final typeStr = data['type'] as String? ?? 'hotel';
    final type =
        typeStr == 'activity' ? BookingType.activity : BookingType.hotel;

    return Booking(
      id: id,
      type: type,
      hotelId: data['hotelId'] as String?,
      hotelName: data['hotelName'] as String?,
      roomId: data['roomId'] as String?,
      roomName: data['roomName'] as String?,
      checkInDate: data['checkIn'] != null ? parseDate(data['checkIn']) : null,
      checkOutDate:
          data['checkOut'] != null ? parseDate(data['checkOut']) : null,
      activityId: data['activityId'] as String?,
      activityName: data['activityName'] as String?,
      selectedDate: parseTs(data['selectedDate']),
      persons: (data['persons'] as num?)?.toInt(),
      pickupLocation: data['pickupLocation'] as String?,
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
      guestName: data['guestName'] as String? ?? '',
      guestEmail: data['guestEmail'] as String? ?? '',
      guestPhone: data['guestPhone'] as String? ?? '',
      adults: (data['adults'] as num?)?.toInt() ?? 2,
      children: (data['children'] as num?)?.toInt() ?? 0,
      roomsCount: (data['roomsCount'] as num?)?.toInt() ?? 1,
      status: data['status'] as String? ?? 'confirmed',
      createdAt: parseTs(data['createdAt']) ?? DateTime.now(),
    );
  }

  static Map<String, dynamic> _toFirestoreMap(Booking b) {
    String currentUid = '';
    try {
      currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    } catch (_) {}

    return {
      'userId': currentUid,
      'type': b.type.name,
      'hotelId': b.hotelId,
      'hotelName': b.hotelName,
      'roomId': b.roomId,
      'roomName': b.roomName,
      'checkIn': b.checkInDate?.toIso8601String(),
      'checkOut': b.checkOutDate?.toIso8601String(),
      'activityId': b.activityId,
      'activityName': b.activityName,
      'selectedDate': b.selectedDate?.toIso8601String(),
      'persons': b.persons,
      'pickupLocation': b.pickupLocation,
      'totalPrice': b.totalPrice,
      'guestName': b.guestName,
      'guestEmail': b.guestEmail,
      'guestPhone': b.guestPhone,
      'adults': b.adults,
      'children': b.children,
      'roomsCount': b.roomsCount,
      'status': b.status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
