import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class BookingGuestCounter extends StatelessWidget {
  final int persons;
  final ValueChanged<int> onPersonsChanged;

  const BookingGuestCounter({
    super.key,
    required this.persons,
    required this.onPersonsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of persons',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => onPersonsChanged(persons - 1),
                icon: const Icon(Icons.remove_circle_outline),
                color: AppColors.primary,
              ),
              Text(
                persons.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => onPersonsChanged(persons + 1),
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
