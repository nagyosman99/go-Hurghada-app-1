import 'package:flutter/material.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class ActivityTile extends StatelessWidget {
  final ActivityModel activity;
  final String localizedName;
  final VoidCallback onTap;

  const ActivityTile({
    super.key,
    required this.activity,
    required this.localizedName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 160,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Hero(
              tag: 'activity_${activity.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(
                      imageUrl: activity.image,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        color: AppColors.grey,
                        child: const Center(
                          child: Icon(
                            Icons.local_activity,
                            size: AppDimensions.iconXLarge,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, AppColors.overlayDark],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizedName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
