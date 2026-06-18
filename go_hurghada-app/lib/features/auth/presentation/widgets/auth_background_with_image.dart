import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

/// Background widget for authentication screens with image support
/// Provides either an image background with gradient overlay or pure gradient
class AuthBackgroundWithImage extends StatelessWidget {
  final Widget child;
  final String? imagePath;
  final bool showGradientOverlay;

  const AuthBackgroundWithImage({
    super.key,
    required this.child,
    this.imagePath,
    this.showGradientOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: imagePath != null
            ? DecorationImage(image: AssetImage(imagePath!), fit: BoxFit.cover)
            : null,
        gradient: imagePath == null
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.authPrimary, AppColors.authSecondary],
              )
            : null,
      ),
      child: imagePath != null && showGradientOverlay
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: child,
            )
          : child,
    );
  }
}
