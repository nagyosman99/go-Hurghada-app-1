import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

class BookingSummary extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;
  final int nights;

  const BookingSummary({
    super.key,
    required this.bookingDetails,
    required this.nights,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Check if we already have the basic info passed in
    final hasPassedInfo =
        bookingDetails.containsKey('hotelName') &&
        bookingDetails.containsKey('roomName');

    if (hasPassedInfo) {
      return _buildSummary(
        context,
        hotelName: bookingDetails['hotelName'],
        hotelAddress: bookingDetails['hotelAddress'] ?? '',
        roomName: bookingDetails['roomName'],
        theme: theme,
        l10n: l10n,
      );
    }

    // Fallback to fetching if info is missing (e.g. direct link or legacy navigation)
    final hotelRepository = AppProvider.of(context).hotelRepository;
    final hotelId = bookingDetails['hotelId'] as String;

    return FutureBuilder(
      future: Future.wait([
        hotelRepository.getHotelById(hotelId),
        hotelRepository.getRoomsForHotel(hotelId),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final hotel = snapshot.data![0];
        final rooms = snapshot.data![1] as List<Room>;
        final roomId = bookingDetails['roomId'];
        final room = rooms.firstWhere(
          (r) => r.id == roomId,
          orElse: () => rooms.first,
        );

        return _buildSummary(
          context,
          hotelName: (hotel as dynamic)?.name ?? 'Hotel',
          hotelAddress: (hotel as dynamic)?.address ?? '',
          roomName: room.name,
          theme: theme,
          l10n: l10n,
        );
      },
    );
  }

  Widget _buildSummary(
    BuildContext context, {
    required String hotelName,
    required String hotelAddress,
    required String roomName,
    required ThemeData theme,
    required AppLocalizations l10n,
  }) {
    final roomsCount = bookingDetails['roomsCount'] as int? ?? 1;
    final adults = bookingDetails['adults'] as int? ?? 2;
    final children = bookingDetails['children'] as int? ?? 0;

    // Ensure dates are parsed correctly for calculations
    // Dates are formatted using bookingDetails strings directly in _SummaryRow calls

    final double totalPrice;
    final double? originalPrice;
    final bool hasDiscount;

    if (bookingDetails['totalPrice'] != null) {
      totalPrice = bookingDetails['totalPrice'] as double;
      originalPrice = bookingDetails['totalOriginalPrice'] as double?;
      hasDiscount = originalPrice != null && originalPrice > totalPrice;
    } else {
      // This part might still need room object if we don't pass price,
      // but usually totalPrice is passed now.
      totalPrice = 0;
      originalPrice = 0;
      hasDiscount = false;
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reviewBooking,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hotelName,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (hotelAddress.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(hotelAddress, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 4),
          Text(roomName, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          Divider(height: 1, color: theme.dividerColor),
          const SizedBox(height: 16),
          _SummaryRow(
            label: l10n.checkIn,
            value: bookingDetails['checkInDate'] != null
                ? DateFormat(
                    'EEE, MMM d',
                    Localizations.localeOf(context).toString(),
                  ).format(
                    DateTime.parse(bookingDetails['checkInDate'] as String),
                  )
                : 'Not set',
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.checkOut,
            value: bookingDetails['checkOutDate'] != null
                ? DateFormat(
                    'EEE, MMM d',
                    Localizations.localeOf(context).toString(),
                  ).format(
                    DateTime.parse(bookingDetails['checkOutDate'] as String),
                  )
                : 'Not set',
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.duration,
            value: l10n.totalLengthOfStay(nights),
            icon: Icons.nights_stay_outlined,
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.rooms,
            value: '$roomsCount ${roomsCount > 1 ? l10n.rooms : l10n.rooms}',
            icon: Icons.meeting_room_outlined,
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: l10n.guestsRooms,
            value:
                '$adults ${l10n.adults}${children > 0 ? ', $children ${l10n.children}' : ''}',
            icon: Icons.people_outline,
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          const SizedBox(height: 16),
          if (hasDiscount) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.originalPriceLabel,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  originalPrice!.formatPrice(context),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalAmount,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                totalPrice.formatPrice(context),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _SummaryRow({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          const SizedBox(width: 8),
        ],
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
