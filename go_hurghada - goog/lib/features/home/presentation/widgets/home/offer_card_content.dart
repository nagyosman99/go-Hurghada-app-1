import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

import 'package:go_hurghada/shared/widgets/custom_badge.dart';

class OfferCardContent extends StatelessWidget {
  final OfferCardModel offer;

  const OfferCardContent({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Rating Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    offer.hotelName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        offer.rating.toString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: AppColors.starRating,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
            // Location
            Text(
              offer.location,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              offer.distance,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 4),
            // Amenities
            if (offer.amenities.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: offer.amenities.take(3).map((amenity) {
                  return CustomBadge(
                    text: amenity,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.1),
                    textColor: Theme.of(context).colorScheme.primary,
                    fontSize: 11,
                    borderRadius: 4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 8),
            // Price Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (offer.originalPrice != null)
                  Text(
                    offer.originalPrice!.formatPrice(context),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.error.withValues(alpha: 0.7),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.error.withValues(alpha: 0.7),
                    ),
                  ),
                Text(
                  offer.price.formatPrice(context),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineSmall?.color,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)?.stayDurationFormat(2, 1) ??
                      '1 night, 2 adults',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
