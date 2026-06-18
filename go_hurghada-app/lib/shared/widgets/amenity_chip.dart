import 'package:flutter/material.dart';

/// Amenity chip with icon
class AmenityChip extends StatelessWidget {
  final String amenity;
  final bool compact;

  const AmenityChip({super.key, required this.amenity, this.compact = false});

  IconData _getAmenityIcon(String amenity) {
    final amenityLower = amenity.toLowerCase();

    if (amenityLower.contains('wifi') || amenityLower.contains('internet')) {
      return Icons.wifi;
    } else if (amenityLower.contains('pool') ||
        amenityLower.contains('swimming')) {
      return Icons.pool;
    } else if (amenityLower.contains('spa')) {
      return Icons.spa;
    } else if (amenityLower.contains('beach')) {
      return Icons.beach_access;
    } else if (amenityLower.contains('restaurant') ||
        amenityLower.contains('dining')) {
      return Icons.restaurant;
    } else if (amenityLower.contains('gym') ||
        amenityLower.contains('fitness')) {
      return Icons.fitness_center;
    } else if (amenityLower.contains('parking')) {
      return Icons.local_parking;
    } else if (amenityLower.contains('bar')) {
      return Icons.local_bar;
    } else if (amenityLower.contains('air') || amenityLower.contains('ac')) {
      return Icons.ac_unit;
    } else if (amenityLower.contains('tv')) {
      return Icons.tv;
    } else if (amenityLower.contains('breakfast')) {
      return Icons.free_breakfast;
    } else if (amenityLower.contains('room service')) {
      return Icons.room_service;
    } else if (amenityLower.contains('safe')) {
      return Icons.lock;
    } else if (amenityLower.contains('balcony')) {
      return Icons.balcony;
    } else {
      return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Tooltip(
        message: amenity,
        child: Icon(
          _getAmenityIcon(amenity),
          size: 20,
          color: Colors.grey.shade700,
        ),
      );
    }

    return Chip(
      avatar: Icon(
        _getAmenityIcon(amenity),
        size: 16,
        color: Colors.grey.shade700,
      ),
      label: Text(amenity, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// Amenities grid display
class AmenitiesGrid extends StatelessWidget {
  final List<String> amenities;
  final bool compact;
  final int maxItems;

  const AmenitiesGrid({
    super.key,
    required this.amenities,
    this.compact = false,
    this.maxItems = 6,
  });

  @override
  Widget build(BuildContext context) {
    final displayAmenities = amenities.take(maxItems).toList();
    final hasMore = amenities.length > maxItems;

    if (compact) {
      return Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          ...displayAmenities.map(
            (a) => AmenityChip(amenity: a, compact: true),
          ),
          if (hasMore)
            Text(
              '+${amenities.length - maxItems} more',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
        ],
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: displayAmenities.map((a) => AmenityChip(amenity: a)).toList(),
    );
  }
}
