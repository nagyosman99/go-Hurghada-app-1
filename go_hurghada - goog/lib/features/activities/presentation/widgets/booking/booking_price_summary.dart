import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';

class BookingPriceSummary extends StatelessWidget {
  final ActivityPriceCalculator calculator;
  final bool freeCancellation;

  const BookingPriceSummary({
    super.key,
    required this.calculator,
    required this.freeCancellation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${calculator.basePricePerUnit.formatPrice(context)} x ${calculator.params.adults} ${calculator.params.adults > 1 ? 'persons' : 'person'}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                calculator.totalPrice.formatPrice(context),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (freeCancellation) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Free cancellation up to 24h',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                calculator.totalPrice.formatPrice(context),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
