import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for handling currency conversion and formatting.
class CurrencyService {
  final Dio _dio = Dio();
  final String _apiUrl = 'https://open.er-api.com/v6/latest/USD';

  // Default exchange rates (Base: USD) - fallback if API fails
  Map<String, double> _rates = {
    'USD': 1.0,
    'EGP': 48.5,
    'AED': 3.67,
    'EUR': 0.92,
  };

  static final Map<String, String> _symbols = {
    'USD': r'$',
    'EGP': 'EGP ',
    'AED': 'AED ',
    'EUR': '€',
  };

  /// Initializes the service by loading cached rates.
  Future<void> init() async {
    final box = Hive.box('currency_rates');
    final cachedRates = box.get('rates');
    if (cachedRates != null) {
      _rates = Map<String, double>.from(
        (cachedRates as Map).map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        ),
      );
      debugPrint('CurrencyService: Loaded cached rates: $_rates');
    }
  }

  /// Fetches the latest exchange rates from the API.
  Future<void> fetchLatestRates() async {
    try {
      final response = await _dio.get(_apiUrl);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['result'] == 'success') {
          final newRates = Map<String, double>.from(
            (data['rates'] as Map).map(
              (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
            ),
          );

          // We only care about our supported currencies to keep memory low
          final supportedOnly = <String, double>{};
          for (final code in supportedCurrencies) {
            if (newRates.containsKey(code)) {
              supportedOnly[code] = newRates[code]!;
            }
          }

          if (supportedOnly.isNotEmpty) {
            _rates = supportedOnly;
            final box = Hive.box('currency_rates');
            await box.put('rates', _rates);
            debugPrint('CurrencyService: Rates updated from API: $_rates');
          }
        }
      }
    } catch (e) {
      debugPrint('CurrencyService: Error fetching rates: $e');
      // Fallback to defaults or cache is already handled in init()
    }
  }

  /// Converts a price from USD to the target currency.
  double convertFromUsd(double amount, String targetCurrency) {
    if (targetCurrency == 'USD') return amount;
    final rate = _rates[targetCurrency] ?? 1.0;
    return amount * rate;
  }

  /// Formats a price with its currency symbol.
  String formatPrice(double amount, String currencyCode) {
    final symbol = _symbols[currencyCode] ?? r'$';
    final formattedAmount = amount.toStringAsFixed(0);

    return '$symbol$formattedAmount';
  }

  /// Gets the symbol for a currency code.
  String getSymbol(String currencyCode) {
    return _symbols[currencyCode] ?? r'$';
  }

  /// List of supported currency codes.
  List<String> get supportedCurrencies => ['USD', 'EGP', 'AED', 'EUR'];
}
