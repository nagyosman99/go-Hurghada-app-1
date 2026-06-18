import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:go_hurghada/core/services/amadeus_token_service.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/flight/domain/entities/search_params.dart';

class AmadeusFlightService {
  final Dio _dio = Dio();
  final AmadeusTokenService _tokenService;

  AmadeusFlightService(this._tokenService);

  Future<List<Flight>> searchFlights(SearchParams params) async {
    final token = await _tokenService.getAccessToken();
    if (token == null) throw Exception('Failed to get Amadeus access token');

    try {
      final response = await _dio.get(
        'https://test.api.amadeus.com/v2/shopping/flight-offers',
        queryParameters: {
          'originLocationCode': params.origin,
          'destinationLocationCode': params.destination,
          'departureDate': params.departureDate.toIso8601String().split('T')[0],
          if (params.isRoundTrip && params.returnDate != null)
            'returnDate': params.returnDate!.toIso8601String().split('T')[0],
          'adults': params.adults,
          'travelClass': params.travelClass.toUpperCase(),
          'max': 20,
          'currencyCode': 'USD',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List?;
        if (data == null || data.isEmpty) return [];
        
        final dictionaries = response.data['dictionaries'];
        final carriers = (dictionaries != null && dictionaries['carriers'] != null)
            ? dictionaries['carriers'] as Map<String, dynamic>
            : <String, dynamic>{};

        return data.map((offer) => _mapToFlight(offer, carriers)).toList();
      }
    } catch (e) {
      debugPrint('Error searching flights: $e');
      if (e is DioException) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['errors'] != null) {
          final errors = errorData['errors'] as List;
          final messages = errors.map((err) => err['detail']).join('. ');
          throw Exception(messages);
        }
        debugPrint('Dio error data: ${e.response?.data}');
      }
      rethrow;
    }
    return [];
  }

  static const List<Map<String, String>> _egyptianAirports = [
    {'name': 'Cairo International Airport', 'city': 'Cairo', 'code': 'CAI'},
    {'name': 'Hurghada International Airport', 'city': 'Hurghada', 'code': 'HRG'},
    {'name': 'Sharm El Sheikh International Airport', 'city': 'Sharm El Sheikh', 'code': 'SSH'},
    {'name': 'Luxor International Airport', 'city': 'Luxor', 'code': 'LXR'},
    {'name': 'Aswan International Airport', 'city': 'Aswan', 'code': 'ASW'},
    {'name': 'Borg El Arab International Airport', 'city': 'Alexandria', 'code': 'HBE'},
    {'name': 'Marsa Alam International Airport', 'city': 'Marsa Alam', 'code': 'RMF'},
    {'name': 'Sohag International Airport', 'city': 'Sohag', 'code': 'HMB'},
    {'name': 'Asyut International Airport', 'city': 'Asyut', 'code': 'ATY'},
  ];

  Future<List<Map<String, String>>> searchAirports(String query) async {
    if (query.trim().isEmpty) return _egyptianAirports;
    
    final lowercaseQuery = query.toLowerCase().trim();
    return _egyptianAirports.where((airport) {
      final name = airport['name']!.toLowerCase();
      final city = airport['city']!.toLowerCase();
      final code = airport['code']!.toLowerCase();
      return name.contains(lowercaseQuery) || 
             city.contains(lowercaseQuery) || 
             code.contains(lowercaseQuery);
    }).toList();
  }

  Flight _mapToFlight(Map<String, dynamic> offer, Map<String, dynamic> carriers) {
    final itineraries = offer['itineraries'] as List;
    final firstItinerary = itineraries[0];
    final segments = firstItinerary['segments'] as List;
    final firstSegment = segments[0];
    final lastSegment = segments[segments.length - 1];

    final airlineCode = offer['validatingCarrierCodes'][0];
    final airlineName = carriers[airlineCode] ?? airlineCode;

    return Flight(
      id: offer['id'],
      airlineCode: airlineCode,
      airlineName: airlineName,
      origin: firstSegment['departure']['iataCode'],
      destination: lastSegment['arrival']['iataCode'],
      departureTime: DateTime.parse(firstSegment['departure']['at']),
      arrivalTime: DateTime.parse(lastSegment['arrival']['at']),
      durationMinutes: _parseDuration(firstItinerary['duration']),
      stops: segments.length - 1,
      price: double.parse(offer['price']['total']),
      currency: offer['price']['currency'],
      bookingUrl: 'https://www.amadeus.com', // Placeholder
      flightNumber: '${firstSegment['carrierCode']}${firstSegment['number']}',
      aircraftType: firstSegment['aircraft']['code'],
    );
  }

  int _parseDuration(String duration) {
    // Format: P[n]DT[n]H[n]M
    final regex = RegExp(r'P(?:(\d+)D)?T(?:(\d+)H)?(?:(\d+)M)?');
    final match = regex.firstMatch(duration);
    if (match != null) {
      final days = int.parse(match.group(1) ?? '0');
      final hours = int.parse(match.group(2) ?? '0');
      final minutes = int.parse(match.group(3) ?? '0');
      return (days * 24 * 60) + (hours * 60) + minutes;
    }
    return 0;
  }
}
