import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class BookingDateSelection extends StatelessWidget {
  final List<DateTime> availableDates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const BookingDateSelection({
    super.key,
    required this.availableDates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final displayDates = availableDates.isNotEmpty
        ? availableDates
        : List.generate(
            14,
            (index) => DateTime.now().add(Duration(days: index + 1)),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayDates.length,
            itemBuilder: (context, index) {
              final date = displayDates[index];
              final isSelected = selectedDate != null &&
                  DateUtils.isSameDay(selectedDate, date);
              return GestureDetector(
                onTap: () => onDateSelected(date),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsetsDirectional.only(end: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Theme.of(context).dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('MMM').format(date),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).hintColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : Theme.of(context).hintColor,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
