import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/offer_details/hotel_info.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/offer_details/hotel_about_section.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/shared/hotel_facilities_widget.dart';
import 'package:go_hurghada/shared/widgets/favorite_button.dart';
import 'package:go_hurghada/features/home/domain/models/saved_hotel.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/offer_details/hotel_availability_section.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_details/hotel_photo_carousel.dart';

/// A production-quality screen that displays hotel offers and available rooms.
class HotelOfferResultsScreen extends StatefulWidget {
  final OfferCardModel offer;

  const HotelOfferResultsScreen({super.key, required this.offer});

  @override
  State<HotelOfferResultsScreen> createState() =>
      _HotelOfferResultsScreenState();
}

class _HotelOfferResultsScreenState extends State<HotelOfferResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppProvider.of(
          context,
        ).hotelDetailsViewModel.loadHotelDetails(widget.offer.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppProvider.of(context).hotelDetailsViewModel,
      builder: (context, _) {
        final vm = AppProvider.of(context).hotelDetailsViewModel;
        final state = vm.state;
        final hotel = state.hotel;
        final isLoading = state.isLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.offer.hotelName),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ListenableBuilder(
                  listenable: AppProvider.of(context).favoritesViewModel,
                  builder: (context, _) {
                    final favoritesVm = AppProvider.of(
                      context,
                    ).favoritesViewModel;
                    final isSaved = favoritesVm.isHotelSaved(widget.offer.id);
                    return FavoriteButton(
                      isFavorite: isSaved,
                      onTap: () => favoritesVm.toggleHotel(
                        SavedHotel.fromOfferSummary(widget.offer),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : hotel == null
              ? const Center(child: Text('Failed to load hotel details'))
              : _HotelContent(
                  hotel: hotel,
                  offer: widget.offer,
                  rooms: state.rooms,
                ),
        );
      },
    );
  }
}

class _HotelContent extends StatelessWidget {
  final HotelDetails hotel;
  final OfferCardModel offer;
  final List<Room> rooms;

  const _HotelContent({
    required this.hotel,
    required this.offer,
    required this.rooms,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Photos (Carousel)
          SliverPhotoCarouselHeader(hotel: hotel, offer: offer),

          // 2. Hotel Info (Title, Location, About, Facilities)
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HotelTitleAndRating(offer: offer),
                const SizedBox(height: 8),
                HotelLocation(location: hotel.address),
                const SizedBox(height: 24),

                Text(
                  'About',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                HotelAboutSection(
                  location: hotel.address,
                  description: hotel.description,
                ),
                const SizedBox(height: 24),

                Text(
                  'Facilities',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                HotelFacilitiesWidget(amenities: hotel.amenities),

                const SizedBox(height: 24),
                const Divider(),
              ],
            ),
          ),

          // 3 & 4. Search Bar and Rooms (Availability Section)
          // Moved OUTSIDE of the main padding to allow full-width search summary
          HotelAvailabilitySection(
            key: ValueKey(hotel.id),
            hotelId: hotel.id,
            rooms: rooms,
            discountPercentage: offer.discountValue,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class SliverPhotoCarouselHeader extends StatelessWidget {
  const SliverPhotoCarouselHeader({
    super.key,
    required this.hotel,
    required this.offer,
  });

  final HotelDetails hotel;
  final OfferCardModel offer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: HotelPhotoCarousel(
        photos: hotel.photos.isNotEmpty ? hotel.photos : [offer.image],
        heroTag: 'offer_image_${offer.id}',
      ),
    );
  }
}
