import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/shared/widgets/favorite_button.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/home/domain/models/saved_hotel.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';

class CompactHotelCard extends StatelessWidget {
  final HotelSearchResult hotel;

  const CompactHotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.push(
            AppRouter.hotelOfferResults,
            extra: OfferCardModel.fromHotelSearchResult(hotel),
          );
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section (Reduced Height)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusMedium),
                  ),
                  child: AppNetworkImage(
                    imageUrl: hotel.imageUrl,
                    height: 120, // Reduced from 180
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Rating Badge
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          hotel.rating.toString(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 8,
                  start: 8,
                  child: ListenableBuilder(
                    listenable: AppProvider.of(context).favoritesViewModel,
                    builder: (context, _) {
                      final vm = AppProvider.of(context).favoritesViewModel;
                      final isSaved = vm.isHotelSaved(hotel.id);
                      return FavoriteButton(
                        isFavorite: isSaved,
                        onTap: () => vm.toggleHotel(
                          SavedHotel.fromHotelSearchResult(hotel),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hotel.address,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.startingFrom,
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(fontSize: 10),
                            ),
                            Text(
                              hotel.pricePerNight.formatPrice(context),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
