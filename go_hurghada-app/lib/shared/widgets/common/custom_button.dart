import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

/// A customizable button widget that supports primary and secondary styles.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = AppDimensions.radiusMedium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? (isPrimary ? AppColors.primary : Colors.white);
    final effectiveForegroundColor =
        foregroundColor ?? (isPrimary ? Colors.white : AppColors.primary);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          elevation: isPrimary ? 2 : 0,
          side: isPrimary
              ? null
              : BorderSide(color: effectiveForegroundColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    effectiveForegroundColor,
                  ),
                ),
              )
            : Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: effectiveForegroundColor,
                ),
              ),
      ),
    );
  }
}
