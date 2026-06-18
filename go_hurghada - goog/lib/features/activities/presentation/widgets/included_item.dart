import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class IncludedItem extends StatelessWidget {
  final String text;
  final bool isIncluded;

  const IncludedItem({super.key, required this.text, this.isIncluded = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isIncluded ? Icons.check_circle : Icons.cancel,
            size: 20,
            color: isIncluded ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
