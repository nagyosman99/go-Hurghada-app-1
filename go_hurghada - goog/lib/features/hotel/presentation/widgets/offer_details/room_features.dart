import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';

class RoomFeatures extends StatelessWidget {
  final Room room;

  const RoomFeatures({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RoomDetailRow(icon: Icons.bed_outlined, text: room.bedConfiguration),
        const SizedBox(height: 8),
        RoomDetailRow(
          icon: Icons.square_foot,
          text: '${room.size.toStringAsFixed(0)} m²',
        ),
      ],
    );
  }
}

class FeatureChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const FeatureChip({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.1),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: theme.textTheme.bodySmall?.color),
            const SizedBox(width: 4),
          ],
          Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class RoomDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const RoomDetailRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: 6),
        Icon(icon, size: 16, color: theme.textTheme.bodySmall?.color),
      ],
    );
  }
}
