import 'package:flutter/material.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

/// Reusable price display widget
///
/// Shows price information in a consistent format across the app
class PriceDisplay extends StatelessWidget {
  final BasePriceCalculator calculator;
  final bool showBreakdown;
  final bool compact;

  const PriceDisplay({
    super.key,
    required this.calculator,
    this.showBreakdown = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactView(context);
    }
    return _buildFullView(context);
  }

  Widget _buildCompactView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          calculator.totalPrice.formatPrice(context),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showBreakdown &&
            (calculator.params.rooms > 1 || calculator.params.nights > 1))
          Text(
            calculator.breakdown,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
      ],
    );
  }

  Widget _buildFullView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${calculator.basePricePerUnit.formatPrice(context)}${calculator is HotelPriceCalculator ? ' / night' : ' / person'}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          '${calculator.totalPrice.formatPrice(context)} total',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showBreakdown &&
            (calculator.params.rooms > 1 || calculator.params.nights > 1))
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              calculator.breakdown,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}

/// Simple price label for "Starting from" displays
class StartingFromPrice extends StatelessWidget {
  final double price;

  const StartingFromPrice({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryStyle = textTheme.bodyMedium?.copyWith(
      color: Colors.grey.shade600,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Starting from ', style: secondaryStyle),
          TextSpan(
            text: price.formatPrice(context),
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: '/night', style: secondaryStyle),
        ],
      ),
    );
  }
}
