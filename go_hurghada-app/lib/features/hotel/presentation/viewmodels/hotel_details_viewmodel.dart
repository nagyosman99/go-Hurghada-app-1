import 'package:flutter/material.dart';
import 'package:go_hurghada/features/hotel/data/hotel_repository.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';

class HotelDetailsState {
  final HotelDetails? hotel;
  final List<Room> rooms;
  final HotelOffer? offer;
  final bool isLoading;
  final String? error;

  const HotelDetailsState({
    this.hotel,
    this.rooms = const [],
    this.offer,
    this.isLoading = false,
    this.error,
  });

  HotelDetailsState copyWith({
    HotelDetails? hotel,
    List<Room>? rooms,
    HotelOffer? offer,
    bool? isLoading,
    String? error,
  }) {
    return HotelDetailsState(
      hotel: hotel ?? this.hotel,
      rooms: rooms ?? this.rooms,
      offer: offer ?? this.offer,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// ViewModel for fetching and managing detailed information for a specific hotel.
class HotelDetailsViewModel extends ChangeNotifier {
  final HotelRepository _repository;

  HotelDetailsViewModel({required HotelRepository repository})
    : _repository = repository;

  HotelDetailsState _state = const HotelDetailsState();

  /// The current state of hotel details and room availability.
  HotelDetailsState get state => _state;

  /// Loads hotel details, available rooms, and special offers for the given [hotelId].
  Future<void> loadHotelDetails(String hotelId) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getHotelById(hotelId),
        _repository.getRoomsForHotel(hotelId),
        _repository.getOfferById(
          hotelId,
        ), // Assuming offer ID matches hotel ID for simple lookups
      ]);

      _state = _state.copyWith(
        hotel: results[0] as HotelDetails?,
        rooms: results[1] as List<Room>,
        offer: results[2] as HotelOffer?,
        isLoading: false,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
    }
  }
}
