import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';

/// Abstract repository interface for hotel operations
abstract class HotelRepository {
  /// Search for hotels based on query and booking parameters
  /// Returns a lightweight list of hotels (HotelSearchResult)
  Future<List<HotelSearchResult>> searchHotels(
    String query, {
    DateTime? checkIn,
    DateTime? checkOut,
    int rooms = 1,
    int adults = 1,
    int children = 0,
  });

  /// Get a specific hotel by its ID with full details
  Future<HotelDetails?> getHotelById(String id);

  /// Get a specific offer by its ID with full details
  Future<HotelOffer?> getOfferById(String id);

  /// Get all available rooms for a specific hotel
  Future<List<Room>> getRoomsForHotel(String hotelId);
}

/// Mock implementation of HotelRepository for development and testing
/// Mock implementation of [HotelRepository] for development and testing.
class MockHotelRepository implements HotelRepository {
  // We store the full details internally as the source of truth
  final List<HotelDetails> _mockHotels = [
    // El Gouna
    HotelDetails(
      id: 'g1',
      name: 'Sheraton Miramar Resort El Gouna',
      address: 'El Gouna, Red Sea',
      rating: 4.8,
      pricePerNight: 170.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723785464.jpg?k=c1a5fe0cb40d1530cd97cfd8fda645251d8c223ca5fc0df25b83e05cdc82248d&o=',
      amenities: [
        'Private Beach',
        '3 Outdoor Pools',
        'Award-winning Spa',
        'Professional Diving Center',
        'Free Premium WiFi',
        'Fitness Center',
        'Sheraton Fitness',
        'Lagoon Boat Shuttles',
        'Kids Club',
        '6 Specialty Restaurants',
      ],
      description:
          'Located in the gated community of El Gouna, this 5-star resort is spread across nine islands. Designed by world-renowned architect Michael Graves, it features a unique blend of Arabic and Nubian styles. Enjoy direct lagoon and sea access, a secluded beach, and the vibrant atmosphere of the nearby Abu Tig Marina.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/723781126.jpg?k=4c66a3371f26c1457d2a84f538b0058a69b0e1337e85c9153e8e4612564f8f1b&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723785522.jpg?k=8f09c6c1c683ced89bace0624d465c4db38a569e383296f555ac8154bfcc72d4&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723785472.jpg?k=0082ad31196e18207ccc81a3794b384fd71e027fa154c394ab037987de1b5631&o=',
      ],
      isAllInclusive: false,
    ),
    HotelDetails(
      id: 'g2',
      name: 'Cook\'s Club El Gouna',
      address: 'Downtown, El Gouna',
      rating: 4.5,
      pricePerNight: 90.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723785441.jpg?k=1fcc91fdc8b7ed17db972235def1fc39d776183b0f6dd3388b24d5985bf838dc&o=',
      amenities: [
        'Adults Only (16+)',
        'Resident DJs',
        'Social Pool',
        'Cantina Restaurant',
        'Free High-speed WiFi',
        'Outdoor Crossfit',
        'Beach Club Access',
        'Street Food Concept',
      ],
      description:
          'A bohemian-style hotel designed for a new generation of travelers. Located in the heart of Downtown El Gouna, Cook\'s Club offers a stripped-back, laid-back luxury experience. With its centerpiece social pool, world-class cocktails, and fresh local street food, it\'s the ultimate hub for modern explorers.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723785470.jpg?k=21643dc1de45ddefdfab5961d22815813af211289e79d82f97baf7d4bbb06b74&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723785410.jpg?k=b9f4fe88a4e132ea4bb74ad3dc5b975a1d1dd97784d1e56211d73983e97ed31b&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723784643.jpg?k=021d03253b57711ef6f92308947252abc3c83f7b03c80d85ffa4864b93b3e49e&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723781145.jpg?k=46f9f88ed8d38704c076d74d1c5328cf75e3b23e2e785bddf6783cfd8d511c1e&o=',
      ],
      isAllInclusive: false,
      discount: '15% Exclusive Offer',
    ),

    // Makadi Bay
    HotelDetails(
      id: 'm1',
      name: 'Jaz Makadi Saraya Resort',
      address: 'Makadi Bay, Hurghada',
      rating: 4.8,
      pricePerNight: 145.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723855721.jpg?k=f930fe442a60f2fd706611abfe835ec8db2eeabddede09fd57b89cb71eb0b3d0&o=',
      amenities: [
        'Makadi Water World Access',
        'Family Friendly',
        'All Inclusive Plus',
        '5 Heated Pools',
        'Day & Night Animation',
        'Health Club & Spa',
        'Kitesurfing Center',
        '9 Specialty Restaurants',
      ],
      description:
          'A vibrant and family-focused resort in the heart of Madinat Makadi. Jaz Makadi Saraya Resort offers legendary hospitality with extensive facilities. Guests enjoy unlimited access to Makadi Water World, one of the region\'s largest water parks, along with a stunning private beach and a variety of international cuisines.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723855466.jpg?k=1db83fa6450ba312c865bbe06934deaac1629157c9c512c0573ea160fd394209&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723855314.jpg?k=f201f2489e50619e09a0bcd9ef373b5bb14057b7fcf71904f07f444c821f8d63&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/723855698.jpg?k=6e06e8c9700dd19ed02d4427483ff1ca03fdff9242a276ce5f2c1829ce368822&o=',
      ],
      isAllInclusive: true,
    ),
    HotelDetails(
      id: 'm2',
      name: 'Sunrise Royal Makadi Resort',
      address: 'Makadi Bay, Hurghada',
      rating: 4.6,
      pricePerNight: 135.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/250924535.jpg?k=bcf3c5e26daa5d18244bfd10ba1d55f4be6ba15ab53e5425ffbedad27645c974&o=',
      amenities: [
        'Splasworld Aqua Park',
        '7 Outdoor Pools',
        'Family Discovery Club',
        'Spa & Wellness Center',
        '8 A la Carte Restaurants',
        'PADI Diving Center',
        'Evening Shows',
      ],
      description:
          'Located in the heart of Makadi Bay, Sunrise Royal Makadi offers an extensive array of facilities for an unforgettable family vacation. With 7 swimming pools, a massive aqua park, and 8 themed restaurants, including Mexican and Mediterranean, there\'s something for everyone to enjoy.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max300/280550866.jpg?k=bcf35e970f0087f8b2c7d9c59a563427b0a18e7816f71399c5eddd45aa823c20&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max300/542683383.jpg?k=af18d1a81841d8180382e47ad89ad3189157474256f10598ee952df3d8bc855e&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/346706478.jpg?k=bfcc1b087e4dac00380d298ab46e0207e6fcfb47f47cda7d8994153b107c95e2&o=',
      ],
      isAllInclusive: true,
    ),

    // Soma Bay
    HotelDetails(
      id: 's1',
      name: 'Kempinski Hotel Soma Bay',
      address: 'Soma Bay, Hurghada',
      rating: 4.9,
      pricePerNight: 250.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/187734712.jpg?k=628e25ef83dc68c95254cdf1c87047cf2d9cc5b9ee7bbf7ad71b28e7808c7689&o=',
      amenities: [
        'Private 400m Sandy Beach',
        'Cascading Pool System',
        'Thalasso Spa',
        '18-Hole Championship Golf',
        '72-berth Marina',
        'Fine Dining Restaurants',
        'Luxury Limousine Service',
      ],
      description:
          'Experience European luxury on the shores of the Red Sea. Kempinski Hotel Soma Bay is a masterpiece of Moorish architecture, offering an exclusive resort experience. Featuring a unique cascading pool system, a lazy river, and one of the largest Thalasso centers in the region, it is the pinnacle of elegance in Soma Bay.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/187734689.jpg?k=d304e82c63c2eac5240a1b0dacb7bb16a98790be2fdc687b681321f2d105c64c&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max300/187734713.jpg?k=df3a3216943d07e0dead9b252e58a6a77ad8a23b0e2a819ccbdb1f05f82b5169&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/184889024.jpg?k=0c88ce1683634eaa122ea0fb75e648d1bc38d3a474c75ba81ffe34a2452deb3c&o=',
      ],
      isAllInclusive: false,
    ),

    // Sahl Hasheesh
    HotelDetails(
      id: 'sh1',
      name: 'Baron Palace Sahl Hasheesh',
      address: 'Sahl Hasheesh, Hurghada',
      rating: 4.8,
      pricePerNight: 310.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/728144631.jpg?k=807d51f7a31229e2f07eff2895a4e3b400aabead410c21a704d20adafb93f9ed&o=',
      amenities: [
        '6-Star Ultra Luxury',
        'Private Sandy Bay',
        'Infinity Olympic Pool',
        '7 International Restaurants',
        'Luxury Spa & Thalasso',
        'Roman Theater',
        'Exclusive Club Lounge',
      ],
      description:
          'A majestic Mediterranean palace overlooking the turquoise waters of Sahl Hasheesh. Baron Palace is synonymous with opulence, offering 6-star service and world-class facilities. From its hand-crafted marble floors to its sprawling infinity pools and award-winning dining, every detail is designed for pure indulgence.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/728144590.jpg?k=bff90ba2f753bdee9f7bedd77afb0e0c982039a82ed7162c35a80b3b7bff391b&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max500/728144566.jpg?k=4c322cb8807172301d69286fdc0341df08087ad4c2676ab1879ca7899e872f7b&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/732604089.jpg?k=3844f1c210ff2e8ca7e9471a526a50807572a0d4f3272a7c44814ba7823c2547&o=',
      ],
      isAllInclusive: true,
    ),

    // Hurghada City Center
    HotelDetails(
      id: 'h1',
      name: 'Meraki Resort',
      address: 'El Dahar, Hurghada City Center',
      rating: 4.4,
      pricePerNight: 125.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/633519990.jpg?k=55d998e7e4690342c5d32042eb5ae347139f388ac84cc2e0c1b32834396e6098&o=',
      amenities: [
        'Adults Only (16+)',
        'Bohemian Design',
        'Vibe-driven Atmosphere',
        'Private 2.6km Beach',
        'Resident & Guest DJs',
        'Trendy Bars & Eateries',
        'Functional Fitness Center',
      ],
      description:
          'Unleash your bohemian soul at Meraki Resort, the first clubbing resort in the Middle East. With its stunning industrial-meets-boho design and a massive private beach, Meraki offers an adults-only playground. From beach parties to chill-out lounges, experience a vibrant lifestyle that breaks away from traditional resort rules.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/633519995.jpg?k=aed629ba10cebb5ea2d58b1fcee7ba1ec1a320cdc0a5fac6cfea5a59ad1e5510&o=',
        'https://ak-d.tripcdn.com/images/022661200084ayq22C33D.jpg',
        'https://ak-d.tripcdn.com/images/022341200084ayr88B12A.jpg',
      ],
      isAllInclusive: true,
    ),
    HotelDetails(
      id: 'h2',
      name: 'Seagull Beach Resort',
      address: 'Sheraton Road, Hurghada City Center',
      rating: 4.2,
      pricePerNight: 65.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/566415220.jpg?k=0d53f35a1b44be805e73ca16056d797d9f94d5b91479a8281484f56caa7de45e&o=',
      amenities: [
        'Heart of City Center',
        '2 Private Beaches',
        '8 Outdoor Pools',
        'Aqua Park with 11 Slides',
        'Health Club & Spa',
        'Mini-Zoo for Kids',
        '7 Restaurants & Bars',
      ],
      description:
          'Situated in the bustling Sheraton Road area, Seagull Beach Resort is a Hurghada landmark. Known for its extensive family facilities, the resort offers two distinct private beaches, a vibrant aqua park, and prime access to the city\'s best shopping and dining experiences just steps from the entrance.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/638139927.jpg?k=5d44623b5538d156c795ef942dc7bb84d1df6a5aa8670f1112bfa2582852a7eb&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/631173449.jpg?k=f2155e05c541cb07749eb0bbf8a470ee227386bcdca2aa5f3b4931d74fd82715&o=',
      ],
      isAllInclusive: true,
    ),

    // Al Mamsha
    HotelDetails(
      id: 'am1',
      name: 'Steigenberger Aqua Magic',
      address: 'Al Mamsha, Hurghada',
      rating: 4.6,
      pricePerNight: 165.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max300/105932034.jpg?k=e020c59059a8f496df6f23c32c89eb1b0382e9233083e7b4126a1ad6e0464f10&o=',
      amenities: [
        'Premier Family Aqua Park',
        'Lazy River Feature',
        'Kids Clubhouse',
        'Planet Spa',
        'Direct Beach Access',
        '9 Dynamic Restaurants',
        '24-Hour All Inclusive',
      ],
      description:
          'Steigenberger Aqua Magic is Hurghada\'s premier destination for family fun. Located on the vibrant Al Mamsha promenade, it features a sprawling aqua park, a relaxing lazy river, and world-class hospitality. With dedicated kids\' facilities and a variety of dining options, it guarantees a magical vacation for all ages.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max300/253230270.jpg?k=f3a785fe118cc7779784c64f3c393088ffdb9ace4e0b7e00f153dedbbff6aa4e&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/253230280.jpg?k=c1e7c16f0866b8187fefecc746c0f8b4f761e5741d0dd9dfd346de221692460d&o=',
      ],
      isAllInclusive: true,
    ),
    // Rixos Premium Magawish
    HotelDetails(
      id: 'rixos',
      name: 'Rixos Premium Magawish',
      address: 'Hurghada, Egypt',
      rating: 4.9,
      pricePerNight: 335.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max300/766167756.jpg?k=5bb648fa534f0cb8482df8898b048bdc081d223cd6abd39a3c2517ac87d7441e&o=',
      amenities: [
        'Private Sandy Beach',
        'Anjana Spa',
        'Executive Cabanas',
        'Rixy Kids Club',
        'Horse Riding Center',
        'Ultra All Inclusive',
        '30 Swimming Pools',
        'Private Yacht Marina',
      ],
      description:
          'Experience ultra-all-inclusive luxury at Rixos Premium Magawish. This world-class resort is a haven for travelers seeking elegance and exclusivity. Featuring all-suite and villa accommodations, a private marina, and a professional equestrian club, it sets a new standard for hospitality in Hurghada.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/766167752.jpg?k=d4f44011b91b44bfe3d1c4c1bb0a4f4fe7ca84fb9b4635d4cba1905feb262152&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/763591592.jpg?k=8232ca818c80e1c2d693e06afaa6016949ea15b702a4d27ddc208647550bef9e&o=',
      ],
      isAllInclusive: true,
    ),
    // Steigenberger ALDAU Beach
    HotelDetails(
      id: 'aldau',
      name: 'Steigenberger ALDAU Beach',
      address: 'Al Mamsha, Hurghada',
      rating: 4.8,
      pricePerNight: 195.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/600323138.jpg?k=57d5a4ac95831b0befbff231dd1bf35c49ad783007e265611043012374106ee5&o=',
      amenities: [
        '9-Hole Executive Golf Course',
        'massive Lazy River',
        'PADI Gold Palm Diving Center',
        '5000 sq.m Spa & Wellness',
        'Family Friendly',
        'All Inclusive Plus',
      ],
      description:
          'A sanctuary of peace and luxury on the Al Mamsha promenade. Steigenberger ALDAU Beach Hotel is an award-winning resort that offers a perfect blend of style and substance. With its sprawling pools, private beach, and world-class golf course, it provides a sophisticated retreat for discerning families and couples.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max300/644636649.jpg?k=62d6f8421e47e8bcae95b8be18547c537104ade8d4cc183c60cf071b95c3c67c&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/105937871.jpg?k=84f93913257527ff5fba72db1a7713925bc1e21f922dee8428aa77247629d677&o=',
      ],
      isAllInclusive: true,
      originalPrice: 11875.0,
      discount: '20% OFF',
    ),
    // Jaz Casa Del Mar Beach
    HotelDetails(
      id: 'jaz_casa',
      name: 'Jaz Casa Del Mar Beach',
      address: 'Al Mamsha, Hurghada',
      rating: 4.7,
      pricePerNight: 160.0,
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/279635705.jpg?k=56e25cc19b4c5784b3af5001b02694bc33e5147c40886228974be14a0e07f4c1&o=',
      amenities: [
        'All Inclusive Plus',
        'Private Sandy Beach',
        'Adults-only Zone',
        'Kids Club & Playground',
        'Water Sports Center',
        'Steigenberger ALDAU Promenade Access',
      ],
      description:
          'Nestled on the famous Al Mamsha promenade, Jaz Casa Del Mar Beach offers a mix of modern luxury and tranquil beach vibes. With a newly renovated design, guests can enjoy premium all-inclusive benefits, multiple pools, and seamless access to the vibrant nightlife and shopping of Hurghada.',
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/279635760.jpg?k=2a393c1331ec17efe7f7c173c1aef9b8379bf58a8012974b0525eb2c52c02a2e&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/279635664.jpg?k=4f45cb99cfe2bd9c1b0b52de35d0b4060487d7edbccaf5843e1965d332273b74&o=',
      ],
      isAllInclusive: true,
    ),
  ];

  List<HotelOffer> get _mockOffers => _buildOffers();

  final List<_OfferConfig> _offerConfigs = [
    _OfferConfig(
      hotelId: 'rixos',
      roomId: 'rixos-r1',
      discount: '35% Winter Special',
      image: 'https://ak-d.tripcdn.com/images/022411200084ayz88B12A.jpg',
    ),
    _OfferConfig(
      hotelId: 'aldau',
      roomId: 'aldau-r1',
      discount: '20% Early Bird',
      image:
          'https://cf.bstatic.com/xdata/images/hotel/max300/600323138.jpg?k=57d5a4ac95831b0befbff231dd1bf35c49ad783007e265611043012374106ee5&o=',
    ),
    _OfferConfig(
      hotelId: 'jaz_casa',
      roomId: 'jaz_casa-r1',
      discount: '15% Honeymoon',
      image:
          'https://cf.bstatic.com/xdata/images/hotel/max300/279635705.jpg?k=56e25cc19b4c5784b3af5001b02694bc33e5147c40886228974be14a0e07f4c1&o=',
    ),
    _OfferConfig(
      hotelId: 'm2',
      roomId: 'm2-r1',
      discount: '15% Family Fun',
      image:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/280550823.jpg?k=c6fdcff88e1480e56428cd6eda5460aa98b811867b65dee8fba327fca57df268&o=',
    ),
  ];

  List<HotelOffer> _buildOffers() {
    return _offerConfigs.map((config) {
      final hotel = _mockHotels.firstWhere((h) => h.id == config.hotelId);
      final room = _mockRooms.firstWhere((r) => r.id == config.roomId);

      // Parse discount
      double discountValue = 0.0;
      final discountMatch = RegExp(r'(\d+)%').firstMatch(config.discount);
      if (discountMatch != null) {
        discountValue = double.parse(discountMatch.group(1)!) / 100;
      }

      final discountedPrice = room.price * (1 - discountValue);

      // Create a specific room instance for this offer with the discounted price
      final offerRoom = Room(
        id: room.id,
        hotelId: room.hotelId,
        name: room.name,
        type: room.type,
        bedConfiguration: room.bedConfiguration,
        price:
            discountedPrice, // This meets the user's request for "standard room price like offer"
        capacity: room.capacity,
        amenities: room.amenities,
        photos: room.photos,
        size: room.size,
        view: room.view,
        originalPrice: room.price,
      );

      return HotelOffer(
        id: hotel.id,
        title: hotel.name,
        image: config.image,
        discount: config.discount,
        price: discountedPrice,
        originalPrice: room.price,
        rating: hotel.rating,
        location: hotel.address,
        distance:
            '5 km from downtown', // You might want this in HotelDetails too eventually
        amenities: hotel.amenities.take(4).toList(),
        isAllInclusive: hotel.isAllInclusive,
        description: hotel.description,
        photos: hotel.photos,
        room: offerRoom,
      );
    }).toList();
  }

  final List<Room> _mockRooms = [
    // El Gouna - Sheraton (g1)
    Room(
      id: 'g1-r1',
      hotelId: 'g1',
      name: 'Standard Classic Room',
      type: 'Double',
      bedConfiguration: '1 King or 2 Twin Beds',
      price: 170.0,
      capacity: 2,
      amenities: ['Lagoon View', 'Private Balcony', 'Marble Bathroom'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/781847688.jpg?k=a901902fa943ea088e8a38480be55ecf0db8b99053f08a8539554d7df9eb9e92&o=',
      ],
      size: 38.0,
      view: 'Lagoon View',
    ),
    Room(
      id: 'g1-r2',
      hotelId: 'g1',
      name: 'Deluxe Sea View Room',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 210.0,
      capacity: 3,
      amenities: ['Full Sea View', 'Balcony', 'Mini Bar', 'Coffee Machine'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/782841665.jpg?k=f5f0080aaad41cf13553a4a31dbd3bdc77312d155ed3ed70ea6ae577f8b65ee5&o=',
      ],
      size: 45.0,
      view: 'Sea View',
    ),
    Room(
      id: 'g1-r3',
      hotelId: 'g1',
      name: 'Sheraton Family Suite',
      type: 'Suite',
      bedConfiguration: '2 Interconnected Rooms',
      price: 310.0,
      capacity: 4,
      amenities: ['Lagoon & Pool View', '2 Bathrooms', 'Living Area'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/688617695.jpg?k=f4fd79690815280609aa304ba996e50011da07b5b3c75e35a1124069af23d5e4&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/688617695.jpg?k=f4fd79690815280609aa304ba996e50011da07b5b3c75e35a1124069af23d5e4&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/688617695.jpg?k=f4fd79690815280609aa304ba996e50011da07b5b3c75e35a1124069af23d5e4&o=',
      ],
      size: 75.0,
      view: 'Lagoon & Pool View',
    ),
    Room(
      id: 'g1-r4',
      hotelId: 'g1',
      name: 'Presidential Lagoon Villa',
      type: 'Suite',
      bedConfiguration: '3 Bedrooms + Private Pool',
      price: 900.0,
      capacity: 6,
      amenities: [
        'Panoramic Lagoon View',
        'Private Swimming Pool',
        '24/7 Butler Service',
        'Kitchenette & Large Dining Area',
      ],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/774254563.jpg?k=448a0abd3d8e1c47c51de23bed69f547fa5548e118a8a3afa11e86c1f711827b&o=',
      ],
      size: 160.0,
      view: 'Panoramic Lagoon View',
    ),

    // El Gouna - Cook's Club (g2)
    Room(
      id: 'g2-r1',
      hotelId: 'g2',
      name: 'Standard Twin Room',
      type: 'Twin',
      bedConfiguration: '2 Twin Beds',
      price: 90.0,
      capacity: 2,
      amenities: ['Pool View', 'Boho Industrial Design'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/470346998.jpg?k=1b5568a9df0b2ef665a4ab077f7d282fb38a589172b61780113e907bc0df834a&o=',
      ],
      size: 28.0,
      view: 'Pool View',
    ),
    Room(
      id: 'g2-r2',
      hotelId: 'g2',
      name: 'Superior Double Room',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 200.0,
      capacity: 2,
      amenities: ['Pool View', 'Balcony', 'Marshall Sound System'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/482978667.jpg?k=7b8610ad221422cee00b2dfa3c1742faf82dba6d66e93d2ed1564e9103e8c659&o=',
      ],
      size: 35.0,
      view: 'Pool View',
    ),
    Room(
      id: 'g2-r3',
      hotelId: 'g2',
      name: 'Cook\'s Club Suite',
      type: 'Suite',
      bedConfiguration: '1 King Bed',
      price: 200.0,
      capacity: 3,
      amenities: ['Lagoon View', 'Large Living Area', 'Premium Mini Bar'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/406791023.jpg?k=96efb4c7f38a5a904cd6f9f422c2e7578fe92d54a3c0efdd63a5da870972106b&o=',
      ],
      size: 50.0,
      view: 'Lagoon View',
    ),

    // Makadi Bay - Jaz (m1)
    Room(
      id: 'm1-r1',
      hotelId: 'm1',
      name: 'Standard Family Room',
      type: 'Double',
      bedConfiguration: '1 King + Sofa Bed',
      price: 145.0,
      capacity: 3,
      amenities: ['Garden View', 'Balcony', 'Safe Box'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/470347110.jpg?k=af525c4bdf8cd9b479b0c1d6169fb2defdfbf9a19eaf569f9796a42eb319d8a0&o=',
      ],
      size: 35.0,
      view: 'Garden View',
    ),
    Room(
      id: 'm1-r2',
      hotelId: 'm1',
      name: 'Superior Family Room',
      type: 'Double',
      bedConfiguration: '1 King + 2 Twin Beds',
      price: 195.0,
      capacity: 4,
      amenities: ['Pool View', 'Terrace', 'Tea/Coffee Facilities'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/736416854.jpg?k=f226d52c924f67c6d0d03fdb471a11fbb6dc94430339d1e9e4146ad16c9b69b2&o=',
      ],
      size: 45.0,
      view: 'Pool View',
    ),
    Room(
      id: 'm1-r3',
      hotelId: 'm1',
      name: 'Deluxe Family Room',
      type: 'Family',
      bedConfiguration: '1 King + 2 Twin Beds',
      price: 230.0,
      capacity: 4,
      amenities: ['Pool View', '2 Bedrooms', 'Kids Amenities'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/689997038.jpg?k=4bd724a941272b45a361be6f49a84467954e8baefe2accc6f6be8c39e0168ec4&o=',
      ],
      size: 55.0,
      view: 'Pool View',
    ),
    Room(
      id: 'm1-r4',
      hotelId: 'm1',
      name: 'Makadi Junior Suite',
      type: 'Suite',
      bedConfiguration: '1 King Bed',
      price: 275.0,
      capacity: 4,
      amenities: ['Sea View', 'Living Area', 'Jacuzzi'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/426844695.jpg?k=3165f044f7863fe4ace07f7d2b541a338e5835a3c62d67ba28933425ee63bf58&o=',
      ],
      size: 65.0,
      view: 'Sea View',
    ),

    // Makadi Bay - Sunrise (m2)
    Room(
      id: 'm2-r1',
      hotelId: 'm2',
      name: 'Standard Family Room',
      type: 'Twin',
      bedConfiguration: '1 King + 1 Twin Bed',
      price: 160.0,
      capacity: 3,
      amenities: ['Pool View', 'Balcony', 'Kid-friendly Setup'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/535616590.jpg?k=0ec2b5b80402ce24daa9c3530dc145962678c865cab66d42ea846753a8547d4b&o=',
      ],
      size: 40.0,
      view: 'Pool View',
      originalPrice: 160.0,
    ),
    Room(
      id: 'm2-r2',
      hotelId: 'm2',
      name: 'Mega Family Room',
      type: 'Family',
      bedConfiguration: '1 King + 2 Twin Beds',
      price: 185.0,
      capacity: 4,
      amenities: ['Aqua Park View', 'Spacious Balcony', 'Kids Welcome Kit'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max300/689995698.jpg?k=d60b7f864011deb0c7db30662986eb20fc7a193a1d35fd85933d66a7adc964c5&o=',
      ],
      size: 55.0,
      view: 'Aqua Park View',
    ),
    Room(
      id: 'm2-r3',
      hotelId: 'm2',
      name: 'Royal Family Suite',
      type: 'Suite',
      bedConfiguration: '2 Bedrooms',
      price: 235.0,
      capacity: 4,
      amenities: ['Sea View', '2 Bedrooms', 'Living Room'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/688617707.jpg?k=480c02f894a0084ad253df3df9faa5f82331136dba248a8e5849481f67d8b739&o=',
      ],
      size: 70.0,
      view: 'Sea View',
    ),
    Room(
      id: 'm2-r4',
      hotelId: 'm2',
      name: 'Sunrise Panorama Suite',
      type: 'Suite',
      bedConfiguration: '2 Bedrooms + Living',
      price: 290.0,
      capacity: 5,
      amenities: ['Sea View', '2 Bedrooms', 'Terrace', 'Kitchenette'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max300/466999953.jpg?k=af06c5d29c41a0cd6b6ab0a2abc3e8c3b68cc246316d39f915be78081737054b&o=',
      ],
      size: 90.0,
      view: 'Sea View',
    ),

    // Soma Bay - Kempinski (s1)
    Room(
      id: 's1-r1',
      hotelId: 's1',
      name: 'Standard Laguna Club Room',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 250.0,
      capacity: 2,
      amenities: ['Garden View', 'Club Access Included', 'Marble Bath'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/781847688.jpg?k=a901902fa943ea088e8a38480be55ecf0db8b99053f08a8539554d7df9eb9e92&o=',
      ],
      size: 45.0,
      view: 'Garden View',
    ),
    Room(
      id: 's1-r2',
      hotelId: 's1',
      name: 'Laguna Club Sea View Room',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 295.0,
      capacity: 2,
      amenities: ['Full Sea View', 'Balcony', 'Club Lounge Access'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/781847688.jpg?k=a901902fa943ea088e8a38480be55ecf0db8b99053f08a8539554d7df9eb9e92&o=',
      ],
      size: 50.0,
      view: 'Sea View',
    ),
    Room(
      id: 's1-r3',
      hotelId: 's1',
      name: 'Deluxe Junior Suite',
      type: 'Suite',
      bedConfiguration: '1 King Bed',
      price: 370.0,
      capacity: 3,
      amenities: ['Sea View', 'Separate Living Room', 'Spa Bath'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/426844695.jpg?k=3165f044f7863fe4ace07f7d2b541a338e5835a3c62d67ba28933425ee63bf58&o=',
      ],
      size: 70.0,
      view: 'Sea View',
    ),
    Room(
      id: 's1-r4',
      hotelId: 's1',
      name: 'Kempinski Royal Suite',
      type: 'Suite',
      bedConfiguration: 'Master + Guest Bedroom',
      price: 760.0,
      capacity: 4,
      amenities: ['Panoramic Red Sea View', 'Kitchenette', 'Butler Service'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/288616501.jpg?k=dc80af8425701bba3c46dfef704fc475a32bca94e5ff109dbbaa4ad3263d2104&o=',
      ],
      size: 130.0,
      view: 'Panoramic Sea View',
    ),

    // Sahl Hasheesh - Baron (sh1)
    Room(
      id: 'sh1-r1',
      hotelId: 'sh1',
      name: 'Standard Baron Deluxe Room',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 310.0,
      capacity: 2,
      amenities: ['Unobstructed Sea View', 'Large Balcony', 'Pillow Menu'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/782841665.jpg?k=f5f0080aaad41cf13553a4a31dbd3bdc77312d155ed3ed70ea6ae577f8b65ee5&o=',
      ],
      size: 50.0,
      view: 'Sea View',
    ),
    Room(
      id: 'sh1-r2',
      hotelId: 'sh1',
      name: 'Swim-Up Deluxe Room',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 380.0,
      capacity: 2,
      amenities: ['Direct Pool Access', 'Adults Only Zone', 'VIP Check-in'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/772260245.jpg?k=8d86a326e10f8aabd4db2027d0349452545dceaa66bfa2010c5db8eba2ea77f7&o=',
      ],
      size: 55.0,
      view: 'Pool View',
    ),
    Room(
      id: 'sh1-r3',
      hotelId: 'sh1',
      name: 'Panorama Suite',
      type: 'Suite',
      bedConfiguration: '1 King Bed',
      price: 490.0,
      capacity: 3,
      amenities: ['180 Degree Sea View', 'Separate Bedroom', 'Jacuzzi'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/746291951.jpg?k=96923552653720f591878f36bb38615dedb879316eb93f714d392fa264d71e15&o=',
      ],
      size: 85.0,
      view: 'Sea View',
    ),
    Room(
      id: 'sh1-r4',
      hotelId: 'sh1',
      name: 'Royal Palace Suite',
      type: 'Suite',
      bedConfiguration: '2 Master Bedrooms + Private Pool',
      price: 1050.0,
      capacity: 4,
      amenities: ['Private Infinity Pool', 'Cinema Room', 'Chef Service'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/774254563.jpg?k=448a0abd3d8e1c47c51de23bed69f547fa5548e118a8a3afa11e86c1f711827b&o=',
      ],
      size: 220.0,
      view: 'Panoramic Sea View',
    ),

    // Hurghada - Meraki (h1)
    Room(
      id: 'h1-r1',
      hotelId: 'h1',
      name: 'Standard Gypster Room',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 125.0,
      capacity: 2,
      amenities: ['Boho Design', 'Private Balcony', 'Vibe-driven Decor'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/495975478.jpg?k=9d4ec5ea92c93e874c5f63e612a06b478225adac607f133bb1d14b5e7ba438e9&o=',
      ],
      size: 30.0,
      view: 'Garden View',
    ),
    Room(
      id: 'h1-r2',
      hotelId: 'h1',
      name: 'Merakilous Sea View Room',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 155.0,
      capacity: 2,
      amenities: ['Direct Sea View', 'Boho Chic Design', 'Mini Bar'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/495975449.jpg?k=6e1300d140b390ffa54ce6b7b3a6aeb2abf817052b390d23f301c1fc40344c42&o=',
      ],
      size: 38.0,
      view: 'Sea View',
    ),
    Room(
      id: 'h1-r3',
      hotelId: 'h1',
      name: 'The Party Suite',
      type: 'Suite',
      bedConfiguration: '1 King Bed + Lounge Area',
      price: 230.0,
      capacity: 3,
      amenities: ['Sea View', 'Marshall Speaker', 'Premium Vibe'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/77364301.jpg?k=38393803548ca743b8790cb996009bbbcee528ab9603df54e78716e7904917ad&o=',
      ],
      size: 60.0,
      view: 'Sea View',
    ),

    // Hurghada - Seagull (h2)
    Room(
      id: 'h2-r1',
      hotelId: 'h2',
      name: 'Standard City View Room',
      type: 'Twin',
      bedConfiguration: '2 Twin Beds',
      price: 65.0,
      capacity: 2,
      amenities: ['City View', 'Standard Comfort', 'WiFi'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/470347110.jpg?k=af525c4bdf8cd9b479b0c1d6169fb2defdfbf9a19eaf569f9796a42eb319d8a0&o=',
      ],
      size: 28.0,
      view: 'City View',
    ),
    Room(
      id: 'h2-r2',
      hotelId: 'h2',
      name: 'Superior Side Sea View',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 85.0,
      capacity: 3,
      amenities: ['Side Sea View', 'Balcony', 'Mini Bar'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/736416741.jpg?k=1fe442e1c113beaa7b43d26e580b4e75bfad18f13b620ca6c57164c22dd989da&o=',
      ],
      size: 35.0,
      view: 'Side Sea View',
    ),
    Room(
      id: 'h2-r3',
      hotelId: 'h2',
      name: 'Family Sea View Room',
      type: 'Family',
      bedConfiguration: '2 Double Beds',
      price: 115.0,
      capacity: 4,
      amenities: ['Full Sea View', 'Extra Wardrobe Space', 'Balcony'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/689997038.jpg?k=4bd724a941272b45a361be6f49a84467954e8baefe2accc6f6be8c39e0168ec4&o=',
      ],
      size: 50.0,
      view: 'Sea View',
    ),

    // Al Mamsha - Steigenberger (am1)
    Room(
      id: 'am1-r1',
      hotelId: 'am1',
      name: 'Standard Superior Room',
      type: 'Double',
      bedConfiguration: '1 King or 2 Twin Beds',
      price: 165.0,
      capacity: 3,
      amenities: ['Pool View', 'French Balcony', 'Tea & Coffee'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/470347118.jpg?k=ea9e8abab2ef1e776c98441d57b5d39d44775f53ec6612ea7a43aa78f7ff2f88&o=',
      ],
      size: 35.0,
      view: 'Pool View',
    ),
    Room(
      id: 'am1-r2',
      hotelId: 'am1',
      name: 'Deluxe Family Room',
      type: 'Family',
      bedConfiguration: '1 King + 2 Sofa Beds',
      price: 210.0,
      capacity: 4,
      amenities: ['Garden View', 'Large Balcony', 'Kids Welcome Amenities'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/689995698.jpg?k=d60b7f864011deb0c7db30662986eb20fc7a193a1d35fd85933d66a7adc964c5&o=',
      ],
      size: 45.0,
      view: 'Garden View',
    ),
    Room(
      id: 'am1-r3',
      hotelId: 'am1',
      name: 'Aqua Junior Suite',
      type: 'Suite',
      bedConfiguration: '1 King Bed + Living Area',
      price: 275.0,
      capacity: 4,
      amenities: ['Pool & Aqua View', 'Separate Living Room', 'Mini Bar'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max300/779295806.jpg?k=b7fff8c501c53519d1db583094067a317cacd1b9d10e910c3bf42f1422cc8d2a&o=',
      ],
      size: 65.0,
      view: 'Pool View',
    ),
    Room(
      id: 'am1-r4',
      hotelId: 'am1',
      name: 'Aqua Family Suite',
      type: 'Suite',
      bedConfiguration: '2 Bedrooms + Living',
      price: 330.0,
      capacity: 5,
      amenities: ['Full Aqua Park View', '2 Bathrooms', 'Large Balcony'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/466999966.jpg?k=80d3b9c27ea3cf45d842ebdca7b4caa7bf68597156956d5fc9b1d0e964ae6bf4&o=',
      ],
      size: 80.0,
      view: 'Aqua View',
    ),
    Room(
      id: 'am1-r5',
      hotelId: 'am1',
      name: 'Royal Family Villa',
      type: 'Suite',
      bedConfiguration: '3 Bedrooms + Large Lounge',
      price: 510.0,
      capacity: 6,
      amenities: [
        'Direct Sea/Pool View',
        'Private Kitchenette',
        'VIP Benefits',
        'Extended Terrace',
      ],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/290132323.jpg?k=0e1b2f99b0b97b55d5a1df1720f71316576abf5eb4b03ad4a75bbd5ab8af9e73&o=',
      ],
      size: 120.0,
      view: 'Panoramic View',
    ),

    // Rixos (rixos)
    Room(
      id: 'rixos-r1',
      hotelId: 'rixos',
      name: 'Standard Garden Suite',
      type: 'Suite',
      bedConfiguration: '1 King Bed',
      price: 450.0,
      capacity: 2,
      amenities: ['Garden View', 'Luxury Bulgari Amenities', 'IPTV'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/688024356.jpg?k=26f714094463d8b4cd828ba2b798284add647a3f5f3c15e1f09012511399a0dd&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/688617695.jpg?k=f4fd79690815280609aa304ba996e50011da07b5b3c75e35a1124069af23d5e4&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/688617695.jpg?k=f4fd79690815280609aa304ba996e50011da07b5b3c75e35a1124069af23d5e4&o=',
      ],
      size: 55.0,
      view: 'Garden View',
      originalPrice: 450.0,
    ),
    Room(
      id: 'rixos-r2',
      hotelId: 'rixos',
      name: 'Premium Sea View Suite',
      type: 'Suite',
      bedConfiguration: '1 King Bed',
      price: 400.0,
      capacity: 3,
      amenities: ['Full Sea View', 'Terrace', 'Butler Service'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/638772423.jpg?k=8cf095445df240174e31469b523c63345987008f957f1dce1c1d9da208e073f5&o=',
        'https://cf.bstatic.com/xdata/images/hotel/max500/638772423.jpg?k=8cf095445df240174e31469b523c63345987008f957f1dce1c1d9da208e073f5&o=',
      ],
      size: 70.0,
      view: 'Sea View',
    ),

    // Steigenberger ALDAU (aldau)
    Room(
      id: 'aldau-r1',
      hotelId: 'aldau',
      name: 'Standard Deluxe Sea View',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 245.0,
      capacity: 2,
      amenities: ['Full Sea View', 'Private Balcony', 'Luxury Linens'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/600317964.jpg?k=517eff1005e62451cff2f1281779fa9395c2e7bbc2246f56d41989d8a94ddbd5&o=',
      ],
      size: 50.0,
      view: 'Sea View',
      originalPrice: 11875.0,
    ),
    Room(
      id: 'aldau-r2',
      hotelId: 'aldau',
      name: 'Elite Family Suite',
      type: 'Suite',
      bedConfiguration: '2 Bedrooms',
      price: 290.0,
      capacity: 5,
      amenities: ['Sea & Pool View', '2 Marble Bathrooms', 'Living Area'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/600315206.jpg?k=fb4a0cba65b7e240884e44a3a329528eacd378b06f00359d566f41b441d8a4d5&o=',
      ],
      size: 85.0,
      view: 'Sea & Pool View',
    ),

    // Jaz Casa Del Mar (jaz_casa)
    Room(
      id: 'jaz_casa-r1',
      hotelId: 'jaz_casa',
      name: 'Standard Superior Garden',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 190.0,
      capacity: 2,
      amenities: ['Garden View', 'Renovated Interiors', 'Balcony'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/333819379.jpg?k=03358df14618f90c3b64374d2a26b9264de61fe76ada433e388f2a867b74bd32&o=',
      ],
      size: 38.0,
      view: 'Garden View',
      originalPrice: 190.0,
    ),
    Room(
      id: 'jaz_casa-r2',
      hotelId: 'jaz_casa',
      name: 'Superior Pool View Room',
      type: 'Double',
      bedConfiguration: '1 King Bed',
      price: 180.0,
      capacity: 3,
      amenities: ['Pool View', 'Balcony', 'Mini Bar'],
      photos: [
        'https://cf.bstatic.com/xdata/images/hotel/max500/536482139.jpg?k=1635f1448cf6ca2660172e7a60a3f0c6610aa376a3c36801747cd9975576892d&o=',
      ],
      size: 42.0,
      view: 'Pool View',
    ),
  ];

  @override
  Future<List<HotelSearchResult>> searchHotels(
    String query, {
    DateTime? checkIn,
    DateTime? checkOut,
    int rooms = 1,
    int adults = 1,
    int children = 0,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulate network delay

    // Filter hotels based on query (location or name)
    var filteredHotels = _mockHotels;
    if (query.isNotEmpty && query.toLowerCase() != 'all hurghada') {
      filteredHotels = filteredHotels
          .where(
            (hotel) =>
                hotel.name.toLowerCase().contains(query.toLowerCase()) ||
                hotel.address.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    // Filter based on room capacity
    final totalGuests = adults + children;
    filteredHotels = filteredHotels.where((hotel) {
      final hotelRooms = _mockRooms
          .where((r) => r.hotelId == hotel.id)
          .toList();
      if (hotelRooms.isEmpty) return false;
      final avgGuestsPerRoom = totalGuests / rooms;
      return hotelRooms.any((room) => room.capacity >= avgGuestsPerRoom.ceil());
    }).toList();

    // MAP HotelDetails -> HotelSearchResult
    return filteredHotels
        .map(
          (details) => HotelSearchResult(
            id: details.id,
            name: details.name,
            address: details.address,
            rating: details.rating,
            pricePerNight: details.pricePerNight,
            imageUrl: details.imageUrl,
            amenities: details.amenities,
            isAllInclusive: details.isAllInclusive,
            discount: details.discount,
            originalPrice: details.originalPrice,
          ),
        )
        .toList();
  }

  @override
  Future<HotelDetails?> getHotelById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockHotels.firstWhere((hotel) => hotel.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Room>> getRoomsForHotel(String hotelId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockRooms.where((room) => room.hotelId == hotelId).toList();
  }

  @override
  Future<HotelOffer?> getOfferById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockOffers.firstWhere((offer) => offer.id == id);
    } catch (e) {
      return null;
    }
  }
}

class _OfferConfig {
  final String hotelId;
  final String roomId;
  final String discount;
  final String image;

  _OfferConfig({
    required this.hotelId,
    required this.roomId,
    required this.discount,
    required this.image,
  });
}
