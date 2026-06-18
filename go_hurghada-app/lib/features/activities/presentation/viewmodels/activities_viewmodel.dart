import 'package:flutter/material.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/activities/domain/repository/activities_repository.dart';

class ActivitiesState {
  final List<Activity> activities;
  final List<Activity> filteredActivities;
  final String selectedCategory;
  final bool isLoading;
  final String? error;

  ActivitiesState({
    this.activities = const [],
    this.filteredActivities = const [],
    this.selectedCategory = 'All',
    this.isLoading = false,
    this.error,
  });

  ActivitiesState copyWith({
    List<Activity>? activities,
    List<Activity>? filteredActivities,
    String? selectedCategory,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ActivitiesState(
      activities: activities ?? this.activities,
      filteredActivities: filteredActivities ?? this.filteredActivities,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}


/// ViewModel for managing the activities list, filtering, and searching.
class ActivitiesViewModel extends ChangeNotifier {
  final ActivitiesRepository _repository;
  ActivitiesState _state = ActivitiesState();

  ActivitiesViewModel({required ActivitiesRepository repository})
    : _repository = repository {
    loadActivities();
  }

  /// The current state of activities and filters.
  ActivitiesState get state => _state;

  /// Loads all available activities from the repository.
  Future<void> loadActivities() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final activities = await _repository.getAllActivities();
      _state = _state.copyWith(
        activities: activities,
        filteredActivities: _applyFilter(activities, _state.selectedCategory),
        isLoading: false,
      );
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  void filterByCategory(String category) {
    _state = _state.copyWith(
      selectedCategory: category,
      filteredActivities: _applyFilter(_state.activities, category),
    );
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      filterByCategory(_state.selectedCategory);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filtered = _state.activities.where((a) {
      final matchesCategory =
          _state.selectedCategory == 'All' ||
          a.category == _state.selectedCategory;
      final matchesQuery =
          a.title.toLowerCase().contains(lowerQuery) ||
          a.description.toLowerCase().contains(lowerQuery);
      return matchesCategory && matchesQuery;
    }).toList();

    _state = _state.copyWith(filteredActivities: filtered);
    notifyListeners();
  }

  List<Activity> _applyFilter(List<Activity> activities, String category) {
    if (category == 'All') return activities;
    return activities.where((a) => a.category == category).toList();
  }

  Activity? getActivityById(String id) {
    try {
      return _state.activities.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
