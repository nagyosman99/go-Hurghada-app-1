import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_request.freezed.dart';
part 'payment_request.g.dart';

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required double amount,
    required String currency,
    required String description,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    required bool isPayAtHotel,
  }) = _PaymentRequest;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);
}
