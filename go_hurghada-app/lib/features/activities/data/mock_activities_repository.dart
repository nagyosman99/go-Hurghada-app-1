import 'package:go_hurghada/features/activities/domain/repository/activities_repository.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity_booking.dart';

class MockActivitiesRepository implements ActivitiesRepository {
  final List<Activity> _activities = [
    Activity(
      id: 'a1',
      title: 'Giftun Island Snorkeling Trip',
      description: 'Enjoy a fantastic full-day trip to Giftun Island. Snorkel in the Red Sea and relax on the sandy beaches.',
      price: 45.0,
      location: 'Giftun Island, Hurghada',
      duration: '8 hours',
      rating: 4.8,
      images: [
        'assets/diving.jpg',
      ],
      category: 'Water Sports',
      availableDates: [
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
        DateTime.now().add(const Duration(days: 2)),
      ],
      ageRequirement: 'All Ages',
      pickupIncluded: true,
      languages: const ['English', 'Arabic', 'Russian'],
      instantConfirmation: true,
      freeCancellation: true,
      fullDescription: 'Explore the magical underwater world of the Red Sea on this full-day boat trip to Giftun Island...',
      whatsIncluded: const ['Hotel pickup/drop-off', 'Snorkeling equipment', 'Lunch', 'Guide'],
      whatsNotIncluded: const ['Personal expenses', 'Gratuities'],
    ),
    Activity(
      id: 'a2',
      title: 'Desert Safari by Quad Bike',
      description: 'Experience the thrill of driving a quad bike through the Sahara desert. Visit a Bedouin village and ride a camel.',
      price: 35.0,
      location: 'Hurghada Desert',
      duration: '5 hours',
      rating: 4.6,
      images: [
        'assets/safari.jpg',
      ],
      category: 'Safari',
      availableDates: [
        DateTime.now(),
        DateTime.now().add(const Duration(days: 2)),
      ],
      ageRequirement: '16+',
      pickupIncluded: true,
      languages: const ['English', 'German'],
      instantConfirmation: true,
      freeCancellation: false,
      fullDescription: 'Strap in and ride a quad bike across the golden dunes of the Sahara...',
      whatsIncluded: const ['Quad bike', 'Guide', 'Tea at Bedouin village'],
      whatsNotIncluded: const ['Scarf', 'Goggles'],
    ),
    Activity(
      id: 'a3',
      title: 'Luxor Full-Day Tour',
      description: 'Discover the ancient wonders of Luxor, including the Valley of the Kings, Karnak Temple, and Hatshepsut Temple.',
      price: 95.0,
      location: 'Luxor (from Hurghada)',
      duration: '16 hours',
      rating: 4.9,
      images: [
        'assets/egypt.jpg',
      ],
      category: 'Family',
      availableDates: [
        DateTime.now().add(const Duration(days: 3)),
        DateTime.now().add(const Duration(days: 5)),
      ],
      ageRequirement: 'All Ages',
      pickupIncluded: true,
      languages: const ['English', 'French', 'Spanish', 'Italian'],
      instantConfirmation: false,
      freeCancellation: true,
      fullDescription: 'Step back in time to Ancient Egypt on this full-day tour from Hurghada to Luxor...',
      whatsIncluded: const ['Transport', 'Egyptologist Guide', 'Entrance fees', 'Lunch'],
      whatsNotIncluded: const ['Drinks', 'Tips (optional)'],
    ),
    Activity(
      id: 'a4',
      title: 'Diving in the Red Sea',
      description: 'Experience world-class diving in the crystal clear waters of the Red Sea. Perfect for beginners and advanced divers.',
      price: 60.0,
      location: 'Hurghada Marina',
      duration: '6 hours',
      rating: 4.7,
      images: [
        'assets/diving.jpg',
      ],
      category: 'Water Sports',
      availableDates: [
        DateTime.now().add(const Duration(days: 1)),
        DateTime.now().add(const Duration(days: 3)),
      ],
      ageRequirement: '12+',
      pickupIncluded: true,
      languages: const ['English', 'German', 'Russian'],
      instantConfirmation: true,
      freeCancellation: true,
      fullDescription: 'Join our professional PADI certified instructors for an unforgettable diving experience...',
      whatsIncluded: const ['Diving equipment', 'Lunch on board', 'Instructor', '2 Dives'],
      whatsNotIncluded: const ['Underwater photos', 'Tips'],
    ),
    Activity(
      id: 'a5',
      title: 'Private Boat Charter',
      description: 'Rent a private yacht for you and your family. Enjoy a customized itinerary, snorkeling, and fishing.',
      price: 350.0,
      location: 'Hurghada Marina',
      duration: '8 hours',
      rating: 5.0,
      images: [
        'https://picsum.photos/seed/yacht1/800/600',
      ],
      category: 'Boat Trips',
      availableDates: [
        DateTime.now().add(const Duration(days: 2)),
        DateTime.now().add(const Duration(days: 4)),
      ],
      ageRequirement: 'All Ages',
      pickupIncluded: true,
      languages: const ['English', 'Arabic'],
      instantConfirmation: false,
      freeCancellation: true,
      fullDescription: 'Spend a luxurious day on the Red Sea with a private boat charter. Create your own itinerary...',
      whatsIncluded: const ['Private Yacht', 'Crew', 'Lunch & Drinks', 'Snorkeling Gear'],
      whatsNotIncluded: const ['Gratuities'],
    ),
    Activity(
      id: 'a6',
      title: 'Dolphin Swim & Snorkeling',
      description: 'Embark on a boat trip to the Dolphin House, where you can swim with wild dolphins in their natural habitat.',
      price: 40.0,
      location: 'Dolphin House, Hurghada',
      duration: '7 hours',
      rating: 4.5,
      images: [
        'https://picsum.photos/seed/dolphin1/800/600',
      ],
      category: 'Family',
      availableDates: [
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
      ],
      ageRequirement: 'All Ages',
      pickupIncluded: true,
      languages: const ['English', 'Russian'],
      instantConfirmation: true,
      freeCancellation: false,
      fullDescription: 'Interact with playful dolphins at the famous Dolphin House reef...',
      whatsIncluded: const ['Boat trip', 'Guide', 'Lunch'],
      whatsNotIncluded: const ['Photos'],
    ),
  ];

  @override
  Future<List<Activity>> getAllActivities() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _activities;
  }

  @override
  Future<List<Activity>> getActivitiesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _activities.where((a) => a.category == category).toList();
  }

  @override
  Future<List<Activity>> searchActivities(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final lowerQuery = query.toLowerCase();
    return _activities
        .where((a) => a.title.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<ActivityBooking> createBooking({
    required ActivityBooking booking,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    String? pickupLocation,
    required String activityName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return booking.copyWith(bookingId: 'mock_booking_${DateTime.now().millisecondsSinceEpoch}');
  }
}
