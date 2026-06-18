import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

class BookingPriceBreakdown extends StatelessWidget {
  final double originalPrice;
  final double discountedPrice;
  final bool hasDiscount;
  final double discountPercent;
  final int roomsCount;

  const BookingPriceBreakdown({
    super.key,
    required this.originalPrice,
    required this.discountedPrice,
    required this.hasDiscount,
    required this.discountPercent,
    required this.roomsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.priceSummary ?? 'Price Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)?.originalPriceLabel ?? 'Original Price'}${roomsCount > 1 ? ' ($roomsCount ${roomsCount == 1 ? 'room' : 'rooms'})' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  originalPrice.formatPrice(context),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: hasDiscount ? TextDecoration.lineThrough : null,
                    color: hasDiscount
                        ? AppColors.error
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            if (hasDiscount) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)?.discount ?? 'Discount',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '-${(originalPrice - discountedPrice).formatPrice(context)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)?.totalAmount ?? 'Total Price',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  discountedPrice.formatPrice(context),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
