import 'package:flutter/material.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/room_selection/counter_row.dart';

class GuestSelectionPanel extends StatelessWidget {
  final int rooms;
  final int adults;
  final int children;
  final VoidCallback onRoomsDecrement;
  final VoidCallback onRoomsIncrement;
  final VoidCallback onAdultsDecrement;
  final VoidCallback onAdultsIncrement;
  final VoidCallback onChildrenDecrement;
  final VoidCallback onChildrenIncrement;

  const GuestSelectionPanel({
    super.key,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.onRoomsDecrement,
    required this.onRoomsIncrement,
    required this.onAdultsDecrement,
    required this.onAdultsIncrement,
    required this.onChildrenDecrement,
    required this.onChildrenIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guests & Rooms',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          CounterRow(
            label: 'Rooms',
            icon: Icons.hotel,
            count: rooms,
            onDecrement: onRoomsDecrement,
            onIncrement: onRoomsIncrement,
          ),
          const SizedBox(height: 12),
          CounterRow(
            label: 'Adults',
            icon: Icons.person,
            count: adults,
            onDecrement: onAdultsDecrement,
            onIncrement: onAdultsIncrement,
          ),
          const SizedBox(height: 12),
          CounterRow(
            label: 'Children',
            icon: Icons.child_care,
            count: children,
            onDecrement: onChildrenDecrement,
            onIncrement: onChildrenIncrement,
          ),
        ],
      ),
    );
  }
}
