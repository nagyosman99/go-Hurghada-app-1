import 'package:flutter/material.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

class RoomPricingAndAction extends StatelessWidget {
  const RoomPricingAndAction({
    super.key,
    required this.calculator,
    required this.originalCalculator,
    required this.discountPercentage,
  });

  final BasePriceCalculator calculator;
  final BasePriceCalculator originalCalculator;
  final double discountPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (discountPercentage > 0)
          _DiscountBadge(percentage: discountPercentage),
        _DurationInfo(calculator: calculator, l10n: l10n),
        const SizedBox(height: 8),
        if (discountPercentage > 0)
          _OriginalPrice(price: originalCalculator.totalPrice),
        _CurrentPrice(calculator: calculator, theme: theme),
      ],
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.percentage});
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFe74c3c),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${(percentage * 100).toStringAsFixed(0)}% OFF',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DurationInfo extends StatelessWidget {
  const _DurationInfo({required this.calculator, required this.l10n});
  final BasePriceCalculator calculator;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Text(
      calculator.params.checkIn != null && calculator.params.checkOut != null
          ? '${l10n.nightsCountFormat(calculator.params.nights)}, ${l10n.guestsCountFormat(calculator.params.adults, calculator.params.children)}'
          : calculator.breakdown,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Colors.grey.shade600,
        fontSize: 12,
      ),
    );
  }
}

class _OriginalPrice extends StatelessWidget {
  const _OriginalPrice({required this.price});
  final double price;

  @override
  Widget build(BuildContext context) {
    return Text(
      price.formatPrice(context),
      style: const TextStyle(
        decoration: TextDecoration.lineThrough,
        color: Color(0xFFc60000),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _CurrentPrice extends StatelessWidget {
  const _CurrentPrice({required this.calculator, required this.theme});
  final BasePriceCalculator calculator;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.end,
      children: [
        Text(
          calculator.totalPrice.formatPrice(context),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.black87,
            fontSize: 24,
          ),
        ),
        if (calculator.params.rooms > 1) ...[
          const SizedBox(width: 4),
          Text(
            'for ${calculator.params.rooms} rooms',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }
}
