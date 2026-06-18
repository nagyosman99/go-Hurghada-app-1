import 'package:flutter/material.dart';
import 'package:go_hurghada/features/flight/data/amadeus_flight_service.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/flight/domain/entities/search_params.dart';

class FlightSearchState {
  final bool isRoundTrip;
  final String? origin;
  final String? destination;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final int adults;
  final String cabinClass;
  final List<Flight> results;
  final bool isLoading;
  final String? error;

  const FlightSearchState({
    this.isRoundTrip = true,
    this.origin,
    this.destination,
    this.departureDate,
    this.returnDate,
    this.adults = 1,
    this.cabinClass = 'Economy',
    this.results = const [],
    this.isLoading = false,
    this.error,
  });

  FlightSearchState copyWith({
    bool? isRoundTrip,
    String? origin,
    String? destination,
    DateTime? departureDate,
    DateTime? returnDate,
    int? adults,
    String? cabinClass,
    List<Flight>? results,
    bool? isLoading,
    String? error,
  }) {
    return FlightSearchState(
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      adults: adults ?? this.adults,
      cabinClass: cabinClass ?? this.cabinClass,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isValid {
    if (origin == null || destination == null || departureDate == null) {
      return false;
    }
    if (isRoundTrip && returnDate == null) {
      return false;
    }
    return true;
  }

  SearchParams toSearchParams() {
    return SearchParams(
      origin: origin!,
      destination: destination!,
      departureDate: departureDate!,
      returnDate: returnDate,
      adults: adults,
      travelClass: cabinClass,
      isRoundTrip: isRoundTrip,
    );
  }
}

/// ViewModel for managing the flight search parameters and state.
class FlightSearchViewModel extends ChangeNotifier {
  final AmadeusFlightService _flightService;
  FlightSearchState _state = const FlightSearchState();
  List<Flight> _allResults = [];

  FlightSearchViewModel({required AmadeusFlightService flightService})
      : _flightService = flightService;

  /// The current flight search state.
  FlightSearchState get state => _state;

  /// The flight service for API calls.
  AmadeusFlightService get flightService => _flightService;

  void setTripType(bool isRoundTrip) {
    _state = _state.copyWith(isRoundTrip: isRoundTrip);
    notifyListeners();
  }

  void setOrigin(String origin) {
    _state = _state.copyWith(origin: origin);
    notifyListeners();
  }

  void setDestination(String destination) {
    _state = _state.copyWith(destination: destination);
    notifyListeners();
  }

  void setDepartureDate(DateTime date) {
    _state = _state.copyWith(departureDate: date);
    notifyListeners();
  }

  void setReturnDate(DateTime? date) {
    _state = _state.copyWith(returnDate: date);
    notifyListeners();
  }

  void setAdults(int adults) {
    _state = _state.copyWith(adults: adults);
    notifyListeners();
  }

  void setCabinClass(String cabinClass) {
    _state = _state.copyWith(cabinClass: cabinClass);
    notifyListeners();
  }

  /// Swaps the origin and destination locations.
  void swapOriginDestination() {
    final temp = _state.origin;
    _state = _state.copyWith(origin: _state.destination, destination: temp);
    notifyListeners();
  }

  Future<void> searchFlights() async {
    if (!_state.isValid) return;

    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final results = await _flightService.searchFlights(_state.toSearchParams());
      _allResults = results;
      _state = _state.copyWith(results: results, isLoading: false);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: 'Failed to search flights. Please try again.');
    }
    notifyListeners();
  }

  void sortResults(String criteria) {
    List<Flight> sorted = List.from(_state.results);
    switch (criteria) {
      case 'Cheapest':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Fastest':
        sorted.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
        break;
      case 'Best':
        // Custom mix: price + (duration / 10)
        sorted.sort((a, b) => (a.price + (a.durationMinutes / 10))
            .compareTo(b.price + (b.durationMinutes / 10)));
        break;
    }
    _state = _state.copyWith(results: sorted);
    notifyListeners();
  }

  void filterResults({bool directOnly = false, double? maxPrice}) {
    List<Flight> filtered = _allResults.where((f) {
      if (directOnly && f.stops > 0) return false;
      if (maxPrice != null && f.price > maxPrice) return false;
      return true;
    }).toList();
    _state = _state.copyWith(results: filtered);
    notifyListeners();
  }
}
