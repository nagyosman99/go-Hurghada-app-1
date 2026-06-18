import 'package:flutter/material.dart';

class HotelSearchState {
  final String query;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int rooms;
  final int adults;
  final int children;

  const HotelSearchState({
    this.query = '',
    this.checkIn,
    this.checkOut,
    this.rooms = 1,
    this.adults = 2,
    this.children = 0,
  });

  HotelSearchState copyWith({
    String? query,
    DateTime? checkIn,
    DateTime? checkOut,
    int? rooms,
    int? adults,
    int? children,
  }) {
    return HotelSearchState(
      query: query ?? this.query,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      rooms: rooms ?? this.rooms,
      adults: adults ?? this.adults,
      children: children ?? this.children,
    );
  }

  bool get isValid => query.isNotEmpty && checkIn != null && checkOut != null;
}

/// ViewModel for managing the hotel search criteria and filters.
class HotelSearchViewModel extends ChangeNotifier {
  HotelSearchState _state = const HotelSearchState();

  /// The current hotel search state.
  HotelSearchState get state => _state;

  /// Updates the search query (e.g., location or hotel name).
  void updateQuery(String query) {
    _state = _state.copyWith(query: query);
    notifyListeners();
  }

  void updateDates(DateTime? checkIn, DateTime? checkOut) {
    _state = _state.copyWith(checkIn: checkIn, checkOut: checkOut);
    notifyListeners();
  }

  void updateOccupancy({int? rooms, int? adults, int? children}) {
    _state = _state.copyWith(rooms: rooms, adults: adults, children: children);
    notifyListeners();
  }

  void clearSearch() {
    _state = const HotelSearchState();
    notifyListeners();
  }
}
