import 'package:flutter/material.dart';

/// Rating display widget with stars
class RatingDisplay extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final bool showNumber;

  const RatingDisplay({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16,
    this.showNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: size, color: Colors.amber),
        if (showNumber) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size * 0.875,
            ),
          ),
        ],
      ],
    );
  }
}

/// Star rating widget (for displaying multiple stars)
class StarRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, size: size, color: color);
        } else if (index < rating) {
          return Icon(Icons.star_half, size: size, color: color);
        } else {
          return Icon(Icons.star_border, size: size, color: color);
        }
      }),
    );
  }
}
