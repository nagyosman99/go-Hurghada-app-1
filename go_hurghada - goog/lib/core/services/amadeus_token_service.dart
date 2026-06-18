import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmadeusTokenService {
  final Dio _dio = Dio();
  String? _accessToken;
  DateTime? _expiryTime;

  Future<String?> getAccessToken() async {
    // Return cached token if valid
    if (_accessToken != null && _expiryTime != null) {
      if (DateTime.now().isBefore(_expiryTime!)) {
        return _accessToken;
      }
    }

    // Otherwise, fetch new token
    return await _fetchNewToken();
  }

  Future<String?> _fetchNewToken() async {
    final apiKey = dotenv.env['AMADEUS_API_KEY'];
    final apiSecret = dotenv.env['AMADEUS_API_SECRET'];

    if (apiKey == null || apiSecret == null) {
      throw Exception('Amadeus API credentials not found in .env');
    }

    try {
      final response = await _dio.post(
        'https://test.api.amadeus.com/v1/security/oauth2/token',
        data: {
          'grant_type': 'client_credentials',
          'client_id': apiKey,
          'client_secret': apiSecret,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        _accessToken = response.data['access_token'];
        final int expiresIn = response.data['expires_in']; // seconds
        // Set expiry time slightly earlier to be safe
        _expiryTime = DateTime.now().add(Duration(seconds: expiresIn - 60));
        return _accessToken;
      }
    } catch (e) {
      print('Error fetching Amadeus token: $e');
    }
    return null;
  }
}
