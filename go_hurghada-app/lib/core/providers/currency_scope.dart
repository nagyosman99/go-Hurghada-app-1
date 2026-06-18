import 'package:flutter/material.dart';

/// An InheritedWidget that provides the current currency code to its descendants.
/// It rebuilds dependents when the currency code changes.
class CurrencyScope extends InheritedWidget {
  final String currencyCode;

  const CurrencyScope({
    super.key,
    required this.currencyCode,
    required super.child,
  });

  static String of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CurrencyScope>();
    if (scope == null) {
      // Fallback or throw. Returing 'USD' as safe default or throwing if strictly required.
      // Ideally this should always be found if wrapped correctly in main.dart
      return 'USD';
    }
    return scope.currencyCode;
  }

  static String? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CurrencyScope>();
    return scope?.currencyCode;
  }

  @override
  bool updateShouldNotify(CurrencyScope oldWidget) {
    if (currencyCode != oldWidget.currencyCode) {
      debugPrint(
        'CurrencyScope: Updating from ${oldWidget.currencyCode} to $currencyCode',
      );
      return true;
    }
    return false;
  }
}
