import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class SortFilterBar extends StatelessWidget {
  final String selectedSort;
  final Function(String) onSortChanged;

  const SortFilterBar({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SortChip(
          label: AppLocalizations.of(context)!.best,
          isSelected: selectedSort == 'Best',
          onTap: () => onSortChanged('Best'),
        ),
        const SizedBox(width: 12),
        _SortChip(
          label: AppLocalizations.of(context)!.cheapest,
          isSelected: selectedSort == 'Cheapest',
          onTap: () => onSortChanged('Cheapest'),
        ),
        const SizedBox(width: 12),
        _SortChip(
          label: AppLocalizations.of(context)!.fastest,
          isSelected: selectedSort == 'Fastest',
          onTap: () => onSortChanged('Fastest'),
        ),
      ],
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected
                ? AppColors.white
                : theme.textTheme.labelLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
