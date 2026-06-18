import 'package:flutter/material.dart';
import 'package:go_hurghada/features/auth/domain/repositories/auth_repository.dart';
import 'package:go_hurghada/features/auth/models/profile_model.dart';

/// ViewModel for managing the user profile data.
class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  ProfileViewModel({required AuthRepository repository})
    : _repository = repository;

  UserProfile _state = UserProfile.empty();

  /// The current user profile.
  UserProfile get state => _state;

  Future<void> loadProfile() async {
    try {
      final profile = await _repository.getProfile().timeout(const Duration(seconds: 8));
      if (profile != null) {
        _state = profile;
      } else {
        _state = UserProfile.empty();
      }
    } catch (e) {
      debugPrint('[ProfileViewModel] Error loading profile: $e');
      _state = UserProfile.empty();
    }
    notifyListeners();
  }

  /// Updates the user profile with new information.
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImagePath,
  }) async {
    _state = _state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      profileImagePath: profileImagePath,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    await _repository.saveProfile(_state);
  }

  Future<void> clearProfile() async {
    _state = UserProfile.empty();
    notifyListeners();
    await _repository.clearProfile();
  }
}
