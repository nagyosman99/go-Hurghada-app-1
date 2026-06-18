import 'package:flutter/material.dart';
import 'package:go_hurghada/features/auth/domain/repositories/auth_repository.dart';
import 'package:go_hurghada/features/auth/models/settings_model.dart';

/// ViewModel for managing application settings like theme, locale, and currency.
class SettingsViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  SettingsViewModel({required AuthRepository repository})
    : _repository = repository;

  SettingsState _state = const SettingsState();

  /// The current settings state.
  SettingsState get state => _state;

  Future<void> loadSettings() async {
    final settings = await _repository.getSettings();
    if (settings != null) {
      _state = settings;
      notifyListeners();
    }
  }

  /// Toggles between light and dark theme modes.
  Future<void> toggleTheme(bool isDark) async {
    _state = _state.copyWith(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    );
    notifyListeners();
    await _repository.saveSettings(_state);
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _state = _state.copyWith(themeMode: mode);
    notifyListeners();
    await _repository.saveSettings(_state);
  }

  /// Updates the application locale.
  Future<void> updateLocale(Locale locale) async {
    _state = _state.copyWith(locale: locale);
    notifyListeners();
    await _repository.saveSettings(_state);
  }

  Future<void> updateCurrency(String currencyCode) async {
    _state = _state.copyWith(currency: currencyCode);
    notifyListeners();
    await _repository.saveSettings(_state);
  }

  Future<void> toggleNotifications(bool enabled) async {
    _state = _state.copyWith(notificationsEnabled: enabled);
    notifyListeners();
    await _repository.saveSettings(_state);
  }

  Future<void> toggleLocation(bool enabled) async {
    _state = _state.copyWith(locationEnabled: enabled);
    notifyListeners();
    await _repository.saveSettings(_state);
  }

  Future<void> toggleThirdParties(bool enabled) async {
    _state = _state.copyWith(thirdPartiesEnabled: enabled);
    notifyListeners();
    await _repository.saveSettings(_state);
  }
}
