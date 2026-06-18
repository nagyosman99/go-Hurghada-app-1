import 'package:flutter/material.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

/// Shared hotel facilities widget used in both hotel details and offer details
class HotelFacilitiesWidget extends StatefulWidget {
  final List<String> amenities;
  final int initialDisplayCount;

  const HotelFacilitiesWidget({
    super.key,
    required this.amenities,
    this.initialDisplayCount = 6,
  });

  @override
  State<HotelFacilitiesWidget> createState() => _HotelFacilitiesWidgetState();
}

class _HotelFacilitiesWidgetState extends State<HotelFacilitiesWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final displayedAmenities = _isExpanded
        ? widget.amenities
        : widget.amenities.take(widget.initialDisplayCount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.mostPopularFacilities ?? 'Most Popular Facilities',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: displayedAmenities
              .map((amenity) => _AmenityChip(amenity: amenity))
              .toList(),
        ),
        if (widget.amenities.length > widget.initialDisplayCount) ...[
          const SizedBox(height: 16),
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded
                      ? (l10n?.showLess ?? 'Show less')
                      : (l10n?.viewAllAmenities ?? 'View all amenities'),
                  style: const TextStyle(
                    color: Color(0xFF0084ff),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.chevron_right,
                  size: 20,
                  color: const Color(0xFF0084ff),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String amenity;

  const _AmenityChip({required this.amenity});

  static IconData getIconForAmenity(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('wifi') || lower.contains('internet')) return Icons.wifi;
    if (lower.contains('pool') || lower.contains('swimming')) return Icons.pool;
    if (lower.contains('gym') || lower.contains('fitness')) {
      return Icons.fitness_center;
    }
    if (lower.contains('spa') || lower.contains('massage')) return Icons.spa;
    if (lower.contains('dining') || lower.contains('restaurant')) {
      return Icons.restaurant;
    }
    if (lower.contains('bar') || lower.contains('drink')) {
      return Icons.local_bar;
    }
    if (lower.contains('parking')) return Icons.local_parking;
    if (lower.contains('beach')) return Icons.beach_access;
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFf5f7f9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getIconForAmenity(amenity),
            size: 20,
            color: const Color(0xFF0084ff),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              amenity,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a1a),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
