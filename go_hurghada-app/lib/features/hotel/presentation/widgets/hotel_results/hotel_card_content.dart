import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/shared/widgets/rating_bar.dart';
import 'package:go_hurghada/shared/widgets/custom_badge.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

class HotelCardContent extends StatelessWidget {
  final HotelSearchResult hotel;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? adults;
  final int? children;
  final int? rooms;

  const HotelCardContent({
    super.key,
    required this.hotel,
    this.checkIn,
    this.checkOut,
    this.adults,
    this.children,
    this.rooms,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  hotel.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              RatingBar(
                rating: hotel.rating,
                size: 18,
                textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.labelLarge?.color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Location Row
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hotel.address,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Facilities (Amenities)
          if (hotel.amenities.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hotel.amenities.take(3).map((amenity) {
                return CustomBadge(
                  text: amenity,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  textColor: AppColors.primary,
                  borderRadius: AppDimensions.radiusSmall,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 16),

          // Price and Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.startingFrom,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: hotel.pricePerNight.formatPrice(context),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Outfit',
                                ),
                          ),
                          TextSpan(
                            text: ' ${AppLocalizations.of(context)!.perNight}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                  fontFamily: 'Outfit',
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  context.push(
                    '${AppRouter.hotelDetails}/${hotel.id}',
                    extra: {
                      'checkIn': checkIn,
                      'checkOut': checkOut,
                      'adults': adults,
                      'children': children,
                      'rooms': rooms,
                    },
                  );
                },
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.viewDetails,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
