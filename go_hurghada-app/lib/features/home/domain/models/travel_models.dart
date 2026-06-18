import 'package:flutter/material.dart';

class LocationModel {
  final String id;
  final String name;
  final String image;

  LocationModel({required this.id, required this.name, required this.image});
}

class OfferCardModel {
  final String id;
  final String hotelName;
  final String image;
  final String discount;
  final double price;
  final double rating;
  final String location;
  final List<String> amenities;
  final double? originalPrice;
  final bool isAllInclusive;
  final String distance;

  OfferCardModel({
    required this.id,
    required this.hotelName,
    required this.image,
    required this.discount,
    required this.price,
    required this.rating,
    required this.location,
    required this.amenities,
    this.originalPrice,
    required this.isAllInclusive,
    required this.distance,
  });

  /// Factory from HotelSearchResult
  factory OfferCardModel.fromHotelSearchResult(dynamic hotel) {
    return OfferCardModel(
      id: hotel.id,
      hotelName: hotel.name,
      image: hotel.imageUrl,
      discount: hotel.discount ?? '',
      price: hotel.pricePerNight,
      rating: hotel.rating,
      location: hotel.address,
      amenities: List<String>.from(hotel.amenities),
      isAllInclusive: hotel.isAllInclusive,
      originalPrice: hotel.originalPrice,
      distance: '',
    );
  }

  double get discountValue {
    if (discount.isEmpty) return 0.0;
    final cleanDiscount = discount.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleanDiscount.isEmpty) return 0.0;
    return (double.tryParse(cleanDiscount) ?? 0.0) / 100;
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String imagePath; // Asset image path
  final Color backgroundColor; // Card color
  final Widget page; // destination to navigate

  CategoryModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.backgroundColor,
    required this.page,
  });
}

class ActivityModel {
  final String id;
  final String name;
  final String image;
  final String? description;
  final String? category;

  ActivityModel({
    required this.id,
    required this.name,
    required this.image,
    this.description,
    this.category,
  });
}
