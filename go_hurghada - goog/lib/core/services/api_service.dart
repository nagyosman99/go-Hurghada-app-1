import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API Service template prepared for future Amadeus API integration
/// Currently not used - using mock data instead
class ApiService {
  late final Dio _dio;
  final String baseUrl;

  ApiService({String? baseUrl})
    : baseUrl = baseUrl ?? dotenv.env['BACKEND_PROXY_URL'] ?? '' {
    _dio = Dio(
      BaseOptions(
        baseUrl: this.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  /// Search flights using Amadeus API (Future Implementation)
  ///
  /// Parameters:
  /// - origin: IATA code of origin airport
  /// - destination: IATA code of destination airport
  /// - departureDate: Date in YYYY-MM-DD format
  /// - returnDate: Optional return date for round trips
  /// - adults: Number of adult passengers
  /// - travelClass: ECONOMY, PREMIUM_ECONOMY, BUSINESS, FIRST
  Future<Response> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    String? returnDate,
    int adults = 1,
    String travelClass = 'ECONOMY',
  }) async {
    try {
      final response = await _dio.get(
        '/searchFlights',
        queryParameters: {
          'origin': origin,
          'destination': destination,
          'departureDate': departureDate,
          if (returnDate != null) 'returnDate': returnDate,
          'adults': adults,
          'travelClass': travelClass,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get city/airport codes (Future Implementation)
  Future<Response> getCityCodes() async {
    try {
      final response = await _dio.get('/getCityCodes');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
