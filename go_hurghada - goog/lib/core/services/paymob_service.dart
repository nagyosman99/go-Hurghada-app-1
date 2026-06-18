import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PayMobService {
  static const String _baseUrl = 'https://accept.paymob.com/api';

  String get _apiKey => dotenv.env['PAYMOB_API_KEY'] ?? '';
  String get _integrationId => dotenv.env['PAYMOB_INTEGRATION_ID'] ?? '';
  String get _iframeId => dotenv.env['PAYMOB_IFRAME_ID'] ?? '';

  /// Step 1: Get authentication token from PayMob
  Future<String> _getAuthToken() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/tokens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'api_key': _apiKey}),
    );

    if (response.statusCode != 201) {
      throw Exception('PayMob Auth failed: ${response.body}');
    }

    final data = jsonDecode(response.body);
    debugPrint('[PayMob] ✅ Auth token obtained');
    return data['token'] as String;
  }

  /// Step 2: Register the order with PayMob
  Future<int> _registerOrder({
    required String authToken,
    required int amountCents,
    required String currency,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ecommerce/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'auth_token': authToken,
        'delivery_needed': false,
        'amount_cents': amountCents,
        'currency': currency,
        'items': [],
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('PayMob Order Registration failed: ${response.body}');
    }

    final data = jsonDecode(response.body);
    debugPrint('[PayMob] ✅ Order registered: ${data['id']}');
    return data['id'] as int;
  }

  /// Step 3: Generate payment key for the iframe
  Future<String> _getPaymentKey({
    required String authToken,
    required int orderId,
    required int amountCents,
    required String currency,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) async {
    // Split full name into first and last
    final nameParts = customerName.trim().split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.last : 'N/A';

    final response = await http.post(
      Uri.parse('$_baseUrl/acceptance/payment_keys'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'auth_token': authToken,
        'amount_cents': amountCents,
        'expiration': 3600,
        'order_id': orderId,
        'billing_data': {
          'apartment': 'NA',
          'email': customerEmail.isNotEmpty ? customerEmail : 'guest@gohurghada.com',
          'floor': 'NA',
          'first_name': firstName,
          'street': 'NA',
          'building': 'NA',
          'phone_number': customerPhone.isNotEmpty ? customerPhone : '+201000000000',
          'shipping_method': 'NA',
          'postal_code': 'NA',
          'city': 'Hurghada',
          'country': 'EG',
          'last_name': lastName,
          'state': 'Red Sea',
        },
        'currency': currency,
        'integration_id': int.parse(_integrationId),
        'lock_order_when_paid': false,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('PayMob Payment Key failed: ${response.body}');
    }

    final data = jsonDecode(response.body);
    debugPrint('[PayMob] ✅ Payment key obtained');
    return data['token'] as String;
  }

  /// Main method: Generate the full PayMob payment URL
  Future<String> generatePaymentUrl({
    required double amount,
    required String currency,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) async {
    // Convert amount to cents (PayMob uses smallest currency unit)
    final amountCents = (amount * 100).round();

    debugPrint('[PayMob] Starting payment flow for $amountCents cents ($currency)');

    final authToken = await _getAuthToken();
    final orderId = await _registerOrder(
      authToken: authToken,
      amountCents: amountCents,
      currency: currency,
    );
    final paymentKey = await _getPaymentKey(
      authToken: authToken,
      orderId: orderId,
      amountCents: amountCents,
      currency: currency,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
    );

    final url = 'https://accept.paymob.com/api/acceptance/iframes/$_iframeId?payment_token=$paymentKey';
    debugPrint('[PayMob] ✅ Payment URL ready');
    return url;
  }
}
