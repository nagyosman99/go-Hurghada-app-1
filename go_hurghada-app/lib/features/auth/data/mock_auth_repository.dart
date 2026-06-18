import 'package:go_hurghada/features/auth/domain/repositories/auth_repository.dart';
import 'package:go_hurghada/features/auth/models/profile_model.dart';
import 'package:go_hurghada/features/auth/models/settings_model.dart';

class MockAuthRepository implements AuthRepository {
  UserProfile? _profile;
  SettingsState? _settings;

  // Simulate network delay
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<UserProfile?> getProfile() async {
    await _delay();
    return _profile;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _delay();
    _profile = profile;
  }

  @override
  Future<void> clearProfile() async {
    await _delay();
    _profile = null;
  }

  @override
  Future<void> signIn(String email, String password) async {
    await _delay();
    // Simulate successful sign in by setting a dummy profile
    _profile = const UserProfile(
      email: 'mock@example.com',
      firstName: 'Mock',
      lastName: 'User',
      phoneNumber: '',
    );
  }

  @override
  Future<void> signUp(
      String email, String password, String firstName, String lastName) async {
    await _delay();
    // Simulate successful sign up
    _profile = UserProfile(
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: '',
    );
  }

  @override
  Future<void> signOut() async {
    await _delay();
    _profile = null;
  }

  @override
  Future<SettingsState?> getSettings() async {
    await _delay();
    return _settings;
  }

  @override
  Future<void> saveSettings(SettingsState settings) async {
    await _delay();
    _settings = settings;
  }
}
