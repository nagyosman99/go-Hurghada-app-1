import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/utils/date_formatter.dart';
import 'package:go_hurghada/config/constants/airline_logos.dart';
import 'package:go_hurghada/config/constants/egypt_airports.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class FlightSegment extends StatelessWidget {
  final Flight flightSegment;
  final DateTime? date;

  const FlightSegment({super.key, required this.flightSegment, this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date (if provided)
          if (date != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 15,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormatter.formatDateForDisplay(date!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

          // Airline Name
          Row(
            children: [
              // Airline Logo
              Semantics(
                label: '${flightSegment.airlineName} logo',
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AirlineLogos.hasLogo(flightSegment.airlineCode)
                        ? theme.cardColor
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    border: AirlineLogos.hasLogo(flightSegment.airlineCode)
                        ? Border.all(color: theme.dividerColor, width: 0.5)
                        : null,
                  ),
                  child: AirlineLogos.hasLogo(flightSegment.airlineCode)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            AirlineLogos.getLogoPath(
                              flightSegment.airlineCode,
                            )!,
                            fit: BoxFit.contain,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  flightSegment.airlineCode,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            flightSegment.airlineCode,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flightSegment.airlineName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (flightSegment.flightNumber != null)
                      Text(
                        flightSegment.flightNumber!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Flight Times and Route
          Row(
            children: [
              // Departure
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.formatTime(flightSegment.departureTime),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      EgyptAirports.getAirportByCode(
                            flightSegment.origin,
                          )?.getLocalizedCity(AppLocalizations.of(context)!) ??
                          flightSegment.origin,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),

              // Duration and Route Line
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      DateFormatter.formatDuration(
                        flightSegment.durationMinutes,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: AppColors.primary),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.flight,
                            size: 15,
                            color: AppColors.primary,
                          ),
                        ),
                        Expanded(
                          child: Container(height: 1, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.stops(flightSegment.stops),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),

              // Arrival
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormatter.formatTime(flightSegment.arrivalTime),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      EgyptAirports.getAirportByCode(
                            flightSegment.destination,
                          )?.getLocalizedCity(AppLocalizations.of(context)!) ??
                          flightSegment.destination,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
