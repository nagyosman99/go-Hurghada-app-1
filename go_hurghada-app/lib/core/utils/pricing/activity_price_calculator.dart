import 'base_price_calculator.dart';

export 'booking_params.dart';
export 'base_price_calculator.dart';

/// Activity/Tour pricing logic (Per-Guest)
///
/// Activities are always priced per person.
/// Common in real apps: adults and children have different rates.
class ActivityPriceCalculator extends BasePriceCalculator {
  /// Optional child-specific price (defaults to same as adult if not set)
  final double? childPricePerUnit;

  ActivityPriceCalculator({
    required super.basePricePerUnit,
    required super.params,
    this.childPricePerUnit,
  });

  @override
  double get totalPrice {
    final effectiveChildPrice = childPricePerUnit ?? basePricePerUnit;
    final adultTotal = params.adults * basePricePerUnit;
    final childTotal = params.children * effectiveChildPrice;
    return adultTotal + childTotal;
  }

  @override
  String get breakdown {
    final parts = <String>[];
    parts.add('${params.adults} ${params.adults == 1 ? 'adult' : 'adults'}');
    if (params.children > 0) {
      parts.add(
        '${params.children} ${params.children == 1 ? 'child' : 'children'}',
      );
    }
    return parts.join(', ');
  }
}
