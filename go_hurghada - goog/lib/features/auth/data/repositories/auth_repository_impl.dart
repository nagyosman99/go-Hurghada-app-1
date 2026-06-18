import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_hurghada/features/auth/domain/repositories/auth_repository.dart';
import 'package:go_hurghada/features/auth/models/profile_model.dart';
import 'package:go_hurghada/features/auth/models/settings_model.dart';

/// Hive-based implementation of [AuthRepository] for local persistence.
class HiveAuthRepository implements AuthRepository {
  static const String profileBoxName = 'profile_box';
  static const String settingsBoxName = 'settings_box';
  static const String profileKey = 'user_profile';
  static const String settingsKey = 'app_settings';

  Box _getProfileBox() => Hive.box(profileBoxName);
  Box _getSettingsBox() => Hive.box(settingsBoxName);

  @override
  Future<void> signIn(String email, String password) async {}

  @override
  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {}

  @override
  Future<void> signOut() async {
    await clearProfile();
  }

  @override
  Future<UserProfile?> getProfile() async {
    final box = _getProfileBox();
    final String? jsonString = box.get(profileKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return UserProfile.fromJson(jsonMap);
      } catch (e) {
        debugPrint('Error decoding profile: $e');
      }
    }
    return null;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final box = _getProfileBox();
    final String jsonString = json.encode(profile.toJson());
    await box.put(profileKey, jsonString);
  }

  @override
  Future<void> clearProfile() async {
    final box = _getProfileBox();
    await box.delete(profileKey);
  }

  @override
  Future<SettingsState?> getSettings() async {
    final box = _getSettingsBox();
    final String? jsonString = box.get(settingsKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return SettingsState.fromJson(jsonMap);
      } catch (e) {
        debugPrint('Error decoding settings: $e');
      }
    }
    return null;
  }

  @override
  Future<void> saveSettings(SettingsState settings) async {
    final box = _getSettingsBox();
    final String jsonString = json.encode(settings.toJson());
    await box.put(settingsKey, jsonString);
  }
}
