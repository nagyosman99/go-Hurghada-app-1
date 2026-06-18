import 'package:flutter/material.dart';

/// Reusable info row widget for displaying label-value pairs
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            label,
            style:
                labelStyle ??
                Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ),
        Text(
          value,
          style:
              valueStyle ??
              Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Date range display widget
class DateRangeDisplay extends StatelessWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final bool compact;

  const DateRangeDisplay({
    super.key,
    required this.checkIn,
    required this.checkOut,
    this.compact = false,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int get nights => checkOut.difference(checkIn).inDays;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Text(
        '$nights night${nights != 1 ? 's' : ''}',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(
          icon: Icons.login,
          label: 'Check-in',
          value: _formatDate(checkIn),
        ),
        const SizedBox(height: 8),
        InfoRow(
          icon: Icons.logout,
          label: 'Check-out',
          value: _formatDate(checkOut),
        ),
        const SizedBox(height: 8),
        InfoRow(
          icon: Icons.nights_stay,
          label: 'Duration',
          value: '$nights night${nights != 1 ? 's' : ''}',
        ),
      ],
    );
  }
}
