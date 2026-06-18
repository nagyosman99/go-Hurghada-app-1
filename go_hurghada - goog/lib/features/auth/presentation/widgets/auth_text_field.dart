import 'package:flutter/material.dart';

import 'package:go_hurghada/shared/widgets/common/custom_text_field.dart';

/// Text field widget for authentication screens
/// Wraps CustomTextField with auth-specific defaults
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onVisibilityToggle,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final isEmail = keyboardType == TextInputType.emailAddress;

    return CustomTextField(
      controller: controller,
      label: label,
      prefixIcon: icon,
      isPassword: isPassword,
      isPasswordVisible: isPasswordVisible,
      onVisibilityToggle: onVisibilityToggle,
      validator: validator,
      keyboardType: keyboardType,
      fillColor: Theme.of(context).cardColor,
      borderColor: Theme.of(context).dividerColor,
      textCapitalization: isEmail ? TextCapitalization.none : TextCapitalization.sentences,
      autocorrect: !isEmail,
      enableSuggestions: !isEmail,
    );
  }
}
