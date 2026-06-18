import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

/// Background widget for authentication screens
/// Provides a gradient background with consistent theming
class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.authPrimary, AppColors.authSecondary],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
