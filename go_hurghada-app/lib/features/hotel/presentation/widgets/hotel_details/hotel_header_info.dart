import 'package:flutter/material.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/shared/widgets/rating_display.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';

class HotelHeaderInfo extends StatelessWidget {
  final HotelDetails hotel;

  const HotelHeaderInfo({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hotel.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              RatingDisplay(rating: hotel.rating, size: 18),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      hotel.address,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
