import 'package:flutter/material.dart';
import 'package:go_hurghada/features/home/data/home_data.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/activities/domain/repository/activities_repository.dart';

class HomeState {
  final List<CategoryModel> categories;
  final List<LocationModel> locations;
  final List<ActivityModel> activities;
  final List<OfferCardModel> offers;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.categories = const [],
    this.locations = const [],
    this.activities = const [],
    this.offers = const [],
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<CategoryModel>? categories,
    List<LocationModel>? locations,
    List<ActivityModel>? activities,
    List<OfferCardModel>? offers,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      locations: locations ?? this.locations,
      activities: activities ?? this.activities,
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// ViewModel for fetching and managing the consolidated home screen data.
class HomeViewModel extends ChangeNotifier {
  final ActivitiesRepository? _activitiesRepository;
  HomeState _state = const HomeState();

  /// The current home screen state, including categories, locations, and offers.
  HomeState get state => _state;

  HomeViewModel({ActivitiesRepository? activitiesRepository})
      : _activitiesRepository = activitiesRepository {
    loadHomeData();
  }

  /// Loads the home screen data from static and dynamic sources.
  Future<void> loadHomeData() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // 1. Load static data
      List<ActivityModel> activities = List.from(HomeData.activities);

      // 2. Load dynamic activities from repository if available
      if (_activitiesRepository != null) {
        final dynamicActivities = await _activitiesRepository.getAllActivities();
        // Convert dynamic activities to ActivityModel
        final mappedActivities = dynamicActivities.map((a) => ActivityModel(
          id: a.id,
          name: a.title,
          image: a.images.isNotEmpty ? a.images.first : 'assets/safari.jpg',
          description: a.description,
          category: a.category,
        )).toList();
        
        // Merge unique by ID (Dynamic ones override static ones)
        final Map<String, ActivityModel> activityMap = {
          for (var a in activities) a.id: a,
          for (var a in mappedActivities) a.id: a,
        };
        activities = activityMap.values.toList();
      }

      _state = _state.copyWith(
        categories: HomeData.categories,
        locations: HomeData.locations,
        activities: activities,
        offers: HomeData.offers,
        isLoading: false,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}
