import 'package:flutter/material.dart';
import 'package:go_hurghada/features/hotel/data/hotel_repository.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';

class HotelResultsState {
  final List<HotelSearchResult> hotels;
  final bool isLoading;
  final String? error;
  final HotelSort sort;
  final HotelFilter filter;

  const HotelResultsState({
    this.hotels = const [],
    this.isLoading = false,
    this.error,
    this.sort = HotelSort.ratingHighToLow,
    this.filter = const HotelFilter(),
  });

  HotelResultsState copyWith({
    List<HotelSearchResult>? hotels,
    bool? isLoading,
    String? error,
    HotelSort? sort,
    HotelFilter? filter,
  }) {
    return HotelResultsState(
      hotels: hotels ?? this.hotels,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
    );
  }
}

class HotelResultsViewModel extends ChangeNotifier {
  final HotelRepository _repository;
  final String query;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int rooms;
  final int adults;
  final int children;

  HotelResultsState _state = const HotelResultsState();
  HotelResultsState get state => _state;

  HotelResultsViewModel({
    required HotelRepository repository,
    required this.query,
    this.checkIn,
    this.checkOut,
    this.rooms = 1,
    this.adults = 2,
    this.children = 0,
  }) : _repository = repository {
    searchHotels();
  }

  Future<void> searchHotels() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final hotels = await _repository.searchHotels(
        query,
        checkIn: checkIn,
        checkOut: checkOut,
        rooms: rooms,
        adults: adults,
        children: children,
      );

      _state = _state.copyWith(hotels: hotels, isLoading: false);
      _applyFilterAndSort();
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
    }
  }

  void updateSort(HotelSort sort) {
    _state = _state.copyWith(sort: sort);
    _applyFilterAndSort();
  }

  void updateFilter(HotelFilter filter) {
    _state = _state.copyWith(filter: filter);
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    var filteredHotels = List<HotelSearchResult>.from(_state.hotels);

    // Apply Filter
    if (_state.filter.minPrice != null) {
      filteredHotels = filteredHotels
          .where((h) => h.pricePerNight >= _state.filter.minPrice!)
          .toList();
    }
    if (_state.filter.maxPrice != null) {
      filteredHotels = filteredHotels
          .where((h) => h.pricePerNight <= _state.filter.maxPrice!)
          .toList();
    }
    if (_state.filter.minRating != null) {
      filteredHotels = filteredHotels
          .where((h) => h.rating >= _state.filter.minRating!)
          .toList();
    }

    // Apply Sort
    switch (_state.sort) {
      case HotelSort.priceLowToHigh:
        filteredHotels.sort(
          (a, b) => a.pricePerNight.compareTo(b.pricePerNight),
        );
        break;
      case HotelSort.priceHighToLow:
        filteredHotels.sort(
          (a, b) => b.pricePerNight.compareTo(a.pricePerNight),
        );
        break;
      case HotelSort.ratingHighToLow:
        filteredHotels.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    _state = _state.copyWith(hotels: filteredHotels);
    notifyListeners();
  }
}
