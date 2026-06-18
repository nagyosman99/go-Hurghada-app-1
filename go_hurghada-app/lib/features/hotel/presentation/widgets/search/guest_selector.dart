import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class GuestSelector extends StatelessWidget {
  final int rooms;
  final int adults;
  final int children;
  final ValueChanged<int> onRoomsChanged;
  final ValueChanged<int> onAdultsChanged;
  final ValueChanged<int> onChildrenChanged;

  const GuestSelector({
    super.key,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.onRoomsChanged,
    required this.onAdultsChanged,
    required this.onChildrenChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.guestsRooms ?? 'Guests & Rooms',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 12),
          _CounterRow(
            label: AppLocalizations.of(context)?.rooms ?? 'Rooms',
            icon: Icons.hotel,
            count: rooms,
            onDecrement: () {
              if (rooms > 1) onRoomsChanged(rooms - 1);
            },
            onIncrement: () {
              if (rooms < 10) onRoomsChanged(rooms + 1);
            },
          ),
          const SizedBox(height: 12),
          _CounterRow(
            label: AppLocalizations.of(context)?.adults ?? 'Adults',
            icon: Icons.person,
            count: adults,
            onDecrement: () {
              if (adults > 1) onAdultsChanged(adults - 1);
            },
            onIncrement: () {
              if (adults < 20) onAdultsChanged(adults + 1);
            },
          ),
          const SizedBox(height: 12),
          _CounterRow(
            label: AppLocalizations.of(context)?.children ?? 'Children',
            icon: Icons.child_care,
            count: children,
            onDecrement: () {
              if (children > 0) onChildrenChanged(children - 1);
            },
            onIncrement: () {
              if (children < 10) onChildrenChanged(children + 1);
            },
          ),
        ],
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CounterRow({
    required this.label,
    required this.icon,
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle_outline),
          color: AppColors.primary,
          iconSize: 28,
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text(
            count.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle_outline),
          color: AppColors.primary,
          iconSize: 28,
        ),
      ],
    );
  }
}
