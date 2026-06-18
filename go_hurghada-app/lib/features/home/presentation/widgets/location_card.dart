import 'package:flutter/material.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final String localizedName;
  final VoidCallback onTap;

  const LocationCard({
    super.key,
    required this.location,
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
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(
                    imageUrl: location.image,
                    fit: BoxFit.cover,
                    errorWidget: Container(
                      color: AppColors.grey,
                      child: const Center(
                        child: Icon(
                          Icons.image,
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
