import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';
import 'package:go_hurghada/shared/widgets/rating_badge.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';
import 'package:go_hurghada/shared/widgets/favorite_button.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';

class CompactActivityCard extends StatelessWidget {
  final Activity activity;

  const CompactActivityCard({super.key, required this.activity});

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
        onTap: () =>
            context.push('${AppRouter.activityDetails}/${activity.id}'),
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
                    imageUrl: activity.images.isNotEmpty
                        ? activity.images.first
                        : '',
                    height: 120, // Reduced from standard
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: RatingBadge(rating: activity.rating),
                ),
                PositionedDirectional(
                  top: 8,
                  start: 8,
                  child: ListenableBuilder(
                    listenable: AppProvider.of(context).favoritesViewModel,
                    builder: (context, _) {
                      final vm = AppProvider.of(context).favoritesViewModel;
                      return FavoriteButton(
                        size: 20,
                        isFavorite: vm.isActivityFavorite(activity.id),
                        onTap: () => vm.toggleActivity(activity.id),
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
                      activity.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.price.formatPrice(context),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push(
                            '${AppRouter.activityDetails}/${activity.id}',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('View Details'),
                      ),
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
