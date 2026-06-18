import 'package:flutter/material.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/core/providers/currency_scope.dart';

extension CurrencyFormatting on double {
  /// Formats this double as a price based on the current app settings.
  String formatPrice(BuildContext context) {
    final appProvider = AppProvider.of(context);
    final currencyCode = CurrencyScope.of(context);
    final currencyService = appProvider.currencyService;

    final convertedAmount = currencyService.convertFromUsd(this, currencyCode);
    return currencyService.formatPrice(convertedAmount, currencyCode);
  }

  /// Formats this double as a price but keeps it as USD.
  String formatUsd() {
    return '\$${toStringAsFixed(0)}';
  }
}
