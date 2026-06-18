import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_details/booking_selection_item.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class HotelBookingBar extends StatelessWidget {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int roomsCount;
  final int adults;
  final int children;
  final VoidCallback? onTapDates;
  final VoidCallback? onTapOccupancy;
  final VoidCallback onScrollToRooms;

  const HotelBookingBar({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomsCount,
    required this.adults,
    required this.children,
    required this.onScrollToRooms,
    this.onTapDates,
    this.onTapOccupancy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BookingSelectionItem(
                  icon: Icons.calendar_today,
                  label: checkInDate != null && checkOutDate != null
                      ? '${DateFormat('MMM dd', Localizations.localeOf(context).languageCode).format(checkInDate!)} - ${DateFormat('MMM dd', Localizations.localeOf(context).languageCode).format(checkOutDate!)}'
                      : AppLocalizations.of(context)!.selectDates,
                  subLabel: checkInDate != null && checkOutDate != null
                      ? AppLocalizations.of(context)!.nightsCountFormat(
                          checkOutDate!.difference(checkInDate!).inDays,
                        )
                      : null,
                  onTap: onTapDates ?? () {},
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).dividerColor,
              ),
              Expanded(
                child: BookingSelectionItem(
                  icon: Icons.person_outline,
                  label: AppLocalizations.of(
                    context,
                  )!.guestsCountFormat(adults, children),
                  subLabel: AppLocalizations.of(
                    context,
                  )!.roomsCountFormat(roomsCount),
                  onTap: onTapOccupancy ?? () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onScrollToRooms,
              child: Text(AppLocalizations.of(context)!.seeAvailability),
            ),
          ),
        ],
      ),
    );
  }
}
