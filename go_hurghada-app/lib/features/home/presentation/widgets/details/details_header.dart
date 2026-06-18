import 'package:flutter/material.dart';

class DetailsHeader extends StatelessWidget {
  final String imageUrl;
  final String title;

  const DetailsHeader({super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Background Image
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image, size: 80, color: Colors.white),
                ),
              );
            },
          ),
        ),
        // Gradient Overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ),
        // Back Button
        Positioned(
          top: 40,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.8),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        // Title on Image
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
