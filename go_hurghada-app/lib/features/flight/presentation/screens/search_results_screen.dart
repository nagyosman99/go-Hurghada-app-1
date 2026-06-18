import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/flight/domain/entities/search_params.dart';
import 'package:go_hurghada/features/flight/presentation/viewmodels/flight_results_viewmodel.dart';
import 'package:go_hurghada/features/flight/presentation/widgets/flight_card.dart';
import 'package:go_hurghada/features/flight/presentation/widgets/search_results/sort_filter_bar.dart';
import 'package:go_hurghada/features/flight/presentation/widgets/search_results/flight_status_views.dart';

import 'package:go_hurghada/core/utils/url_launcher.dart';

class SearchResultsScreen extends StatefulWidget {
  final SearchParams searchParams;

  const SearchResultsScreen({super.key, required this.searchParams});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late FlightResultsViewModel _viewModel;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final repository = AppProvider.of(context).flightRepository;
      _viewModel = FlightResultsViewModel(
        repository: repository,
        searchParams: widget.searchParams,
      );
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        final state = _viewModel.state;

        return Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${widget.searchParams.origin} - ${widget.searchParams.destination}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppDimensions.radiusXLarge),
                        topRight: Radius.circular(AppDimensions.radiusXLarge),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              AppLocalizations.of(context)!.searchFlights,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: theme.textTheme.headlineLarge?.color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SortFilterBar(
                            selectedSort: state.selectedSort,
                            onSortChanged: _viewModel.sortFlights,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(child: _buildContent(state)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(FlightResultsState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.error != null) {
      return FlightListErrorView(
        error: state.error!,
        onRetry: _viewModel.searchFlights,
      );
    }

    if (state.flights.isEmpty) {
      return const FlightListEmptyView();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: state.flights.length,
      itemBuilder: (context, index) {
        final flight = state.flights[index];
        final returnFlight =
            widget.searchParams.isRoundTrip &&
                state.returnFlights.isNotEmpty &&
                index < state.returnFlights.length
            ? state.returnFlights[index]
            : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FlightCard(
            flight: flight,
            returnFlight: returnFlight,
            onBook: () => _bookFlight(flight),
            cabinClass: widget.searchParams.travelClass,
            departureDate: widget.searchParams.departureDate,
            returnDate: widget.searchParams.returnDate,
            passengers: widget.searchParams.adults,
          ),
        );
      },
    );
  }

  void _bookFlight(Flight flight) {
    UrlLauncher.launchBookingUrl(flight.bookingUrl);
  }
}
