import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/home/presentation/widgets/home/offer_card_content.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/home/domain/models/saved_hotel.dart';

import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/shared/widgets/favorite_button.dart';

class OfferCard extends StatelessWidget {
  final OfferCardModel offer;
  final VoidCallback onTap;

  const OfferCard({super.key, required this.offer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final favoritesViewModel = AppProvider.of(context).favoritesViewModel;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:
              Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppNetworkImage(
                  imageUrl: offer.image,
                  height: 180,
                  width: double.infinity,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusMedium),
                  ),
                ),
                // Badges Column (Top Left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (offer.isAllInclusive)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSmall,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.allInclusive ??
                                'All-inclusive',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                          ),
                        ),
                      if (offer.discount.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            offer.discount,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Favorite Button (Top Right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: ListenableBuilder(
                    listenable: favoritesViewModel,
                    builder: (context, _) {
                      final isSaved = favoritesViewModel.isHotelSaved(offer.id);
                      return FavoriteButton(
                        isFavorite: isSaved,
                        onTap: () => favoritesViewModel.toggleHotel(
                          SavedHotel.fromOfferSummary(offer),
                        ),
                        backgroundColor: Colors.white,
                        activeColor: Colors.red,
                        inactiveColor: Colors.grey,
                      );
                    },
                  ),
                ),
              ],
            ),
            Expanded(child: OfferCardContent(offer: offer)),
          ],
        ),
      ),
    );
  }
}
