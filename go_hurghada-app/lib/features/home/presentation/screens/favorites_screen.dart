import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/activity_card.dart';
import 'package:go_hurghada/features/home/domain/models/saved_hotel.dart';
import 'package:go_hurghada/shared/widgets/favorite_button.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoritesViewModel = AppProvider.of(context).favoritesViewModel;
    final activitiesRepository = AppProvider.of(context).activitiesRepository;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListenableBuilder(
        listenable: favoritesViewModel,
        builder: (context, _) {
          final hotels = favoritesViewModel.savedHotels;
          final activityIds = favoritesViewModel.favoriteActivityIds.toList();

          if (hotels.isEmpty && activityIds.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            children: [
              if (hotels.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Hotels',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...hotels.map(
                  (hotel) => _SavedHotelCard(
                    hotel: hotel,
                    onRemove: () =>
                        favoritesViewModel.removeHotelById(hotel.id),
                    onTap: () => context.push(
                      '/favorites/hotel-offer-results',
                      extra: hotel.toOfferCard(),
                    ),
                  ),
                ),
              ],
              if (activityIds.isNotEmpty) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Activities',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder<List<Activity>>(
                  future: _fetchActivities(activitiesRepository, activityIds),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text('Loading activities...')),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: snapshot.data!
                          .map(
                            (activity) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ActivityCard(activity: activity),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start exploring and save your favorite\nhotels and activities!',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<List<Activity>> _fetchActivities(
    dynamic repository,
    List<String> ids,
  ) async {
    try {
      final allActivities = await repository.getAllActivities();
      return allActivities
          .where((a) => ids.contains(a.id))
          .toList()
          .cast<Activity>();
    } catch (e) {
      return [];
    }
  }
}

/// Card to display a saved hotel with all its data
class _SavedHotelCard extends StatelessWidget {
  final SavedHotel hotel;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _SavedHotelCard({
    required this.hotel,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badges
            Stack(
              children: [
                AppNetworkImage(
                  imageUrl: hotel.image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    height: 160,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.hotel, size: 48),
                  ),
                ),
                // Discount badge
                if (hotel.discount != null && hotel.discount!.isNotEmpty)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        hotel.discount!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                // Favorite button
                Positioned(
                  top: 12,
                  right: 12,
                  child: FavoriteButton(
                    isFavorite: true,
                    onTap: onRemove,
                    size: 22,
                  ),
                ),
                // All-inclusive badge
                if (hotel.isAllInclusive)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'All Inclusive',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          hotel.hotelName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hotel.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.location,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (hotel.originalPrice != null) ...[
                        Text(
                          hotel.originalPrice!.formatPrice(context),
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        hotel.price.formatPrice(context),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/ night',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
