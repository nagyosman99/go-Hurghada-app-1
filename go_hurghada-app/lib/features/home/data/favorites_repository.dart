import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_hurghada/features/home/domain/models/saved_hotel.dart';

class FavoritesRepository {
  static const String _boxName = 'favorites_box';
  static const String _hotelsKey =
      'saved_hotels'; // Updated from favorite_offers
  static const String _activitiesKey = 'favorite_activities';

  // Legacy keys for backward compatibility
  static const String _offersKey = 'favorite_offers'; // Old key for migration
  static const String _legacyIdsKey =
      'favorite_hotels'; // Original ID-only list

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }

    // Migration: Move favorite_offers to saved_hotels if it exists
    final box = Hive.box(_boxName);
    if (box.containsKey(_offersKey) && !box.containsKey(_hotelsKey)) {
      final oldData = box.get(_offersKey);
      await box.put(_hotelsKey, oldData);
      await box.delete(_offersKey);
      debugPrint('FavoritesRepository: Migrated old offers to saved_hotels');
    }

    debugPrint(
      'FavoritesRepository: Box opened. Hotels: ${getSavedHotels().length}, Activities: ${getFavoriteActivities().length}',
    );
  }

  Future<Box> _getLazyBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  // ==================== HOTELS (NEW) ====================

  /// Get all saved hotels with full data
  List<SavedHotel> getSavedHotels() {
    if (!Hive.isBoxOpen(_boxName)) {
      return [];
    }
    final box = Hive.box(_boxName);
    final raw = box.get(_hotelsKey, defaultValue: []);
    if (raw is List) {
      try {
        return raw
            .map((e) {
              if (e is Map) {
                return SavedHotel.fromJson(Map<String, dynamic>.from(e));
              }
              return null;
            })
            .whereType<SavedHotel>()
            .toList();
      } catch (e) {
        debugPrint('FavoritesRepository: Error parsing hotels: $e');
        return [];
      }
    }
    return [];
  }

  /// Get saved hotel IDs (for quick lookup)
  Set<String> getSavedHotelIds() {
    return getSavedHotels().map((o) => o.id).toSet();
  }

  /// Check if a hotel is saved
  bool isHotelSaved(String id) {
    return getSavedHotelIds().contains(id);
  }

  /// Save a hotel with full data
  Future<void> saveHotel(SavedHotel hotel) async {
    final box = await _getLazyBox();
    final hotels = getSavedHotels();

    // Don't add duplicates
    if (hotels.any((o) => o.id == hotel.id)) {
      debugPrint('FavoritesRepository: Hotel ${hotel.id} already exists');
      return;
    }

    hotels.add(hotel);
    final jsonList = hotels.map((o) => o.toJson()).toList();
    await box.put(_hotelsKey, jsonList);
    debugPrint(
      'FavoritesRepository: Saved hotel ${hotel.id}. Total: ${hotels.length}',
    );
  }

  /// Remove a saved hotel by ID
  Future<void> removeSavedHotel(String id) async {
    final box = await _getLazyBox();
    final hotels = getSavedHotels();
    final before = hotels.length;
    hotels.removeWhere((o) => o.id == id);

    if (hotels.length < before) {
      final jsonList = hotels.map((o) => o.toJson()).toList();
      await box.put(_hotelsKey, jsonList);
      debugPrint(
        'FavoritesRepository: Removed hotel $id. Total: ${hotels.length}',
      );
    }
  }

  // ==================== LEGACY HOTEL IDS (backward compat) ====================

  List<String> getFavoriteHotels() {
    if (!Hive.isBoxOpen(_boxName)) {
      return [];
    }
    final box = Hive.box(_boxName);
    final raw = box.get(_legacyIdsKey, defaultValue: []);
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  Future<void> saveFavoriteHotel(String id) async {
    final box = await _getLazyBox();
    final currents = getFavoriteHotels();
    if (!currents.contains(id)) {
      currents.add(id);
      await box.put(_legacyIdsKey, currents);
      debugPrint('FavoritesRepository: Saved hotel $id. New list: $currents');
    }
  }

  Future<void> removeFavoriteHotel(String id) async {
    final box = await _getLazyBox();
    final currents = getFavoriteHotels();
    if (currents.contains(id)) {
      currents.remove(id);
      await box.put(_legacyIdsKey, currents);
      debugPrint('FavoritesRepository: Removed hotel $id. New list: $currents');
    }
  }

  // ==================== ACTIVITIES ====================

  List<String> getFavoriteActivities() {
    if (!Hive.isBoxOpen(_boxName)) {
      return [];
    }
    final box = Hive.box(_boxName);
    final raw = box.get(_activitiesKey, defaultValue: []);
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  Future<void> saveFavoriteActivity(String id) async {
    final box = await _getLazyBox();
    final currents = getFavoriteActivities();
    if (!currents.contains(id)) {
      currents.add(id);
      await box.put(_activitiesKey, currents);
      debugPrint(
        'FavoritesRepository: Saved activity $id. New list: $currents',
      );
    }
  }

  Future<void> removeFavoriteActivity(String id) async {
    final box = await _getLazyBox();
    final currents = getFavoriteActivities();
    if (currents.contains(id)) {
      currents.remove(id);
      await box.put(_activitiesKey, currents);
      debugPrint(
        'FavoritesRepository: Removed activity $id. New list: $currents',
      );
    }
  }
}
