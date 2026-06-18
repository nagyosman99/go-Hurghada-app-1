import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

/// Search summary card showing active search parameters
class SearchSummaryCard extends StatelessWidget {
  final String? location;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int rooms;
  final int adults;
  final int children;

  const SearchSummaryCard({
    super.key,
    this.location,
    this.checkIn,
    this.checkOut,
    required this.rooms,
    required this.adults,
    required this.children,
  });

  int get nights {
    if (checkIn == null || checkOut == null) return 0;
    return checkOut!.difference(checkIn!).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.search, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Your Search',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (location != null && location!.isNotEmpty)
                _InfoChip(icon: Icons.location_on, label: location!),
              if (nights > 0)
                _InfoChip(
                  icon: Icons.calendar_today,
                  label: '$nights night${nights != 1 ? 's' : ''}',
                ),
              _InfoChip(
                icon: Icons.hotel,
                label: '$rooms room${rooms != 1 ? 's' : ''}',
              ),
              _InfoChip(
                icon: Icons.person,
                label: '$adults adult${adults != 1 ? 's' : ''}',
              ),
              if (children > 0)
                _InfoChip(
                  icon: Icons.child_care,
                  label: '$children child${children != 1 ? 'ren' : ''}',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
