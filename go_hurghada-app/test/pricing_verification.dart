// Quick verification script for HotelPriceCalculator
// Run with: dart run test/pricing_verification.dart

import '../lib/core/utils/pricing_models.dart';

void main() {
  print('=== Hotel Price Calculator Verification ===\n');

  // Test Case 1: Standard Hotel (Per Room)
  print('--- Test 1: Standard Hotel (2 rooms, 3 nights) ---');
  final standardCalc = HotelPriceCalculator(
    basePricePerUnit: 100.0, // $100 per room/night
    params: BookingParams(
      checkIn: DateTime(2024, 1, 1),
      checkOut: DateTime(2024, 1, 4), // 3 nights
      rooms: 2,
      adults: 4,
      children: 2,
    ),
    isPerGuest: false,
  );
  print('Base Price: \$100 per room/night');
  print('Rooms: 2, Nights: 3');
  print('Expected Total: \$100 × 2 × 3 = \$600');
  print('Actual Total: \$${standardCalc.totalPrice}');
  print('Breakdown: ${standardCalc.breakdown}');
  print('PASS: ${standardCalc.totalPrice == 600.0 ? "✅" : "❌"}\n');

  // Test Case 2: All-Inclusive Hotel (Per Guest)
  print('--- Test 2: All-Inclusive Hotel (2 adults, 3 children, 3 nights) ---');
  final allInclusiveCalc = HotelPriceCalculator(
    basePricePerUnit: 100.0, // $100 per adult/night
    params: BookingParams(
      checkIn: DateTime(2024, 1, 1),
      checkOut: DateTime(2024, 1, 4), // 3 nights
      rooms: 1,
      adults: 2,
      children: 3,
    ),
    isPerGuest: true,
    childPriceFactor: 0.5, // Children at 50%
  );
  print('Base Price: \$100 per adult/night, \$50 per child/night');
  print('Adults: 2, Children: 3, Nights: 3');
  print('Expected Total: ((2 × \$100) + (3 × \$50)) × 3 = \$1050');
  print('Actual Total: \$${allInclusiveCalc.totalPrice}');
  print('Breakdown: ${allInclusiveCalc.breakdown}');
  print('PASS: ${allInclusiveCalc.totalPrice == 1050.0 ? "✅" : "❌"}\n');

  // Test Case 3: Single Room, Single Night
  print('--- Test 3: Single Room, Single Night ---');
  final singleCalc = HotelPriceCalculator(
    basePricePerUnit: 150.0,
    params: BookingParams(
      checkIn: DateTime(2024, 1, 1),
      checkOut: DateTime(2024, 1, 2), // 1 night
      rooms: 1,
      adults: 2,
      children: 0,
    ),
    isPerGuest: false,
  );
  print('Base Price: \$150 per room/night');
  print('Rooms: 1, Nights: 1');
  print('Expected Total: \$150');
  print('Actual Total: \$${singleCalc.totalPrice}');
  print('PASS: ${singleCalc.totalPrice == 150.0 ? "✅" : "❌"}\n');

  // Test Case 4: Discount Application
  print('--- Test 4: Discount Application (20% off) ---');
  final discountCalc = HotelPriceCalculator(
    basePricePerUnit: 200.0,
    params: BookingParams(
      checkIn: DateTime(2024, 1, 1),
      checkOut: DateTime(2024, 1, 3), // 2 nights
      rooms: 1,
      adults: 2,
      children: 0,
    ),
    isPerGuest: false,
  );
  final discountedPrice = discountCalc.getDiscountedPrice(0.20);
  print('Base Price: \$200 per room/night');
  print('Rooms: 1, Nights: 2, Discount: 20%');
  print('Original Total: \$${discountCalc.totalPrice}');
  print('Expected Discounted: \$320');
  print('Actual Discounted: \$${discountedPrice}');
  print('PASS: ${discountedPrice == 320.0 ? "✅" : "❌"}\n');

  // Test Case 5: All-Inclusive with Many Children
  print(
    '--- Test 5: All-Inclusive with Many Children (2 adults, 5 children) ---',
  );
  final manyKidsCalc = HotelPriceCalculator(
    basePricePerUnit: 80.0,
    params: BookingParams(
      checkIn: DateTime(2024, 1, 1),
      checkOut: DateTime(2024, 1, 5), // 4 nights
      rooms: 2,
      adults: 2,
      children: 5,
    ),
    isPerGuest: true,
    childPriceFactor: 0.5,
  );
  // Adults: 2 × 80 = 160, Children: 5 × 40 = 200, Total per night: 360 × 4 = 1440
  print('Base Price: \$80 per adult/night, \$40 per child/night');
  print('Adults: 2, Children: 5, Nights: 4');
  print('Expected Total: ((2 × 80) + (5 × 40)) × 4 = \$1440');
  print('Actual Total: \$${manyKidsCalc.totalPrice}');
  print('Breakdown: ${manyKidsCalc.breakdown}');
  print('PASS: ${manyKidsCalc.totalPrice == 1440.0 ? "✅" : "❌"}\n');

  print('=== All Tests Complete ===');
}
