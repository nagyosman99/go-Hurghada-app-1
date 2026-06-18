import 'package:flutter/material.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;
  final String currency;
  final bool notificationsEnabled;
  final bool locationEnabled;
  final bool thirdPartiesEnabled;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
    this.currency = 'EGP', // Default currency
    this.notificationsEnabled = true,
    this.locationEnabled = true,
    this.thirdPartiesEnabled = false,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    String? currency,
    bool? notificationsEnabled,
    bool? locationEnabled,
    bool? thirdPartiesEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      thirdPartiesEnabled: thirdPartiesEnabled ?? this.thirdPartiesEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'languageCode': locale.languageCode,
      'currency': currency,
      'notificationsEnabled': notificationsEnabled,
      'locationEnabled': locationEnabled,
      'thirdPartiesEnabled': thirdPartiesEnabled,
    };
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      themeMode: json['themeMode'] != null
          ? ThemeMode.values[json['themeMode']]
          : ThemeMode.system,
      locale: Locale(json['languageCode'] ?? 'en'),
      currency: json['currency'] ?? 'EGP',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      locationEnabled: json['locationEnabled'] ?? true,
      thirdPartiesEnabled: json['thirdPartiesEnabled'] ?? false,
    );
  }
}
