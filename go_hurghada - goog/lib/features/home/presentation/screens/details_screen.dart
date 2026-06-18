import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/home/presentation/widgets/details/details_header.dart';
import 'package:go_hurghada/features/home/presentation/widgets/details/details_content.dart';
import 'package:go_hurghada/features/home/presentation/widgets/details/details_bottom_bar.dart';

class DetailsScreen extends StatelessWidget {
  final LocationModel? location;
  final OfferCardModel? offer;

  const DetailsScreen({super.key, this.location, this.offer});

  @override
  Widget build(BuildContext context) {
    final title = location?.name ?? offer?.hotelName ?? '';
    final imageUrl = location?.image ?? offer?.image ?? '';
    final rating = offer?.rating ?? 4.5;
    final locationName = offer?.location ?? 'Hurghada, Egypt';
    final amenities = offer?.amenities ?? [];

    return Scaffold(
      body: Stack(
        children: [
          // Header (Image, Gradient, Back Button, Title)
          DetailsHeader(imageUrl: imageUrl, title: title),

          // Content Scrollable Sheet
          Positioned.fill(
            top: 280,
            child: DetailsContent(
              title: title,
              rating: rating,
              locationName: locationName,
              amenities: amenities,
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DetailsBottomBar(
              onBook: () {
                if (offer != null) {
                  context.push('/select-room', extra: offer);
                } else {
                  // Handle location case or show snackbar
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Select Room')));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
