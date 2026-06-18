import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class ActivitiesCategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const ActivitiesCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<String> categories = [
    'All',
    'Water Sports',
    'Safari',
    'Boat Trips',
    'Family',
    'Luxury',
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
        ),
        child: Row(
          children: categories.map((category) {
            final isSelected = selectedCategory == category;
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => onCategorySelected(category),
                backgroundColor: Theme.of(context).canvasColor,
                selectedColor: AppColors.primary,
                labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : Theme.of(context).dividerColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
