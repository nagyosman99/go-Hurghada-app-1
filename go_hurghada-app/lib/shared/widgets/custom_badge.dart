import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const CustomBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
  });

  factory CustomBadge.success({required String text, double? fontSize}) {
    return CustomBadge(
      text: text,
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      textColor: Colors.green,
      borderColor: Colors.green.withValues(alpha: 0.3),
      fontSize: fontSize,
    );
  }

  factory CustomBadge.info({required String text, double? fontSize}) {
    return CustomBadge(
      text: text,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      textColor: AppColors.primary,
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 11,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
