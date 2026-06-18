import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

/// Container widget for authentication forms
/// Provides white rounded container with shadow
class AuthFormContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final double? heightFactor;

  const AuthFormContainer({
    super.key,
    required this.child,
    this.title,
    this.heightFactor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = heightFactor != null
        ? screenHeight * heightFactor!
        : null;

    final theme = Theme.of(context);
    return Container(
      height: containerHeight,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: containerHeight != null
            ? MainAxisSize.max
            : MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(title!, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
          ],
          if (containerHeight != null) Expanded(child: child) else child,
        ],
      ),
    );
  }
}
