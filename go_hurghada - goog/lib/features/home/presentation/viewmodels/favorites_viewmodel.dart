import 'package:flutter/foundation.dart';
import 'package:go_hurghada/features/home/data/favorites_repository.dart';
import 'package:go_hurghada/features/home/domain/models/saved_hotel.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesRepository _repository;

  // NEW: Saved hotel data cache
  final List<SavedHotel> _savedHotels = [];
  final Set<String> _savedHotelIds = {};

  // Legacy support
  final Set<String> _favoriteActivityIds = {};

  FavoritesViewModel(this._repository) {
    _loadFavorites();
  }

  // Getters
  List<SavedHotel> get savedHotels => List.unmodifiable(_savedHotels);
  Set<String> get savedHotelIds => _savedHotelIds;
  bool isHotelSaved(String id) => _savedHotelIds.contains(id);

  // Activity getters (legacy terminology for now as user didn't request activity refactor)
  Set<String> get favoriteActivityIds => _favoriteActivityIds;
  bool isActivityFavorite(String id) => _favoriteActivityIds.contains(id);

  void _loadFavorites() {
    // Load new hotel data
    final hotels = _repository.getSavedHotels();
    _savedHotels.addAll(hotels);
    _savedHotelIds.addAll(hotels.map((o) => o.id));

    // Load activities
    _favoriteActivityIds.addAll(_repository.getFavoriteActivities());

    debugPrint(
      'FavoritesViewModel: Loaded ${_savedHotels.length} hotels, ${_favoriteActivityIds.length} activities',
    );
    notifyListeners();
  }

  /// Toggle hotel with full data
  Future<void> toggleHotel(SavedHotel hotel) async {
    if (_savedHotelIds.contains(hotel.id)) {
      // Remove
      _savedHotels.removeWhere((o) => o.id == hotel.id);
      _savedHotelIds.remove(hotel.id);
      await _repository.removeSavedHotel(hotel.id);
      debugPrint('FavoritesViewModel: Removed hotel ${hotel.id}');
    } else {
      // Add
      _savedHotels.add(hotel);
      _savedHotelIds.add(hotel.id);
      await _repository.saveHotel(hotel);
      debugPrint('FavoritesViewModel: Added hotel ${hotel.id}');
    }
    notifyListeners();
  }

  /// Remove hotel by ID only
  Future<void> removeHotelById(String id) async {
    _savedHotels.removeWhere((o) => o.id == id);
    _savedHotelIds.remove(id);
    await _repository.removeSavedHotel(id);
    notifyListeners();
  }

  Future<void> toggleActivity(String id) async {
    if (_favoriteActivityIds.contains(id)) {
      _favoriteActivityIds.remove(id);
      await _repository.removeFavoriteActivity(id);
    } else {
      _favoriteActivityIds.add(id);
      await _repository.saveFavoriteActivity(id);
    }
    notifyListeners();
  }
}
