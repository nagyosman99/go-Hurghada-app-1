import 'package:flutter/material.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final String localizedName;
  final VoidCallback onTap;
  const CategoryCard({
    super.key,
    required this.category,
    required this.localizedName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image.asset(
                category.imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            localizedName,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
