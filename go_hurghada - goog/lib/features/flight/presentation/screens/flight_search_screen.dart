import 'package:flutter/material.dart';
import 'package:go_hurghada/features/flight/presentation/screens/flight_search/round_trip_form.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/shared/widgets/custom_header.dart';
import 'package:go_hurghada/features/flight/presentation/widgets/trip_type_button.dart';
import 'package:go_hurghada/features/flight/presentation/screens/flight_search/one_way_form.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class FlightSearchScreen extends StatelessWidget {
  const FlightSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flightSearchViewModel = AppProvider.of(context).flightSearchViewModel;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: flightSearchViewModel,
      builder: (context, child) {
        final searchState = flightSearchViewModel.state;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomHeader(),
                    const SizedBox(height: 20),
                    // Trip Type Selector
                    Row(
                      children: [
                        Expanded(
                          child: TripTypeButton(
                            label:
                                AppLocalizations.of(context)?.roundTrip ??
                                'Round Trip',
                            isSelected: searchState.isRoundTrip,
                            onTap: () =>
                                flightSearchViewModel.setTripType(true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TripTypeButton(
                            label:
                                AppLocalizations.of(context)?.oneWay ??
                                'One Way',
                            isSelected: !searchState.isRoundTrip,
                            onTap: () =>
                                flightSearchViewModel.setTripType(false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Form Content
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: searchState.isRoundTrip
                          ? RoundTripForm(
                              searchState: searchState,
                              viewModel: flightSearchViewModel,
                            )
                          : OneWayForm(
                              searchState: searchState,
                              viewModel: flightSearchViewModel,
                            ),
                    ),

                    const SizedBox(height: 32),

                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: searchState.isValid
                            ? () {
                                context.push(
                                  AppRouter.searchResults,
                                  extra: searchState.toSearchParams(),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.buttonDisabled,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMedium,
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)?.searchFlights ??
                              'Search Flights',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
