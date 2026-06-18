import 'package:go_hurghada/features/auth/models/profile_model.dart';
import 'package:go_hurghada/features/auth/models/settings_model.dart';

/// Repository interface for authentication and user profile management.
abstract class AuthRepository {
  // Profile
  /// Retrieves the current user profile from local storage.
  Future<UserProfile?> getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> clearProfile();

  // Authentication
  Future<void> signIn(String email, String password);
  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  );
  Future<void> signOut();

  // Settings
  /// Retrieves the application settings from local storage.
  Future<SettingsState?> getSettings();
  Future<void> saveSettings(SettingsState settings);
}
