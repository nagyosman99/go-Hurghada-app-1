import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_hurghada/features/activities/domain/entities/pickup_info.dart';

class Activity extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String location;
  final String duration;
  final double rating;
  final List<String> images;
  final String category;
  final List<DateTime> availableDates;

  // New fields for redesign
  final String ageRequirement;
  final bool pickupIncluded;
  final List<String> languages;
  final bool instantConfirmation;
  final bool freeCancellation;
  final String fullDescription;
  final List<String> whatsIncluded;
  final List<String> whatsNotIncluded;
  final PickupInfo? pickupInfo;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.duration,
    required this.rating,
    required this.images,
    required this.category,
    required this.availableDates,
    required this.ageRequirement,
    required this.pickupIncluded,
    required this.languages,
    required this.instantConfirmation,
    required this.freeCancellation,
    required this.fullDescription,
    required this.whatsIncluded,
    required this.whatsNotIncluded,
    this.pickupInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'duration': duration,
      'rating': rating,
      'images': images,
      'category': category,
      'availableDates': availableDates.map((d) => d.toIso8601String()).toList(),
      'ageRequirement': ageRequirement,
      'pickupIncluded': pickupIncluded,
      'languages': languages,
      'instantConfirmation': instantConfirmation,
      'freeCancellation': freeCancellation,
      'fullDescription': fullDescription,
      'whatsIncluded': whatsIncluded,
      'whatsNotIncluded': whatsNotIncluded,
      'pickupInfo': pickupInfo?.toJson(),
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      location: json['location'] ?? '',
      duration: json['duration'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      availableDates: (json['availableDates'] as List<dynamic>?)?.map((e) {
            if (e is String) return DateTime.parse(e);
            if (e is Timestamp) return e.toDate();
            return DateTime.parse(e.toString());
          }).toList() ??
          <DateTime>[],
      ageRequirement: json['ageRequirement'] ?? '',
      pickupIncluded: json['pickupIncluded'] ?? false,
      languages: List<String>.from(json['languages'] ?? []),
      instantConfirmation: json['instantConfirmation'] ?? false,
      freeCancellation: json['freeCancellation'] ?? false,
      fullDescription: json['fullDescription'] ?? '',
      whatsIncluded: List<String>.from(json['whatsIncluded'] ?? []),
      whatsNotIncluded: List<String>.from(json['whatsNotIncluded'] ?? []),
      pickupInfo: json['pickupInfo'] != null
          ? PickupInfo.fromJson(json['pickupInfo'])
          : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    location,
    duration,
    rating,
    images,
    category,
    availableDates,
    ageRequirement,
    pickupIncluded,
    languages,
    instantConfirmation,
    freeCancellation,
    fullDescription,
    whatsIncluded,
    whatsNotIncluded,
    pickupInfo,
  ];
}
