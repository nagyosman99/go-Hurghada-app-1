import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Back button widget for authentication screens
/// Positioned at top-left with consistent styling
class AuthBackButton extends StatelessWidget {
  final Color color;

  const AuthBackButton({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: color == Colors.white
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: color),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/landing');
            }
          },
        ),
      ),
    );
  }
}
