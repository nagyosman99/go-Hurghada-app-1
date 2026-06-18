import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/flight/presentation/widgets/flight_segment.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  final Flight? returnFlight;
  final VoidCallback onBook;
  final String? cabinClass;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final int passengers;

  const FlightCard({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.onBook,
    this.cabinClass,
    this.departureDate,
    this.returnDate,
    this.passengers = 1,
  });

  String _getLocalizedCabinClass(String cabinClass, AppLocalizations l10n) {
    switch (cabinClass) {
      case 'Economy':
        return l10n.economy;
      case 'Business':
        return l10n.business;
      case 'First Class':
        return l10n.firstClass;
      default:
        return cabinClass;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalPrice = flight.price * passengers;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Outbound Flight
          FlightSegment(flightSegment: flight, date: departureDate),

          // Return Flight Section (for round trips)
          if (returnFlight != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.dividerColor.withValues(alpha: 0),
                      theme.dividerColor,
                      theme.dividerColor.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            FlightSegment(flightSegment: returnFlight!, date: returnDate),
          ],

          // Cabin Class (if provided)
          if (cabinClass != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.airline_seat_recline_normal,
                    size: 14,
                    color: theme.iconTheme.color?.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getLocalizedCabinClass(
                      cabinClass!,
                      AppLocalizations.of(context)!,
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

          // Price and Book Button
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.price.formatPrice(context),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.perPerson,
                      style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                    if (passengers > 1) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${AppLocalizations.of(context)!.total}: ${totalPrice.formatPrice(context)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyMedium?.color,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
                ElevatedButton(
                  onPressed: onBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.book,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
