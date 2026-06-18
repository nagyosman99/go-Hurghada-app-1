import 'package:flutter/material.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/flight/domain/entities/search_params.dart';
import 'package:go_hurghada/features/flight/domain/repositories/flight_repository.dart';
import 'package:go_hurghada/features/flight/data/datasources/mock_flight_data.dart';

class FlightResultsState {
  final List<Flight> flights;
  final List<Flight> returnFlights;
  final bool isLoading;
  final String? error;
  final String selectedSort;

  const FlightResultsState({
    this.flights = const [],
    this.returnFlights = const [],
    this.isLoading = false,
    this.error,
    this.selectedSort = 'Best',
  });

  FlightResultsState copyWith({
    List<Flight>? flights,
    List<Flight>? returnFlights,
    bool? isLoading,
    String? error,
    String? selectedSort,
  }) {
    return FlightResultsState(
      flights: flights ?? this.flights,
      returnFlights: returnFlights ?? this.returnFlights,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedSort: selectedSort ?? this.selectedSort,
    );
  }
}

/// ViewModel for fetching and sorting flight search results.
class FlightResultsViewModel extends ChangeNotifier {
  final FlightRepository _repository;
  final SearchParams searchParams;

  FlightResultsState _state = const FlightResultsState();

  /// The current state of flight results, including loading and error states.
  FlightResultsState get state => _state;

  FlightResultsViewModel({
    required FlightRepository repository,
    required this.searchParams,
  }) : _repository = repository {
    searchFlights();
  }

  /// Performs the flight search based on the provided parameters.
  Future<void> searchFlights() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    final result = await _repository.searchFlights(searchParams);

    result.fold(
      (error) {
        _state = _state.copyWith(error: error, isLoading: false);
        notifyListeners();
      },
      (flights) async {
        if (searchParams.isRoundTrip) {
          final returnResult = await _repository.getFlightsByRoute(
            searchParams.destination,
            searchParams.origin,
          );

          returnResult.fold(
            (error) {
              _state = _state.copyWith(
                error: 'Could not find return flights',
                isLoading: false,
              );
              notifyListeners();
            },
            (returnFlights) {
              _state = _state.copyWith(
                flights: flights,
                returnFlights: returnFlights,
                isLoading: false,
              );
              _applySort(_state.selectedSort);
              notifyListeners();
            },
          );
        } else {
          _state = _state.copyWith(flights: flights, isLoading: false);
          _applySort(_state.selectedSort);
          notifyListeners();
        }
      },
    );
  }

  void sortFlights(String sortType) {
    _state = _state.copyWith(selectedSort: sortType);
    _applySort(sortType);
    notifyListeners();
  }

  void _applySort(String sortType) {
    List<Flight> sortedFlights = List.from(_state.flights);
    switch (sortType) {
      case 'Cheapest':
        sortedFlights = MockFlightData.sortFlightsByCheapest(sortedFlights);
        break;
      case 'Fastest':
        sortedFlights = MockFlightData.sortFlightsByFastest(sortedFlights);
        break;
      case 'Best':
        sortedFlights = MockFlightData.sortFlightsByBest(sortedFlights);
        break;
    }
    _state = _state.copyWith(flights: sortedFlights);
  }
}
