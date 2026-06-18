import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';

/// One-time script to seed Firestore with data from static_data.md
class FirebaseSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedAll() async {
    print('Starting seeding process...');
    await seedHotelsAndRooms();
    await seedOffers();
    await seedActivities();
    print('Seeding complete!');
  }

  Future<void> seedHotelsAndRooms() async {
    final batch = _firestore.batch();

    // We'll use the data from static_data.md here.
    final hotels = [
      HotelDetails(
        id: 'g1',
        name: 'Sheraton Miramar Resort El Gouna',
        address: 'El Gouna, Red Sea',
        rating: 4.7,
        pricePerNight: 200.0,
        imageUrl: 'https://picsum.photos/seed/sheraton/800/600',
        amenities: [
          "Private Beach",
          "Pools",
          "Spa",
          "Water Sports",
          "Free WiFi",
          "Gym",
          "Kids Club",
          "Restaurants",
          "Bar",
          "Room Service",
        ],
        description:
            "Designed by Michael Graves, this resort offers a unique blend of Arabic and Nubian styles. Spread across nine islands, the resort features spacious rooms with stunning views of the lagoons and private beaches. Enjoy world-class dining, a relaxing spa, and endless water sports activities in the heart of El Gouna.",
        photos: [
          "https://picsum.photos/seed/sheraton1/800/600",
          "https://picsum.photos/seed/sheraton2/800/600",
          "https://picsum.photos/seed/sheraton3/800/600",
        ],
        isAllInclusive: false,
      ),
      HotelDetails(
        id: 'g2',
        name: 'Cook\'s Club El Gouna',
        address: 'Downtown, El Gouna',
        rating: 4.5,
        pricePerNight: 120.0,
        imageUrl: 'https://picsum.photos/seed/cooks/800/600',
        amenities: [
          "Adults Only",
          "DJ",
          "Pool",
          "Bar",
          "Free WiFi",
          "Yoga",
          "Beach Access",
          "Nightclub",
        ],
        description:
            "A trendy hotel for a new generation of travelers. Located in the heart of Downtown El Gouna, Cook's Club offers a vibrant atmosphere with a massive pool, live DJ sets, and a modern design. Perfect for those looking to relax by day and party by night, with easy access to the town's best nightlife.",
        photos: [
          "https://picsum.photos/seed/sheraton1/800/600",
          "https://picsum.photos/seed/sheraton2/800/600",
          "https://picsum.photos/seed/sheraton3/800/600",
        ],
        isAllInclusive: false,
      ),
      // ... Add other hotels from static_data.md as needed ...
    ];

    for (var hotel in hotels) {
      final hotelRef = _firestore.collection('hotels').doc(hotel.id);
      batch.set(hotelRef, hotel.toMap());

      // Add Dummy Rooms for each hotel
      final roomsRef = hotelRef.collection('rooms');

      // Example Room 1
      final room1 = Room(
        id: '${hotel.id}-r1',
        hotelId: hotel.id,
        name: 'Standard Room',
        type: 'Double',
        price: hotel.pricePerNight,
        capacity: 2,
        amenities: ['WiFi', 'AC', 'TV'],
        photos: ['https://picsum.photos/seed/${hotel.id}-r1/800/600'],
        size: 30.0,
        view: 'Garden View',
        bedConfiguration: '1 King Bed',
      );
      batch.set(roomsRef.doc(room1.id), room1.toMap());

      // Example Room 2
      final room2 = Room(
        id: '${hotel.id}-r2',
        hotelId: hotel.id,
        name: 'Deluxe Room',
        type: 'Suite',
        price: hotel.pricePerNight * 1.5,
        capacity: 3,
        amenities: ['WiFi', 'AC', 'TV', 'Balcony', 'Sea View'],
        photos: ['https://picsum.photos/seed/${hotel.id}-r2/800/600'],
        size: 50.0,
        view: 'Sea View',
        bedConfiguration: '1 King Bed + 1 Sofa Bed',
      );
      batch.set(roomsRef.doc(room2.id), room2.toMap());
    }

    await batch.commit();
    print('seeded ${hotels.length} hotels.');
  }

  Future<void> seedOffers() async {
    final batch = _firestore.batch();

    final offers = [
      HotelOffer(
        id: "rixos",
        title: "Rixos Premium Magawish",
        image: "https://picsum.photos/seed/rixos_offer/800/600",
        discount: "35% OFF",
        price: 4648.0, // Fixed: Double
        originalPrice: 7151.0, // Fixed: Double
        rating: 4.9,
        location: "Hurghada, Egypt",
        distance: "9.2 km from downtown",
        amenities: [
          "Private Beach",
          "Luxury Spa",
          "Fine Dining",
          "Horse Riding",
        ],
        isAllInclusive: true,
        description:
            "Experience world-class service at Rixos Premium Magawish Suites and Villas.",
        photos: [
          "https://picsum.photos/seed/rixos_offer/800/600",
          "https://picsum.photos/seed/rixos1/800/600",
        ],
        room: Room(
          id: 'rixos-r1',
          hotelId: 'rixos',
          name: "Suite with Balcony", // Mapped from roomType
          type: 'Suite',
          bedConfiguration: "2 full beds", // Mapped from bedInfo
          price: 4648.0,
          capacity: 2,
          amenities: ["Private Beach", "Luxury Spa"],
          photos: ["https://picsum.photos/seed/rixos_offer/800/600"],
          size: 60.0,
          view: 'Sea View',
        ),
      ),
      HotelOffer(
        id: "aldau",
        title: "Steigenberger ALDAU Beach",
        image: "https://picsum.photos/seed/aldau_offer/800/600",
        discount: "30% OFF",
        price: 3500.0,
        originalPrice: 5000.0,
        rating: 4.8,
        location: "Al Mamsha, Hurghada",
        distance: "5 km from downtown",
        amenities: ["Golf Course", "Water Park", "Dive Center", "Kids Club"],
        isAllInclusive: true,
        description: "Exclusive 5-star beach hotel with a golf course.",
        photos: ["https://picsum.photos/seed/aldau_offer/800/600"],
        room: Room(
          id: 'aldau-r1',
          hotelId: 'aldau',
          name: "Deluxe Sea View",
          type: 'Double',
          bedConfiguration: "1 King Bed",
          price: 3500.0,
          capacity: 2,
          amenities: ["Sea View", "Balcony"],
          photos: ["https://picsum.photos/seed/aldau_offer/800/600"],
          size: 45.0,
          view: 'Sea View',
        ),
      ),
      // ... add others
    ];

    for (var offer in offers) {
      final ref = _firestore.collection('offers').doc(offer.id);
      batch.set(ref, offer.toMap());
    }

    await batch.commit();
    print('seeded ${offers.length} offers.');
  }

  Future<void> seedActivities() async {
    final batch = _firestore.batch();
    
    final activitiesData = [
      {
        'id': 'a1',
        'title': 'Giftun Island Snorkeling Trip',
        'description': 'Enjoy a fantastic full-day trip to Giftun Island. Snorkel in the Red Sea and relax on the sandy beaches.',
        'price': 45.0,
        'location': 'Giftun Island, Hurghada',
        'duration': '8 hours',
        'rating': 4.8,
        'images': [
          'https://picsum.photos/seed/giftun1/800/600',
          'https://picsum.photos/seed/giftun2/800/600',
        ],
        'category': 'Water Sports',
        'availableDates': [
          DateTime.now().toIso8601String(),
          DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        ],
        'ageRequirement': 'All Ages',
        'pickupIncluded': true,
        'languages': ['English', 'Arabic', 'Russian'],
        'instantConfirmation': true,
        'freeCancellation': true,
        'fullDescription': 'Explore the magical underwater world of the Red Sea on this full-day boat trip to Giftun Island...',
        'whatsIncluded': ['Hotel pickup/drop-off', 'Snorkeling equipment', 'Lunch', 'Guide'],
        'whatsNotIncluded': ['Personal expenses', 'Gratuities'],
      },
      {
        'id': 'a2',
        'title': 'Desert Safari by Quad Bike',
        'description': 'Experience the thrill of driving a quad bike through the Sahara desert. Visit a Bedouin village and ride a camel.',
        'price': 35.0,
        'location': 'Hurghada Desert',
        'duration': '5 hours',
        'rating': 4.6,
        'images': [
          'https://picsum.photos/seed/safari1/800/600',
        ],
        'category': 'Desert Safari',
        'availableDates': [
          DateTime.now().toIso8601String(),
          DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        ],
        'ageRequirement': '16+',
        'pickupIncluded': true,
        'languages': ['English', 'German'],
        'instantConfirmation': true,
        'freeCancellation': false,
        'fullDescription': 'Strap in and ride a quad bike across the golden dunes of the Sahara...',
        'whatsIncluded': ['Quad bike', 'Guide', 'Tea at Bedouin village'],
        'whatsNotIncluded': ['Scarf', 'Goggles'],
      },
      {
        'id': 'a3',
        'title': 'Luxor Full-Day Tour',
        'description': 'Discover the ancient wonders of Luxor, including the Valley of the Kings, Karnak Temple, and Hatshepsut Temple.',
        'price': 95.0,
        'location': 'Luxor (from Hurghada)',
        'duration': '16 hours',
        'rating': 4.9,
        'images': [
          'https://picsum.photos/seed/luxor1/800/600',
          'https://picsum.photos/seed/luxor2/800/600',
        ],
        'category': 'Cultural Tours',
        'availableDates': [
          DateTime.now().add(const Duration(days: 3)).toIso8601String(),
          DateTime.now().add(const Duration(days: 5)).toIso8601String(),
        ],
        'ageRequirement': 'All Ages',
        'pickupIncluded': true,
        'languages': ['English', 'French', 'Spanish', 'Italian'],
        'instantConfirmation': false,
        'freeCancellation': true,
        'fullDescription': 'Step back in time to Ancient Egypt on this full-day tour from Hurghada to Luxor...',
        'whatsIncluded': ['Transport', 'Egyptologist Guide', 'Entrance fees', 'Lunch'],
        'whatsNotIncluded': ['Drinks', 'Tips (optional)'],
      }
    ];

    for (var act in activitiesData) {
      final ref = _firestore.collection('activities').doc(act['id'] as String);
      batch.set(ref, act);
    }
    
    await batch.commit();
    print('seeded ${activitiesData.length} activities.');
  }
}
