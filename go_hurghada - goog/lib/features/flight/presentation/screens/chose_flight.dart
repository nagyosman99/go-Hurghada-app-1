import 'package:flutter/material.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class ChoseFlight extends StatelessWidget {
  const ChoseFlight({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.chooseFlight,
          style: theme.textTheme.headlineMedium,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: theme.textTheme.titleLarge?.color,
      ),
      body: Center(
        child: Text(
          'Flight selection screen coming soon!',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
