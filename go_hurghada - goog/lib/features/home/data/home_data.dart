import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/flight/presentation/screens/chose_flight.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/activities/presentation/pages/activities_list_page.dart';
import 'package:go_hurghada/features/hotel/presentation/screens/hotel_search_screen.dart';

class HomeData {
  static final List<CategoryModel> categories = [
    CategoryModel(
      id: '1',
      name: 'Flight',
      imagePath: 'assets/flight.png',
      backgroundColor: AppColors.categoryFlight,
      page: ChoseFlight(),
    ),
    CategoryModel(
      id: '2',
      name: 'Hotel',
      imagePath: 'assets/hotel.png',
      backgroundColor: AppColors.categoryHotel,
      page: const HotelSearchScreen(),
    ),
    CategoryModel(
      id: '3',
      name: 'Activities',
      imagePath: 'assets/tour.png',
      backgroundColor: AppColors.categoryTour,
      page: const ActivitiesListPage(),
    ),
  ];

  static final List<LocationModel> locations = [
    LocationModel(id: '1', name: 'El Gouna', image: 'assets/Elgouna.jpg'),
    LocationModel(id: '2', name: 'Makadi Bay', image: 'assets/makadi.jpg'),
    LocationModel(id: '3', name: 'Soma Bay', image: 'assets/soma_bay.jpg'),
    LocationModel(
      id: '4',
      name: 'Sahl Hasheesh',
      image: 'assets/Sahl_hasheesh.jpg',
    ),
  ];

  static final List<OfferCardModel> offers = [
    OfferCardModel(
      id: 'rixos',
      hotelName: 'Rixos Premium Magawish',
      image:
          'https://cf.bstatic.com/xdata/images/hotel/max300/766167756.jpg?k=5bb648fa534f0cb8482df8898b048bdc081d223cd6abd39a3c2517ac87d7441e&o=',
      discount: '35% Winter Special',
      price: 292.5,
      originalPrice: 450.0,
      rating: 4.9,
      location: 'Hurghada, Egypt',
      distance: '9.2 km from downtown',
      amenities: [
        'Ultra All Inclusive',
        'Private Cabanas',
        'Fine Dining',
        'Horse Riding',
      ],
      isAllInclusive: true,
    ),
    OfferCardModel(
      id: 'aldau',
      hotelName: 'Steigenberger ALDAU Beach',
      image:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/600323138.jpg?k=57d5a4ac95831b0befbff231dd1bf35c49ad783007e265611043012374106ee5&o=',
      discount: 'Early Bird 20%',
      price: 196.0,
      originalPrice: 245.0,
      rating: 4.8,
      location: 'Al Mamsha, Hurghada',
      distance: '5 km from downtown',
      amenities: ['Lazy River', 'Golf Access', 'Diving Center', 'Kids Club'],
      isAllInclusive: true,
    ),
    OfferCardModel(
      id: 'jaz_casa',
      hotelName: 'Jaz Casa Del Mar Beach',
      image:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/279635705.jpg?k=56e25cc19b4c5784b3af5001b02694bc33e5147c40886228974be14a0e07f4c1&o=',
      discount: 'Honeymoon 15% Package',
      price: 161.5,
      originalPrice: 190.0,
      rating: 4.7,
      location: 'Al Mamsha, Hurghada',
      distance: '4 km from downtown',
      amenities: ['VIP Breakfast', 'Spa Credits', 'Airport Transfer'],
      isAllInclusive: true,
    ),
    OfferCardModel(
      id: 'm2',
      hotelName: 'Sunrise Royal Makadi Resort',
      image:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/250924535.jpg?k=bcf3c5e26daa5d18244bfd10ba1d55f4be6ba15ab53e5425ffbedad27645c974&o=',
      discount: 'Family Fun 15%',
      price: 136.0,
      originalPrice: 160.0,
      rating: 4.6,
      location: 'Makadi Bay, Hurghada',
      distance: '30 km from downtown',
      amenities: ['Aqua Park', 'Kids Club', 'Multiple Pools'],
      isAllInclusive: true,
    ),
  ];

  static final List<ActivityModel> activities = [
    ActivityModel(
      id: 'a1',
      name: 'Snorkeling Trip',
      image: 'assets/water_sports.jpg',
      description: 'Explore the Giftun Island coral reefs',
    ),
    ActivityModel(
      id: 'a2',
      name: 'Desert Safari',
      image: 'assets/safari.jpg',
      description: 'Experience the thrill of the Sahara',
    ),
    ActivityModel(
      id: 'a3',
      name: 'Luxor Full-Day',
      image: 'assets/egypt.jpg',
      description: 'Step back into Ancient Egypt',
    ),
    ActivityModel(
      id: 'a4',
      name: 'Scuba Diving',
      image: 'assets/diving.jpg',
      description: 'Experience world-class diving',
    ),
  ];
}
