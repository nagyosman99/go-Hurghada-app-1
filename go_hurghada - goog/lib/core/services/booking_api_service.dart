import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Exception thrown when the room is not available (HTTP 409).
class RoomNotAvailableException implements Exception {
  final String message;
  final String? date;
  const RoomNotAvailableException(this.message, {this.date});

  @override
  String toString() => message;
}

/// Exception for generic API errors.
class BookingApiException implements Exception {
  final int statusCode;
  final String message;
  const BookingApiException(this.statusCode, this.message);

  @override
  String toString() => 'API Error $statusCode: $message';
}

/// Model for a single date's availability returned by GET /api/availability.
class DateAvailability {
  final String date;
  final bool available;
  final int bookedCount;
  final int totalCount;
  final int remainingRooms;

  const DateAvailability({
    required this.date,
    required this.available,
    required this.bookedCount,
    required this.totalCount,
    required this.remainingRooms,
  });

  factory DateAvailability.fromJson(Map<String, dynamic> json) {
    return DateAvailability(
      date: json['date'] as String,
      available: json['available'] as bool,
      bookedCount: (json['bookedCount'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 1,
      remainingRooms: (json['remainingRooms'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Handles all HTTP calls to the Express availability/booking backend.
class BookingApiService {
  static String get _baseUrl {
    final url = dotenv.maybeGet('BACKEND_URL');
    if (url != null && url.isNotEmpty) return url;

    // Default fallbacks based on platform
    if (kIsWeb) return 'http://localhost:5000';

    // 10.0.2.2 is the special alias to the host loopback for Android emulators
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }

    // iOS Simulator, Windows, macOS use localhost
    return 'http://localhost:5000';
  }

  /// GET /api/availability?hotelId=...&roomId=...&startDate=...&endDate=...
  ///
  /// Returns a list of [DateAvailability] for each night in the range.
  Future<List<DateAvailability>> checkAvailability({
    required String hotelId,
    required String roomId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final start = BookingApiService.toDateString(startDate);
    final end = BookingApiService.toDateString(endDate);

    final uri = Uri.parse('$_baseUrl/api/availability').replace(
      queryParameters: {
        'hotelId': hotelId,
        'roomId': roomId,
        'startDate': start,
        'endDate': end,
      },
    );

    debugPrint('[BookingApiService] GET $uri');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((e) => DateAvailability.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        final body = _parseError(response.body);
        throw BookingApiException(response.statusCode, body);
      }
    } catch (e) {
      if (e is BookingApiException || e is RoomNotAvailableException) rethrow;
      throw BookingApiException(0, 'Network error: $e');
    }
  }

  /// POST /api/hotel-bookings
  ///
  /// Returns the [bookingId] on success.
  /// Throws [RoomNotAvailableException] on 409.
  Future<String> createBooking({
    required String hotelId,
    required String roomId,
    required String checkIn,   // YYYY-MM-DD
    required String checkOut,  // YYYY-MM-DD
    required String userId,
    required String guestName,
    required String guestEmail,
    required String hotelName,
    required String roomName,
    required double totalPrice,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/hotel-bookings');

    final body = jsonEncode({
      'hotelId': hotelId,
      'roomId': roomId,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'userId': userId,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'hotelName': hotelName,
      'roomName': roomName,
      'totalPrice': totalPrice,
    });

    debugPrint('[BookingApiService] POST $uri');

    try {
      final response = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['bookingId'] as String;
      } else if (response.statusCode == 409) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw RoomNotAvailableException(
          data['message'] as String? ?? 'Room not available',
          date: data['date'] as String?,
        );
      } else {
        final err = _parseError(response.body);
        throw BookingApiException(response.statusCode, err);
      }
    } catch (e) {
      if (e is BookingApiException || e is RoomNotAvailableException) rethrow;
      throw BookingApiException(0, 'Network error: $e');
    }
  }

  /// PATCH /api/hotel-bookings/:bookingId/cancel
  ///
  /// Cancels the booking and restores availability atomically.
  Future<void> cancelBooking(String bookingId) async {
    final uri = Uri.parse('$_baseUrl/api/hotel-bookings/$bookingId/cancel');

    debugPrint('[BookingApiService] PATCH $uri');

    try {
      final response = await http
          .patch(uri, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) return;

      final err = _parseError(response.body);
      throw BookingApiException(response.statusCode, err);
    } catch (e) {
      if (e is BookingApiException) rethrow;
      throw BookingApiException(0, 'Network error: $e');
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Converts a [DateTime] to a local 'YYYY-MM-DD' string to avoid timezone shifts.
  static String toDateString(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }

  static String _parseError(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      return data['message'] as String? ?? data['error'] as String? ?? body;
    } catch (_) {
      return body;
    }
  }
}
