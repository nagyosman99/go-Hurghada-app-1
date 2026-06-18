import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/shared/widgets/loading_view.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl.startsWith('http')) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? _buildLoadingPlaceholder(),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildErrorPlaceholder(),
      );
    } else if (imageUrl.startsWith('/') || imageUrl.startsWith('file://')) {
      // Handle local file paths (e.g. from image picker)
      imageWidget = Image.file(
        File(imageUrl),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _buildErrorPlaceholder(),
      );
    } else {
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _buildErrorPlaceholder(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.lightGrey,
      child: const Center(
        child: Icon(Icons.image_not_supported, color: AppColors.grey),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return SizedBox(width: width, height: height, child: const LoadingView());
  }
}
