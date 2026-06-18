import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class HighlightItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const HighlightItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
