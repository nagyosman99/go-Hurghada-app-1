import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class CounterRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const CounterRow({
    super.key,
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
