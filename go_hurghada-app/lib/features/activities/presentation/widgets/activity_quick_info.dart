import 'package:flutter/material.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/quick_info_chip.dart';

class ActivityQuickInfo extends StatelessWidget {
  final Activity activity;

  const ActivityQuickInfo({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          QuickInfoChip(icon: Icons.access_time, text: activity.duration),
          const SizedBox(width: 8),
          QuickInfoChip(icon: Icons.child_care, text: activity.ageRequirement),
          const SizedBox(width: 8),
          QuickInfoChip(
            icon: activity.pickupIncluded ? Icons.check_circle : Icons.cancel,
            text: activity.pickupIncluded ? 'Pickup included' : 'No pickup',
          ),
          const SizedBox(width: 8),
          QuickInfoChip(
            icon: Icons.language,
            text: activity.languages.join(', '),
          ),
          const SizedBox(width: 8),
          if (activity.instantConfirmation)
            const QuickInfoChip(
              icon: Icons.verified,
              text: 'Instant confirmation',
            ),
          if (activity.instantConfirmation) const SizedBox(width: 8),
          if (activity.freeCancellation)
            const QuickInfoChip(
              icon: Icons.event_available,
              text: 'Free cancellation',
            ),
        ],
      ),
    );
  }
}
