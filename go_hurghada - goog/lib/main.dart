import 'package:flutter/material.dart';
import 'package:go_hurghada/core/providers/app_lifecycle_provider.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/core/providers/currency_scope.dart';
import 'package:go_hurghada/core/init/app_initializer.dart';
import 'package:go_hurghada/core/init/dependency_injection.dart';

void main() async {
  // 1. Initialize System & Core Services (Env, Hive, etc.)
  await AppInitializer.init();

  // 2. Setup Dependency Injection (ViewModels, Repositories)
  final appProvider = await DependencyInjection.createProvider(
    child: const AppLifecycleObserver(child: MyApp()),
  );

  // 3. Launch App with Dependencies
  runApp(appProvider);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = AppProvider.of(context).settingsViewModel;

    return ListenableBuilder(
      listenable: settingsViewModel,
      builder: (context, _) {
        final settings = settingsViewModel.state;

        return MaterialApp.router(
          title: 'Go Hurghada',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: AppProvider.of(context).appRouter.router,
          builder: (context, child) {
            return CurrencyScope(
              currencyCode: settings.currency,
              child: child!,
            );
          },
        );
      },
    );
  }
}
