import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_results/hotel_card_content.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';
import 'package:go_hurghada/shared/widgets/favorite_button.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/home/domain/models/saved_hotel.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';

class HotelCard extends StatelessWidget {
  final HotelSearchResult hotel;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? adults;
  final int? children;
  final int? rooms;

  const HotelCard({
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
          children: [
            Stack(
              children: [
                AppNetworkImage(
                  imageUrl: hotel.imageUrl,
                  height: 200,
                  width: double.infinity,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusMedium),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
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
            HotelCardContent(
              hotel: hotel,
              checkIn: checkIn,
              checkOut: checkOut,
              adults: adults,
              children: children,
              rooms: rooms,
            ),
          ],
        ),
      ),
    );
  }
}
