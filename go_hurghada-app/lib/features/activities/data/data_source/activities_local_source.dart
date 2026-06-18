import 'package:go_hurghada/features/activities/data/models/activity_model.dart';
import 'package:go_hurghada/features/activities/data/models/pickup_info_model.dart';

class ActivitiesLocalSource {
  Future<List<ActivityModel>> getActivities() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      ActivityModel(
        id: '1',
        title: 'Dolphin House Snorkeling',
        description:
            'Experience an unforgettable trip with two long snorkeling stops in the Red Sea.',
        fullDescription:
            'Embark on an extraordinary journey to the Dolphin House, one of the Red Sea\'s most spectacular snorkeling destinations. This full-day adventure offers you the unique opportunity to swim alongside wild dolphins in their natural habitat, surrounded by crystal-clear turquoise waters.\n\nYour day begins with a comfortable boat ride to the renowned Dolphin House reef, where you\'ll enjoy two extended snorkeling sessions. Dive into the vibrant underwater world and discover colorful coral gardens teeming with exotic fish, sea turtles, and if you\'re lucky, playful dolphins. Our experienced guides will ensure your safety while helping you make the most of this once-in-a-lifetime experience.\n\nBetween snorkeling sessions, relax on board with a delicious lunch buffet featuring fresh local cuisine. All snorkeling equipment is provided, and our professional instructors are available to assist beginners. This tour is perfect for families, couples, and solo travelers seeking an authentic Red Sea adventure.',
        price: 35.0,
        location: 'Hurghada Marina',
        duration: '7 hours',
        rating: 4.8,
        images: ['assets/diving.jpg', 'assets/water_sports.jpg'],
        category: 'Water Sports',
        availableDates: _generateDates(),
        ageRequirement: '5+',
        pickupIncluded: true,
        languages: ['English', 'Arabic', 'German', 'Russian'],
        instantConfirmation: true,
        freeCancellation: true,
        whatsIncluded: [
          'Hotel pickup and drop-off',
          'Professional snorkeling guide',
          'All snorkeling equipment (mask, fins, life jacket)',
          'Lunch buffet on board',
          'Soft drinks and water',
          'Two snorkeling stops (45 minutes each)',
        ],
        whatsNotIncluded: [
          'Underwater camera rental (\$15)',
          'Wetsuit rental (\$5)',
          'Personal expenses',
          'Tips and gratuities',
        ],
        pickupInfo: const PickupInfoModel(
          timeWindow: '7:00 AM - 8:30 AM',
          locations: [
            'All hotels in Hurghada',
            'Makadi Bay',
            'Sahl Hasheesh',
            'El Gouna (+\$5)',
          ],
          contactMethod: 'WhatsApp',
          contactTiming: '24 hours before the trip',
        ),
      ),
      ActivityModel(
        id: '2',
        title: 'Desert Safari Adventure',
        description:
            'Explore the Hurghada desert by quad bike. Visit a Bedouin village and watch the sunset.',
        fullDescription:
            'Experience the thrill of the Egyptian desert on this action-packed safari adventure. Feel the adrenaline rush as you ride a powerful quad bike across the golden sand dunes, exploring the vast and beautiful desert landscape that surrounds Hurghada.\n\nYour adventure includes a visit to an authentic Bedouin village, where you\'ll gain insight into the traditional nomadic lifestyle. Enjoy warm Bedouin hospitality with traditional tea, learn about their customs and culture, and take a peaceful camel ride through the desert. As the day draws to a close, witness one of nature\'s most spectacular shows – a breathtaking sunset over the desert mountains, painting the sky in brilliant shades of orange and pink.\n\nThis tour combines adventure, culture, and natural beauty, making it perfect for thrill-seekers and culture enthusiasts alike. No previous quad biking experience is necessary – our expert guides will provide full safety instructions and accompany you throughout the journey.',
        price: 45.0,
        location: 'Hurghada Desert',
        duration: '5 hours',
        rating: 4.7,
        images: ['assets/safari.jpg'],
        category: 'Safari',
        availableDates: _generateDates(),
        ageRequirement: '12+',
        pickupIncluded: true,
        languages: ['English', 'Arabic', 'German'],
        instantConfirmation: true,
        freeCancellation: true,
        whatsIncluded: [
          'Hotel pickup and drop-off',
          'Quad bike rental (single or double)',
          'Safety equipment (helmet, goggles)',
          'Professional safari guide',
          'Bedouin village visit',
          'Camel ride',
          'Bedouin tea',
          'Bottled water',
        ],
        whatsNotIncluded: [
          'Scarf and goggles (\$3)',
          'Photos and videos',
          'Personal expenses',
          'Tips and gratuities',
        ],
        pickupInfo: const PickupInfoModel(
          timeWindow: '1:00 PM - 2:30 PM',
          locations: ['All hotels in Hurghada', 'Makadi Bay', 'Sahl Hasheesh'],
          contactMethod: 'WhatsApp',
          contactTiming: '24 hours before the trip',
        ),
      ),
      ActivityModel(
        id: '3',
        title: 'Giftun Island Boat Trip',
        description:
            'Relax on the white sandy beaches of Giftun Island. Enjoy swimming and snorkeling.',
        fullDescription:
            'Escape to paradise with a full-day excursion to Giftun Island, a protected national park and one of the Red Sea\'s most pristine destinations. This idyllic island boasts powdery white sand beaches, crystal-clear turquoise waters, and some of the most spectacular coral reefs in the region.\n\nYour journey begins with a scenic boat ride across the sparkling Red Sea. Upon arrival, you\'ll have the freedom to choose your own adventure – relax on the pristine beach, swim in the warm, inviting waters, or explore the vibrant underwater world with provided snorkeling equipment. The island\'s protected reefs are home to an incredible diversity of marine life, including colorful tropical fish, graceful rays, and occasionally sea turtles.\n\nThroughout the day, enjoy a delicious buffet lunch served on board, featuring a variety of fresh salads, grilled meats, and traditional Egyptian dishes. Soft drinks and water are available throughout the trip. This tour is perfect for families, couples, and anyone seeking a peaceful day in one of Egypt\'s most beautiful natural settings.',
        price: 40.0,
        location: 'Giftun Island',
        duration: '8 hours',
        rating: 4.9,
        images: ['assets/Sahl_hasheesh.jpg', 'assets/makadi.jpg'],
        category: 'Boat Trips',
        availableDates: _generateDates(),
        ageRequirement: 'All ages',
        pickupIncluded: true,
        languages: ['English', 'Arabic', 'German', 'Italian'],
        instantConfirmation: true,
        freeCancellation: true,
        whatsIncluded: [
          'Hotel pickup and drop-off',
          'Boat transfer to Giftun Island',
          'Snorkeling equipment',
          'Life jackets',
          'Lunch buffet on board',
          'Soft drinks and water',
          'Professional tour guide',
          'National park fees',
        ],
        whatsNotIncluded: [
          'Underwater camera rental (\$10)',
          'Beach umbrella rental (\$5)',
          'Personal expenses',
          'Tips and gratuities',
        ],
        pickupInfo: const PickupInfoModel(
          timeWindow: '8:00 AM - 9:00 AM',
          locations: [
            'All hotels in Hurghada',
            'Makadi Bay',
            'Sahl Hasheesh',
            'El Gouna (+\$10)',
          ],
          contactMethod: 'WhatsApp',
          contactTiming: '24 hours before the trip',
        ),
      ),
      ActivityModel(
        id: '4',
        title: 'Sindbad Submarine Tour',
        description:
            'Discover the underwater world of the Red Sea without getting wet in a real submarine.',
        fullDescription:
            'Dive into the depths of the Red Sea without getting wet on this unique submarine adventure. The Sindbad Submarine offers a comfortable, air-conditioned journey 22 meters below the surface, providing an extraordinary window into the vibrant underwater world that makes the Red Sea famous worldwide.\n\nThis family-friendly experience is perfect for all ages, including young children and those who cannot swim. Through large panoramic windows, you\'ll observe colorful coral reefs, exotic fish species, and the fascinating marine ecosystem of the Red Sea. The submarine\'s expert crew provides informative commentary about the marine life and coral formations you\'ll encounter during your 50-minute underwater journey.\n\nUnlike traditional snorkeling or diving, the submarine tour allows you to stay completely dry while exploring depths that would otherwise require scuba certification. It\'s an ideal choice for families with young children, elderly travelers, or anyone who wants to experience the Red Sea\'s underwater wonders in comfort and safety.',
        price: 55.0,
        location: 'Sindbad Hotel',
        duration: '3 hours',
        rating: 4.6,
        images: ['assets/water_sports.jpg'],
        category: 'Family',
        availableDates: _generateDates(),
        ageRequirement: 'All ages',
        pickupIncluded: false,
        languages: ['English', 'Arabic', 'German', 'French'],
        instantConfirmation: true,
        freeCancellation: false,
        whatsIncluded: [
          '50-minute submarine dive',
          'Professional crew and guide',
          'Safety briefing',
          'Soft drinks on board',
          'Certificate of participation',
        ],
        whatsNotIncluded: [
          'Hotel pickup and drop-off',
          'Photos and videos (\$20)',
          'Personal expenses',
          'Tips and gratuities',
        ],
      ),
      ActivityModel(
        id: '5',
        title: 'Luxury Yacht Private Trip',
        description:
            'Rent a private yacht for your family or friends. Customize your itinerary and enjoy a private chef.',
        fullDescription:
            'Indulge in the ultimate Red Sea experience with a private luxury yacht charter. This exclusive tour offers you and your group complete privacy and flexibility to create your perfect day on the water. Whether you\'re celebrating a special occasion or simply want to enjoy the Red Sea in style, this premium experience delivers unforgettable memories.\n\nYour private yacht comes fully equipped with modern amenities, comfortable seating areas, sun decks, and shaded lounging spaces. A professional captain and crew will navigate to your chosen destinations, which can include pristine snorkeling spots, secluded beaches, or simply cruising along the stunning coastline. All snorkeling equipment is provided, and our crew can assist with water activities.\n\nWhat truly sets this experience apart is the personalized service. Your private chef will prepare a customized menu based on your preferences, serving fresh, delicious meals throughout the day. Enjoy unlimited soft drinks, fresh juices, and bottled water. You can also arrange for fishing equipment, water sports, or special celebrations. This is luxury travel at its finest – tailored entirely to your desires.',
        price: 350.0,
        location: 'Hurghada Marina',
        duration: 'Full Day',
        rating: 5.0,
        images: ['assets/makadi.jpg', 'assets/Sahl_hasheesh.jpg'],
        category: 'Luxury',
        availableDates: _generateDates(),
        ageRequirement: 'All ages',
        pickupIncluded: true,
        languages: ['English', 'Arabic', 'German', 'French', 'Italian'],
        instantConfirmation: false,
        freeCancellation: true,
        whatsIncluded: [
          'Private luxury yacht rental',
          'Professional captain and crew',
          'Private chef and customized menu',
          'Unlimited soft drinks and water',
          'Fresh fruit platter',
          'Snorkeling equipment',
          'Fishing equipment',
          'Hotel pickup and drop-off',
          'Fuel and marina fees',
        ],
        whatsNotIncluded: [
          'Alcoholic beverages (can be arranged)',
          'Special decorations for celebrations (+\$50)',
          'Jet ski rental (+\$100)',
          'Tips and gratuities',
        ],
        pickupInfo: const PickupInfoModel(
          timeWindow: 'Flexible (9:00 AM - 10:00 AM recommended)',
          locations: [
            'All hotels in Hurghada',
            'Makadi Bay',
            'Sahl Hasheesh',
            'El Gouna',
            'Soma Bay',
          ],
          contactMethod: 'WhatsApp',
          contactTiming: '48 hours before the trip',
        ),
      ),
    ];
  }

  List<DateTime> _generateDates() {
    final now = DateTime.now();
    return List.generate(30, (index) => now.add(Duration(days: index)));
  }
}
