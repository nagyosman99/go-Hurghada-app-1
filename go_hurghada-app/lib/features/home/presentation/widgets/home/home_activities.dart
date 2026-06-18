import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/home/presentation/widgets/activity_tile.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class HomeActivities extends StatelessWidget {
  final List<ActivityModel> activities;

  const HomeActivities({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)?.popularActivities ??
                    'Popular Activities',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: activities.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final activity = activities[index];
              String localizedName = activity.name;
              final l10n = AppLocalizations.of(context);

              if (activity.name == 'Scuba Diving') {
                localizedName = l10n?.activityScubaDiving ?? activity.name;
              } else if (activity.name == 'Desert Safari') {
                localizedName = l10n?.activityDesertSafari ?? activity.name;
              } else if (activity.name == 'City Tours') {
                localizedName = l10n?.activityCityTours ?? activity.name;
              } else if (activity.name == 'Water Sports') {
                localizedName = l10n?.activityWaterSports ?? activity.name;
              }

              return ActivityTile(
                activity: activity,
                localizedName: localizedName,
                onTap: () {
                  String category = activity.category ?? 'All';
                  
                  // Handle legacy hardcoded names if category is missing
                  if (activity.category == null) {
                    final name = activity.name;
                    if (name == 'Scuba Diving' || name == 'Water Sports') {
                      category = 'Water Sports';
                    } else if (name == 'Desert Safari') {
                      category = 'Safari';
                    } else if (name == 'Luxor Full-Day') {
                      category = 'Family';
                    }
                  }

                  context.push(
                    AppRouter.activities,
                    extra: {'initialCategory': category},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
