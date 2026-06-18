import 'package:go_hurghada/core/services/paymob_service.dart';
import 'package:go_hurghada/features/payment/domain/models/payment_request.dart';

abstract class PaymentService {
  Future<bool> processPayment(PaymentRequest request);
}

/// Mock service - always returns true (used in tests)
class MockPaymentService implements PaymentService {
  @override
  Future<bool> processPayment(PaymentRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

/// Real PayMob service - generates payment URL for WebView
class PayMobPaymentService implements PaymentService {
  final PayMobService _paymobService;

  PayMobPaymentService({PayMobService? paymobService})
      : _paymobService = paymobService ?? PayMobService();

  String? _lastPaymentUrl;

  /// Returns the last generated payment URL (used by payment screen to open WebView)
  String? get lastPaymentUrl => _lastPaymentUrl;

  @override
  Future<bool> processPayment(PaymentRequest request) async {
    // For "pay at hotel" - no real payment needed
    if (request.isPayAtHotel) {
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    }

    // Generate PayMob payment URL
    _lastPaymentUrl = await _paymobService.generatePaymentUrl(
      amount: request.amount,
      currency: request.currency,
      customerName: request.customerName,
      customerEmail: request.customerEmail,
      customerPhone: request.customerPhone,
    );

    // Return null URL as signal to open WebView
    // The actual success/failure comes from the WebView result
    return true;
  }
}
