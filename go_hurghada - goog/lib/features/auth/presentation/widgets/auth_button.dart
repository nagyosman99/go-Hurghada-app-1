import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/shared/widgets/common/custom_button.dart';

/// Button widget for authentication screens
/// Wraps CustomButton with auth-specific defaults
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
  });

  /// Creates a primary button (filled)
  factory AuthButton.primary({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      text: text,
      onPressed: onPressed,
      isPrimary: true,
      isLoading: isLoading,
    );
  }

  /// Creates a secondary button (outlined)
  factory AuthButton.secondary({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      text: text,
      onPressed: onPressed,
      isPrimary: false,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isPrimary: isPrimary,
      isLoading: isLoading,
      backgroundColor: isPrimary
          ? AppColors.authPrimary
          : (Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Theme.of(context).cardColor),
      foregroundColor: isPrimary
          ? Colors.white
          : (Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppColors.authPrimary),
    );
  }
}
