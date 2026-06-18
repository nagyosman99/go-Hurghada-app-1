import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';

/// A model to persist saved hotels with all their display data.
/// This ensures saved hotels show the same info as when they were saved.
class SavedHotel {
  final String id;
  final String hotelName;
  final String image;
  final String? discount;
  final double price;
  final double? originalPrice;
  final double rating;
  final String location;
  final List<String> amenities;
  final bool isAllInclusive;
  final String? distance;
  final DateTime savedAt;

  SavedHotel({
    required this.id,
    required this.hotelName,
    required this.image,
    this.discount,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.location,
    required this.amenities,
    required this.isAllInclusive,
    this.distance,
    DateTime? savedAt,
  }) : savedAt = savedAt ?? DateTime.now();

  /// Create from OfferCardModel (renamed to Summary for clarity)
  factory SavedHotel.fromOfferSummary(OfferCardModel offer) {
    return SavedHotel(
      id: offer.id,
      hotelName: offer.hotelName,
      image: offer.image,
      discount: offer.discount,
      price: offer.price,
      originalPrice: offer.originalPrice,
      rating: offer.rating,
      location: offer.location,
      amenities: offer.amenities,
      isAllInclusive: offer.isAllInclusive,
      distance: offer.distance,
    );
  }

  /// Create from HotelSearchResult
  factory SavedHotel.fromHotelSearchResult(HotelSearchResult hotel) {
    return SavedHotel(
      id: hotel.id,
      hotelName: hotel.name,
      image: hotel.imageUrl,
      discount: hotel.discount,
      price: hotel.pricePerNight,
      originalPrice: hotel.originalPrice,
      rating: hotel.rating,
      location: hotel.address,
      amenities: [], // HotelSearchResult doesn't have amenities list usually
      isAllInclusive: hotel.isAllInclusive,
      distance: null,
    );
  }

  /// Create from HotelDetails
  factory SavedHotel.fromHotelDetails(HotelDetails hotel) {
    return SavedHotel(
      id: hotel.id,
      hotelName: hotel.name,
      image: hotel.imageUrl,
      discount: hotel.discount,
      price: hotel.pricePerNight,
      originalPrice: hotel.originalPrice,
      rating: hotel.rating,
      location: hotel.address,
      amenities: hotel.amenities,
      isAllInclusive: hotel.isAllInclusive,
      distance: null,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'hotelName': hotelName,
    'image': image,
    'discount': discount,
    'price': price,
    'originalPrice': originalPrice,
    'rating': rating,
    'location': location,
    'amenities': amenities,
    'isAllInclusive': isAllInclusive,
    'distance': distance,
    'savedAt': savedAt.toIso8601String(),
  };

  /// Create from JSON
  factory SavedHotel.fromJson(Map<String, dynamic> json) {
    return SavedHotel(
      id: json['id'] as String,
      hotelName: json['hotelName'] as String,
      image: json['image'] as String,
      discount: json['discount'] as String?,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      rating: (json['rating'] as num).toDouble(),
      location: json['location'] as String,
      amenities: List<String>.from(json['amenities'] as List? ?? []),
      isAllInclusive: json['isAllInclusive'] as bool? ?? false,
      distance: json['distance'] as String?,
      savedAt: json['savedAt'] != null
          ? DateTime.parse(json['savedAt'] as String)
          : DateTime.now(),
    );
  }

  double get discountValue {
    if (discount == null || discount!.isEmpty) return 0.0;
    final cleanDiscount = discount!.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleanDiscount.isEmpty) return 0.0;
    return (double.tryParse(cleanDiscount) ?? 0.0) / 100;
  }

  /// Convert back to OfferCardModel for compatibility with results screen
  OfferCardModel toOfferCard() {
    return OfferCardModel(
      id: id,
      hotelName: hotelName,
      image: image,
      discount: discount ?? '',
      price: price,
      originalPrice: originalPrice,
      rating: rating,
      location: location,
      amenities: amenities,
      isAllInclusive: isAllInclusive,
      distance: distance ?? '',
    );
  }

  /// Helper for navigating to standard hotel details
  Map<String, dynamic> toDetailsExtra() {
    return {
      'checkIn': null,
      'checkOut': null,
      'adults': null,
      'children': null,
      'rooms': null,
      'discountPercentage': discountValue,
    };
  }
}
