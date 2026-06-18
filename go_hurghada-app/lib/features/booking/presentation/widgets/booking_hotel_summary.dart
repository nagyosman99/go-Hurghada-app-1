import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class BookingHotelSummary extends StatelessWidget {
  final HotelDetails hotel;
  final Room room;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int nights;
  final int adults;
  final int children;
  final int roomsCount;

  const BookingHotelSummary({
    super.key,
    required this.hotel,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.adults,
    required this.children,
    required this.roomsCount,
  });

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) return AppLocalizations.of(context)?.notSet ?? 'Not set';
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hotel.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(hotel.address, style: Theme.of(context).textTheme.bodyMedium),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.checkIn ?? 'Check-in',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(context, checkInDate),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        AppLocalizations.of(context)?.fromTime('14:00') ??
                            'From 14:00',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).dividerColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.checkOut ?? 'Check-out',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(context, checkOutDate),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        AppLocalizations.of(context)?.untilTime('12:00') ??
                            'Until 12:00',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.totalLengthOfStay(nights),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              AppLocalizations.of(
                context,
              )!.searchSummaryFormat(adults, children, roomsCount),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 24),
            Text(
              AppLocalizations.of(context)?.youSelected ?? 'You selected:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(room.name, style: Theme.of(context).textTheme.bodyMedium),
            if (room.amenities.isNotEmpty)
              Text(
                room.amenities.take(3).join(' • '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
