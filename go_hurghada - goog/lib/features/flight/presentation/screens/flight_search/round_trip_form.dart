import 'package:flutter/material.dart';
import 'package:go_hurghada/features/flight/presentation/viewmodels/flight_search_viewmodel.dart';
import 'package:go_hurghada/features/flight/presentation/widgets/flight_form_fields.dart';
import 'package:go_hurghada/features/flight/presentation/widgets/airport_selector.dart';
import 'package:go_hurghada/features/flight/presentation/widgets/passenger_class_selector.dart';
import 'package:go_hurghada/config/constants/egypt_airports.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class RoundTripForm extends StatelessWidget {
  final FlightSearchState searchState;
  final FlightSearchViewModel viewModel;

  const RoundTripForm({
    super.key,
    required this.searchState,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final originAirport = EgyptAirports.getAirportByCode(
      searchState.origin ?? '',
    );
    final destinationAirport = EgyptAirports.getAirportByCode(
      searchState.destination ?? '',
    );

    return Column(
      children: [
        // Origin
        LocationField(
          icon: Icons.flight_takeoff,
          label: l10n.from,
          value: originAirport?.getLocalizedCity(l10n) ?? searchState.origin,
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => AirportSelector(
                onAirportSelected: (airportData) {
                  viewModel.setOrigin(airportData['code']!);
                },
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Destination
        LocationField(
          icon: Icons.flight_land,
          label: l10n.to,
          value:
              destinationAirport?.getLocalizedCity(l10n) ??
              searchState.destination,
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => AirportSelector(
                onAirportSelected: (airportData) {
                  viewModel.setDestination(airportData['code']!);
                },
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Date Row (Departure and Return)
        Row(
          children: [
            Expanded(
              child: DateField(
                label: l10n.departure,
                date: searchState.departureDate,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: searchState.departureDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    viewModel.setDepartureDate(date);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DateField(
                label: l10n.returnFlight,
                date: searchState.returnDate,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        searchState.returnDate ??
                        (searchState.departureDate?.add(
                              const Duration(days: 7),
                            ) ??
                            DateTime.now().add(const Duration(days: 7))),
                    firstDate: searchState.departureDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    viewModel.setReturnDate(date);
                  }
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Passengers and Class in a row
        Row(
          children: [
            Expanded(
              child: InfoField(
                icon: Icons.person_outline,
                label: l10n.passengers,
                value:
                    '${searchState.adults} ${searchState.adults > 1 ? l10n.adults : l10n.adults}',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => PassengerSelector(
                      initialAdults: searchState.adults,
                      onConfirm: (adults) {
                        viewModel.setAdults(adults);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoField(
                icon: Icons.airline_seat_recline_normal,
                label: l10n.cabinClass,
                value: searchState.cabinClass,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClassSelector(
                      currentClass: searchState.cabinClass,
                      onSelect: (className) {
                        viewModel.setCabinClass(className);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
