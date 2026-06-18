import 'package:flutter/material.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/hotel/presentation/viewmodels/hotel_results_viewmodel.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_results/hotel_card.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_results/hotel_results_status_views.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class HotelResultsScreen extends StatefulWidget {
  const HotelResultsScreen({super.key});

  @override
  State<HotelResultsScreen> createState() => _HotelResultsScreenState();
}

class _HotelResultsScreenState extends State<HotelResultsScreen> {
  HotelResultsViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final appProvider = AppProvider.of(context);
    final searchState = appProvider.hotelSearchViewModel.state;

    _viewModel ??= HotelResultsViewModel(
      repository: appProvider.hotelRepository,
      query: searchState.query,
      checkIn: searchState.checkIn,
      checkOut: searchState.checkOut,
      rooms: searchState.rooms,
      adults: searchState.adults,
      children: searchState.children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final searchQuery = AppProvider.of(
      context,
    ).hotelSearchViewModel.state.query;

    if (_viewModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.hotelsIn(searchQuery))),
      body: ListenableBuilder(
        listenable: _viewModel!,
        builder: (context, _) {
          final state = _viewModel!.state;

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return HotelListErrorView(error: state.error!);
          }

          if (state.hotels.isEmpty) {
            return const HotelListEmptyView();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.hotels.length,
            itemBuilder: (context, index) {
              final hotel = state.hotels[index];
              return HotelCard(
                hotel: hotel,
                checkIn: _viewModel?.checkIn,
                checkOut: _viewModel?.checkOut,
                rooms: _viewModel?.rooms,
                adults: _viewModel?.adults,
                children: _viewModel?.children,
              );
            },
          );
        },
      ),
    );
  }
}
