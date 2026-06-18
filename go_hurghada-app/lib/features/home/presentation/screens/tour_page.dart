import 'package:flutter/material.dart';

class TourPage extends StatelessWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tour', style: theme.textTheme.headlineMedium),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        foregroundColor:
            theme.appBarTheme.foregroundColor ??
            theme.textTheme.titleLarge?.color,
      ),
      body: Center(child: Text('Tour Page', style: theme.textTheme.bodyLarge)),
    );
  }
}
