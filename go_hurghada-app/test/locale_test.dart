import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_hurghada/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/settings_viewmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Hive.init('.');
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  test('SettingsViewModel updates locale correctly', () async {
    // Mock Hive box and repository
    await Hive.openBox('settings_box');
    final repository = HiveAuthRepository();
    final viewModel = SettingsViewModel(repository: repository);

    // Initial state check
    expect(viewModel.state.locale, const Locale('en'));

    // Update to Arabic
    viewModel.updateLocale(const Locale('ar'));

    // Check if state updated
    expect(viewModel.state.locale, const Locale('ar'));

    // Update back to English
    viewModel.updateLocale(const Locale('en'));
    expect(viewModel.state.locale, const Locale('en'));

    await Hive.close();
  });
}
