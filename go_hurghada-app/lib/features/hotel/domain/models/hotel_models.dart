// ==========================================
// 1. HOTEL SEARCH RESULT (List View)
// ==========================================
// Lightweight model for lists.

// Lightweight model for lists.

enum HotelSort { priceLowToHigh, priceHighToLow, ratingHighToLow }

class HotelFilter {
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;

  const HotelFilter({this.minPrice, this.maxPrice, this.minRating});

  HotelFilter copyWith({
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) {
    return HotelFilter(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
    );
  }
}

class HotelSearchResult {
  final String id;
  final String name;
  final String address;
  final double rating;
  final double pricePerNight;
  final String imageUrl;
  final List<String> amenities;
  final bool isAllInclusive;
  // Added discount fields for UI badges
  final String? discount;
  final double? originalPrice;

  HotelSearchResult({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.pricePerNight,
    required this.imageUrl,
    required this.amenities,
    required this.isAllInclusive,
    this.discount,
    this.originalPrice,
  });

  double get discountValue {
    if (discount == null || discount!.isEmpty) return 0.0;
    final cleanDiscount = discount!.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleanDiscount.isEmpty) return 0.0;
    return (double.tryParse(cleanDiscount) ?? 0.0) / 100;
  }
}

// EXAMPLE DATA (Search Result)
final HotelSearchResult mockHotelResult = HotelSearchResult(
  id: 'm1',
  name: 'Jaz Makadi Saraya Resort',
  address: 'Makadi Bay, Hurghada',
  rating: 4.8,
  pricePerNight: 180.0,
  imageUrl: 'https://picsum.photos/seed/jaz/800/600',
  amenities: ['Water Park', 'Family Friendly', 'All Inclusive'],
  isAllInclusive: true,
);

// ==========================================
// 3. HOTEL DETAILS
// ==========================================
class HotelDetails {
  final String id;
  final String name;
  final String address;
  final double rating;
  final double pricePerNight;
  final String imageUrl;
  final List<String> amenities;
  final String description;
  final List<String> photos;
  final bool isAllInclusive;
  final double? originalPrice;
  final String? discount;

  HotelDetails({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.pricePerNight,
    required this.imageUrl,
    required this.amenities,
    required this.description,
    required this.photos,
    required this.isAllInclusive,
    this.originalPrice,
    this.discount,
  });

  double get discountValue {
    if (discount == null || discount!.isEmpty) return 0.0;
    final cleanDiscount = discount!.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleanDiscount.isEmpty) return 0.0;
    return (double.tryParse(cleanDiscount) ?? 0.0) / 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'rating': rating,
      'pricePerNight': pricePerNight,
      'imageUrl': imageUrl,
      'amenities': amenities,
      'description': description,
      'photos': photos,
      'isAllInclusive': isAllInclusive,
      'originalPrice': originalPrice,
      'discount': discount,
    };
  }

  factory HotelDetails.fromMap(Map<String, dynamic> map) {
    return HotelDetails(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      pricePerNight: (map['pricePerNight'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
      description: map['description'] ?? '',
      photos: List<String>.from(map['photos'] ?? []),
      isAllInclusive: map['isAllInclusive'] ?? false,
      originalPrice: map['originalPrice']?.toDouble(),
      discount: map['discount'],
    );
  }
}

// ==========================================
// 2. ROOM
// ==========================================
class Room {
  final String id;
  final String hotelId;
  final String name;
  final String type;
  final String bedConfiguration;
  final double price;
  final int capacity;
  final List<String> amenities;
  final List<String> photos;
  final double size;
  final String? view;
  final double? originalPrice;
  final int totalCount;

  Room({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.type,
    required this.bedConfiguration,
    required this.price,
    required this.capacity,
    required this.amenities,
    required this.photos,
    required this.size,
    required this.view,
    this.originalPrice,
    this.totalCount = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hotelId': hotelId,
      'name': name,
      'type': type,
      'bedConfiguration': bedConfiguration,
      'price': price,
      'capacity': capacity,
      'amenities': amenities,
      'photos': photos,
      'size': size,
      'view': view,
      'originalPrice': originalPrice,
      'totalCount': totalCount,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? '',
      hotelId: map['hotelId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      bedConfiguration: map['bedConfiguration'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      capacity: map['capacity'] ?? 0,
      amenities: List<String>.from(map['amenities'] ?? []),
      photos: List<String>.from(map['photos'] ?? []),
      size: (map['size'] ?? 0.0).toDouble(),
      view: map['view'],
      originalPrice: map['originalPrice']?.toDouble(),
      totalCount: (map['totalCount'] as num?)?.toInt() ?? 1,
    );
  }
}

// ==========================================
// 3. HOTEL OFFER
// ==========================================
class HotelOffer {
  final String id;
  final String title;
  final String image;
  final String discount;
  final double price;
  final double? originalPrice;
  final double rating;
  final String location;
  final String distance;
  final List<String> amenities;
  final bool isAllInclusive;
  final String description;
  final Room room;
  final List<String> photos;

  HotelOffer({
    required this.id,
    required this.title,
    required this.image,
    required this.discount,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.location,
    required this.distance,
    required this.amenities,
    required this.isAllInclusive,
    required this.description,
    required this.room,
    required this.photos,
  });

  double get discountValue {
    if (discount.isEmpty) return 0.0;
    final cleanDiscount = discount.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleanDiscount.isEmpty) return 0.0;
    return (double.tryParse(cleanDiscount) ?? 0.0) / 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'discount': discount,
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'location': location,
      'distance': distance,
      'amenities': amenities,
      'isAllInclusive': isAllInclusive,
      'description': description,
      'room': room.toMap(),
      'photos': photos,
    };
  }

  factory HotelOffer.fromMap(Map<String, dynamic> map) {
    return HotelOffer(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      discount: map['discount'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      originalPrice: map['originalPrice']?.toDouble(),
      rating: (map['rating'] ?? 0.0).toDouble(),
      location: map['location'] ?? '',
      distance: map['distance'] ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
      isAllInclusive: map['isAllInclusive'] ?? false,
      description: map['description'] ?? '',
      room: Room.fromMap(map['room'] ?? {}),
      photos: List<String>.from(map['photos'] ?? []),
    );
  }
}
