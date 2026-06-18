import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/shared/widgets/rating_badge.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';
import 'package:go_hurghada/shared/widgets/favorite_button.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final path = GoRouterState.of(context).uri.path;
        if (path.startsWith('/favorites')) {
          context.push('/favorites/activity/${activity.id}');
        } else {
          // Default to home branch to maintain context
          context.push('/home/activity/${activity.id}');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusLarge),
                  ),
                  child: activity.images.isEmpty
                      ? Container(
                          height: 180,
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        )
                      : AppNetworkImage(
                          imageUrl: activity.images.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                PositionedDirectional(
                  top: 12,
                  end: 12,
                  child: RatingBadge(rating: activity.rating),
                ),
                PositionedDirectional(
                  top: 12,
                  start: 12,
                  child: ListenableBuilder(
                    listenable: AppProvider.of(context).favoritesViewModel,
                    builder: (context, _) {
                      final vm = AppProvider.of(context).favoritesViewModel;
                      return FavoriteButton(
                        isFavorite: vm.isActivityFavorite(activity.id),
                        onTap: () => vm.toggleActivity(activity.id),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          activity.location,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${AppLocalizations.of(context)!.perPersonFrom} ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: activity.price.formatPrice(context),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
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
