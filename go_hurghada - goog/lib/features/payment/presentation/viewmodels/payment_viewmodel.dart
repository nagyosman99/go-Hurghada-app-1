import 'package:flutter/material.dart';
import 'package:go_hurghada/core/services/payment_service.dart';
import 'package:go_hurghada/features/payment/domain/models/payment_request.dart';

class PaymentState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const PaymentState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  PaymentState copyWith({bool? isLoading, String? error, bool? isSuccess}) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// ViewModel for managing the payment process and state.
class PaymentViewModel extends ChangeNotifier {
  final PaymentService _paymentService;

  PaymentViewModel({required PaymentService paymentService})
    : _paymentService = paymentService;

  PaymentState _state = const PaymentState();

  /// The current payment processing state.
  PaymentState get state => _state;

  /// Processes a payment request using the payment service.
  Future<bool> processPayment(PaymentRequest request) async {
    _state = _state.copyWith(isLoading: true, error: null, isSuccess: false);
    notifyListeners();

    try {
      final success = await _paymentService.processPayment(request);
      if (success) {
        _state = _state.copyWith(isLoading: false, isSuccess: true);
      } else {
        _state = _state.copyWith(
          isLoading: false,
          error: 'Payment processing failed',
        );
      }
      notifyListeners();
      return success;
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = const PaymentState();
    notifyListeners();
  }
}
