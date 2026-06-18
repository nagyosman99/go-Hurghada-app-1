import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/constants/app_constants.dart';

class AuthHeader extends StatelessWidget {
  final String welcomeText;

  const AuthHeader({super.key, this.welcomeText = 'Welcome to'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(welcomeText, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          AppConstants.appName,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
