import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class ImageSliderWithIndicator extends StatefulWidget {
  final List<String> images;
  final double height;
  final String? heroTag;

  const ImageSliderWithIndicator({
    super.key,
    required this.images,
    this.height = 300,
    this.heroTag,
  });

  @override
  State<ImageSliderWithIndicator> createState() =>
      _ImageSliderWithIndicatorState();
}

class _ImageSliderWithIndicatorState extends State<ImageSliderWithIndicator> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = AppNetworkImage(
                imageUrl: widget.images[index],
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
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
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
      ),
    );
  }
}
