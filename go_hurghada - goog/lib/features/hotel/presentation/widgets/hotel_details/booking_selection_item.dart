import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class BookingSelectionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subLabel;
  final VoidCallback onTap;

  const BookingSelectionItem({
    super.key,
    required this.icon,
    required this.label,
    this.subLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSmall,
          vertical: 4.0,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: AppDimensions.iconMedium,
            ),
            const SizedBox(width: AppDimensions.paddingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subLabel != null)
                    Text(
                      subLabel!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
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
