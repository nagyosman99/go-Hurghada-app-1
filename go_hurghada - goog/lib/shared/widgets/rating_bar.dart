import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final TextStyle? textStyle;
  final bool showText;

  const RatingBar({
    super.key,
    required this.rating,
    this.size = 14,
    this.color,
    this.textStyle,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: size, color: color ?? AppColors.starRating),
        if (showText) ...[
          const SizedBox(width: 4),
          Text(
            rating.toString(),
            style: textStyle ?? const TextStyle(fontSize: 12),
          ),
        ],
      ],
    );
  }
}
