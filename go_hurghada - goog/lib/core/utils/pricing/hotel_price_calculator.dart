import 'base_price_calculator.dart';

export 'booking_params.dart';
export 'base_price_calculator.dart';

/// Hotel Room pricing logic
///
/// Two modes based on real booking patterns:
/// - **Per Room** (default): Standard hotels charge per room regardless of guests
/// - **Per Guest**: All-Inclusive resorts charge per person for food/beverage
class HotelPriceCalculator extends BasePriceCalculator {
  /// If true, prices per guest (All-Inclusive style)
  /// If false, prices per room (standard hotel style)
  final bool isPerGuest;

  /// Child discount factor (e.g., 0.5 = 50% of adult rate)
  /// Only applies in per-guest mode
  final double childPriceFactor;

  HotelPriceCalculator({
    required super.basePricePerUnit,
    required super.params,
    this.isPerGuest = false,
    this.childPriceFactor = 0.5, // Kids typically 50% in All-Inclusive
  });

  @override
  double get totalPrice {
    if (isPerGuest) {
      // All-Inclusive: Adults full price, children discounted
      final adultTotal = params.adults * basePricePerUnit;
      final childTotal = params.children * basePricePerUnit * childPriceFactor;
      return (adultTotal + childTotal) * params.nights;
    }
    // Standard: Room price × number of rooms × nights
    return basePricePerUnit * params.rooms * params.nights;
  }

  @override
  String get breakdown {
    final n = params.nights;
    final nightsText = '$n ${n == 1 ? 'night' : 'nights'}';

    if (isPerGuest) {
      final parts = <String>[];
      parts.add('${params.adults} ${params.adults == 1 ? 'adult' : 'adults'}');
      if (params.children > 0) {
        parts.add(
          '${params.children} ${params.children == 1 ? 'child' : 'children'}',
        );
      }
      return '${parts.join(', ')} × $nightsText';
    }

    return '${params.rooms} ${params.rooms == 1 ? 'room' : 'rooms'} × $nightsText';
  }

  /// Helpers for capacity checks
  double get adultsPerRoom => params.adults / params.rooms;
  double get guestsPerRoom => params.totalGuests / params.rooms;
}
