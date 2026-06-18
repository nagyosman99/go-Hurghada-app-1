import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class HotelSearchSummary extends StatelessWidget {
  final VoidCallback onChangeSearch;
  final DateTime? onCheckIn;
  final DateTime? onCheckOut;
  final int? onRooms;
  final int? onAdults;
  final int? onChildren;

  const HotelSearchSummary({
    super.key,
    required this.onChangeSearch,
    this.onCheckIn,
    this.onCheckOut,
    this.onRooms,
    this.onAdults,
    this.onChildren,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d');

    if (onCheckIn != null &&
        onCheckOut != null &&
        onAdults != null &&
        onRooms != null) {
      return _buildSummary(
        context,
        dateFormat,
        onCheckIn!,
        onCheckOut!,
        onAdults!,
        onChildren ?? 0,
        onRooms!,
      );
    }

    final searchViewModel = AppProvider.of(context).hotelSearchViewModel;
    return ListenableBuilder(
      listenable: searchViewModel,
      builder: (context, _) {
        final state = searchViewModel.state;
        return _buildSummary(
          context,
          dateFormat,
          state.checkIn,
          state.checkOut,
          state.adults,
          state.children,
          state.rooms,
        );
      },
    );
  }

  Widget _buildSummary(
    BuildContext context,
    DateFormat dateFormat,
    DateTime? checkIn,
    DateTime? checkOut,
    int adults,
    int children,
    int rooms,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).iconTheme.color?.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      checkIn != null && checkOut != null
                          ? '${dateFormat.format(checkIn)} — ${dateFormat.format(checkOut)}'
                          : (AppLocalizations.of(context)?.selectDates ??
                                'Select Dates'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: Theme.of(
                      context,
                    ).iconTheme.color?.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.searchSummaryFormat(adults, children, rooms),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onChangeSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)?.changeSearch ?? 'Change search',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
