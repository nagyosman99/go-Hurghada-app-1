import 'package:flutter/material.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class HotelPhotoCarousel extends StatefulWidget {
  final List<String> photos;
  final String? heroTag;

  const HotelPhotoCarousel({super.key, required this.photos, this.heroTag});

  @override
  State<HotelPhotoCarousel> createState() => _HotelPhotoCarouselState();
}

class _HotelPhotoCarouselState extends State<HotelPhotoCarousel> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: widget.photos.length,
          itemBuilder: (context, index) {
            final image = AppNetworkImage(
              imageUrl: widget.photos[index],
              fit: BoxFit.cover,
            );

            if (index == 0 && widget.heroTag != null) {
              return Hero(tag: widget.heroTag!, child: image);
            }
            return image;
          },
        ),

        // Gradient overlay at bottom
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
            child: SizedBox(height: 80),
          ),
        ),

        // Dot indicators
        if (widget.photos.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.photos.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
