import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/flight/presentation/widgets/date_selection/custom_calendar.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class DateSelectionScreen extends StatefulWidget {
  final bool isSelectingDeparture;
  final DateTime? initialDate;
  final String? routeTitle;

  const DateSelectionScreen({
    super.key,
    required this.isSelectingDeparture,
    this.initialDate,
    this.routeTitle,
  });

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  void _confirmSelection() {
    context.pop(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.white),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home/flight-search');
                      }
                    },
                  ),
                  const Spacer(),
                  Text(
                    widget.routeTitle ??
                        (widget.isSelectingDeparture
                            ? AppLocalizations.of(context)!.departure
                            : AppLocalizations.of(context)!.returnFlight),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Calendar Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusXLarge),
                    topRight: Radius.circular(AppDimensions.radiusXLarge),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: CustomCalendar(
                        initialDate: _selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                    ),

                    // Done Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _confirmSelection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMedium,
                              ),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.yes,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
