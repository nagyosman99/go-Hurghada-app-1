import 'booking_params.dart';

/// Abstract base for all price calculations
abstract class BasePriceCalculator {
  final double basePricePerUnit;
  final BookingParams params;

  BasePriceCalculator({required this.basePricePerUnit, required this.params}) {
    params.validate();
    if (basePricePerUnit < 0) {
      throw ArgumentError('Price cannot be negative');
    }
  }

  double get totalPrice;

  /// Utility for safe double comparison
  static bool arePricesEqual(double p1, double p2) {
    return (p1 - p2).abs() < 1e-10;
  }

  /// Clamp discount between 0.0 and 1.0
  double clampDiscount(double discount) {
    return discount.clamp(0.0, 1.0);
  }

  double getDiscountedPrice(double discountPercentage) {
    final clamped = clampDiscount(discountPercentage);
    return totalPrice * (1 - clamped);
  }

  double getSavingsAmount(double discountPercentage) {
    final clamped = clampDiscount(discountPercentage);
    return totalPrice * clamped;
  }

  String get breakdown;
}
