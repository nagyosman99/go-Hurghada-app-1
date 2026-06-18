# Static App Data

This file contains the actual static data currently used in the application, converted to JSON format for backend seeding.

## 1. Hotels

```json
[
  {
    "id": "g1",
    "name": "Sheraton Miramar Resort El Gouna",
    "address": "El Gouna, Red Sea",
    "rating": 4.7,
    "pricePerNight": 200.0,
    "imageUrl": "https://picsum.photos/seed/sheraton/800/600",
    "amenities": [
      "Private Beach", "Pools", "Spa", "Water Sports", "Free WiFi",
      "Gym", "Kids Club", "Restaurants", "Bar", "Room Service"
    ],
    "description": "Designed by Michael Graves, this resort offers a unique blend of Arabic and Nubian styles. Spread across nine islands, the resort features spacious rooms with stunning views of the lagoons and private beaches. Enjoy world-class dining, a relaxing spa, and endless water sports activities in the heart of El Gouna.",
    "photos": [
      "https://picsum.photos/seed/sheraton1/800/600",
      "https://picsum.photos/seed/sheraton2/800/600",
      "https://picsum.photos/seed/sheraton3/800/600"
    ]
  },
  {
    "id": "g2",
    "name": "Cook's Club El Gouna",
    "address": "Downtown, El Gouna",
    "rating": 4.5,
    "pricePerNight": 120.0,
    "imageUrl": "https://picsum.photos/seed/cooks/800/600",
    "amenities": [
      "Adults Only", "DJ", "Pool", "Bar", "Free WiFi",
      "Yoga", "Beach Access", "Nightclub"
    ],
    "description": "A trendy hotel for a new generation of travelers. Located in the heart of Downtown El Gouna, Cook's Club offers a vibrant atmosphere with a massive pool, live DJ sets, and a modern design. Perfect for those looking to relax by day and party by night, with easy access to the town's best nightlife.",
    "photos": [
      "https://picsum.photos/seed/sheraton1/800/600",
      "https://picsum.photos/seed/sheraton2/800/600",
      "https://picsum.photos/seed/sheraton3/800/600"
    ]
  },
  {
    "id": "m1",
    "name": "Jaz Makadi Saraya Resort",
    "address": "Makadi Bay, Hurghada",
    "rating": 4.8,
    "pricePerNight": 180.0,
    "imageUrl": "https://picsum.photos/seed/jaz/800/600",
    "amenities": [
      "Water Park", "Family Friendly", "All Inclusive",
      "Kids Pool", "Animation Team", "Tennis Court", "Spa"
    ],
    "description": "A family-friendly resort with access to a stunning water park. Jaz Makadi Saraya offers a perfect blend of relaxation and adventure, with spacious family rooms, multiple pools, and a dedicated kids' club. Guests can enjoy access to the nearby Makadi Water World and a variety of dining options."
  },
  {
    "id": "m2",
    "name": "Sunrise Royal Makadi Resort",
    "address": "Makadi Bay, Hurghada",
    "rating": 4.6,
    "pricePerNight": 160.0,
    "imageUrl": "https://picsum.photos/seed/sunrise/800/600",
    "amenities": ["Aqua Park", "7 Pools", "Kids Club"],
    "description": "Experience the best of Makadi Bay with extensive facilities. This resort features 7 swimming pools, an aqua park, and a private beach. With a wide range of restaurants and bars, as well as a full-service spa, it's the ideal destination for families and couples alike."
  },
  {
    "id": "s1",
    "name": "Kempinski Hotel Soma Bay",
    "address": "Soma Bay, Hurghada",
    "rating": 4.9,
    "pricePerNight": 250.0,
    "imageUrl": "https://picsum.photos/seed/kempinski/800/600",
    "amenities": ["Luxury", "Private Beach", "Golf Nearby", "Spa"],
    "description": "European luxury blended with Egyptian hospitality. Kempinski Hotel Soma Bay is a stunning resort located on one of the finest beaches in the Red Sea. Featuring a cascading pool system, a lazy river, and a world-class spa, it offers an unparalleled luxury experience."
  },
  {
    "id": "sh1",
    "name": "Baron Palace Sahl Hasheesh",
    "address": "Sahl Hasheesh, Hurghada",
    "rating": 4.8,
    "pricePerNight": 280.0,
    "imageUrl": "https://picsum.photos/seed/baron/800/600",
    "amenities": ["Infinity Pool", "Fine Dining", "Diving", "Spa"],
    "description": "A 6-star luxury resort in the heart of Sahl Hasheesh. Baron Palace features classic Mediterranean architecture, lush gardens, and a pristine private beach. Indulge in fine dining at one of the many a la carte restaurants or relax by the infinity pool overlooking the Red Sea."
  },
  {
    "id": "h1",
    "name": "Meraki Resort",
    "address": "El Dahar, Hurghada City Center",
    "rating": 4.4,
    "pricePerNight": 130.0,
    "imageUrl": "https://picsum.photos/seed/meraki/800/600",
    "amenities": ["Boho Style", "Adults Only", "Clubbing"],
    "description": "The first boho-clubbing resort in the Middle East. Meraki Resort offers a unique, adults-only experience with a vibrant atmosphere, stylish rooms, and a private beach. Enjoy daily parties, live music, and a variety of dining options in a relaxed, bohemian setting."
  },
  {
    "id": "h2",
    "name": "Seagull Beach Resort",
    "address": "Sheraton Road, Hurghada City Center",
    "rating": 4.0,
    "pricePerNight": 90.0,
    "imageUrl": "https://picsum.photos/seed/seagull/800/600",
    "amenities": ["Aqua Park", "Private Beach", "Shopping Mall"],
    "description": "Located directly on the Red Sea with a private beach. Seagull Beach Resort is situated in the heart of Hurghada, offering easy access to shopping and entertainment. The resort features two private beaches, an aqua park, and a mini-zoo, making it perfect for families."
  },
  {
    "id": "am1",
    "name": "Steigenberger Aqua Magic",
    "address": "Al Mamsha, Hurghada",
    "rating": 4.6,
    "pricePerNight": 170.0,
    "imageUrl": "https://picsum.photos/seed/steigenberger/800/600",
    "amenities": ["Family Friendly", "Aqua Park", "Golf"],
    "description": "The most vibrant family resort in the Red Sea. Steigenberger Aqua Magic features a massive aqua park, a lazy river, and a rooftop adults-only pool. With spacious family suites and a 24-hour all-inclusive concept, it guarantees a fun-filled vacation for everyone."
  },
  {
    "id": "rixos",
    "name": "Rixos Premium Magawish",
    "address": "Hurghada, Egypt",
    "rating": 4.9,
    "pricePerNight": 4648.0,
    "imageUrl": "https://picsum.photos/seed/rixos_main/800/600",
    "amenities": ["Private Beach", "Luxury Spa", "Fine Dining", "Horse Riding"],
    "description": "Luxury suites and villas with a private beach. Rixos Premium Magawish offers an exclusive all-inclusive experience with elegant accommodations, world-class dining, and a private marina. Guests can enjoy horse riding, water sports, and a luxurious spa in a serene setting."
  },
  {
    "id": "aldau",
    "name": "Steigenberger ALDAU Beach",
    "address": "Al Mamsha, Hurghada",
    "rating": 4.8,
    "pricePerNight": 3500.0,
    "originalPrice": 4375.0,
    "discount": "20% OFF",
    "isAllInclusive": true,
    "imageUrl": "https://picsum.photos/seed/aldau_main/800/600",
    "amenities": ["Golf Course", "Water Park", "Dive Center", "Kids Club"],
    "description": "Exclusive 5-star beach hotel with a golf course. Steigenberger ALDAU Beach Hotel is a haven of luxury, featuring a 9-hole golf course, a dive center, and a massive lazy river. The resort offers spacious rooms, gourmet dining, and exceptional service."
  },
  {
    "id": "jaz_casa",
    "name": "Jaz Casa Del Mar Beach",
    "address": "Al Mamsha, Hurghada",
    "rating": 4.7,
    "pricePerNight": 2800.0,
    "imageUrl": "https://picsum.photos/seed/jaz_casa_main/800/600",
    "amenities": ["All Inclusive", "Family Friendly", "Evening Entertainment"],
    "description": "Modern resort located on the promenade. Jaz Casa Del Mar Beach offers a contemporary design, a private beach, and a lively atmosphere. Guests can enjoy a variety of water sports, evening entertainment, and delicious international cuisine.",
    "isAllInclusive": true
  }
]
```

## 2. Rooms

```json
[
  {
    "id": "g1-r1", "hotelId": "g1", "name": "Classic Room", "type": "Double",
    "price": 200.0, "capacity": 2, "amenities": ["Lagoon View", "Balcony", "Mini Bar"],
    "imageUrl": "https://picsum.photos/seed/room1/800/600"
  },
  {
    "id": "g1-r2", "hotelId": "g1", "name": "Deluxe Room", "type": "Double",
    "price": 250.0, "capacity": 3, "amenities": ["Sea View", "Balcony", "Mini Bar", "Coffee Machine"],
    "imageUrl": "https://picsum.photos/seed/room1b/800/600"
  },
  {
    "id": "g1-r3", "hotelId": "g1", "name": "Family Suite", "type": "Suite",
    "price": 350.0, "capacity": 4, "amenities": ["Sea View", "2 Bedrooms", "Living Room", "Kitchenette"],
    "imageUrl": "https://picsum.photos/seed/room1c/800/600"
  },
  {
    "id": "g1-r4", "hotelId": "g1", "name": "Presidential Suite", "type": "Suite",
    "price": 600.0, "capacity": 6, "amenities": ["Panoramic View", "3 Bedrooms", "Private Pool", "Butler Service"],
    "imageUrl": "https://picsum.photos/seed/room1d/800/600"
  },
  {
    "id": "g2-r1", "hotelId": "g2", "name": "Standard Room", "type": "Twin",
    "price": 120.0, "capacity": 2, "amenities": ["Pool View", "Modern Design"],
    "imageUrl": "https://picsum.photos/seed/room2/800/600"
  },
  {
    "id": "g2-r2", "hotelId": "g2", "name": "Superior Room", "type": "Double",
    "price": 150.0, "capacity": 2, "amenities": ["Pool View", "Balcony", "Premium Amenities"],
    "imageUrl": "https://picsum.photos/seed/room2b/800/600"
  },
  {
    "id": "g2-r3", "hotelId": "g2", "name": "Deluxe Suite", "type": "Suite",
    "price": 220.0, "capacity": 3, "amenities": ["Sea View", "Living Area", "Premium Bar"],
    "imageUrl": "https://picsum.photos/seed/room2c/800/600"
  },
  {
    "id": "m1-r1", "hotelId": "m1", "name": "Standard Room", "type": "Double",
    "price": 150.0, "capacity": 2, "amenities": ["Garden View", "Balcony"],
    "imageUrl": "https://picsum.photos/seed/room3/800/600"
  },
  {
    "id": "m1-r2", "hotelId": "m1", "name": "Superior Room", "type": "Double",
    "price": 180.0, "capacity": 3, "amenities": ["Garden View", "Terrace", "Mini Bar"],
    "imageUrl": "https://picsum.photos/seed/room3b/800/600"
  },
  {
    "id": "m1-r3", "hotelId": "m1", "name": "Family Room", "type": "Family",
    "price": 250.0, "capacity": 4, "amenities": ["Pool View", "2 Bedrooms", "Kids Amenities"],
    "imageUrl": "https://picsum.photos/seed/room3c/800/600"
  },
  {
    "id": "m1-r4", "hotelId": "m1", "name": "Junior Suite", "type": "Suite",
    "price": 300.0, "capacity": 4, "amenities": ["Sea View", "Living Area", "Jacuzzi"],
    "imageUrl": "https://picsum.photos/seed/room3d/800/600"
  },
  {
    "id": "m2-r1", "hotelId": "m2", "name": "Standard Room", "type": "Twin",
    "price": 140.0, "capacity": 2, "amenities": ["Pool View", "Balcony"],
    "imageUrl": "https://picsum.photos/seed/room4/800/600"
  },
  {
    "id": "m2-r2", "hotelId": "m2", "name": "Family Room", "type": "Family",
    "price": 200.0, "capacity": 4, "amenities": ["Pool View", "Extra Bed", "Kids Welcome"],
    "imageUrl": "https://picsum.photos/seed/room4b/800/600"
  },
  {
    "id": "m2-r3", "hotelId": "m2", "name": "Family Suite", "type": "Suite",
    "price": 250.0, "capacity": 4, "amenities": ["Sea View", "2 Bedrooms", "Living Room"],
    "imageUrl": "https://picsum.photos/seed/room4c/800/600"
  },
  {
    "id": "m2-r4", "hotelId": "m2", "name": "Deluxe Family Suite", "type": "Suite",
    "price": 320.0, "capacity": 5, "amenities": ["Sea View", "2 Bedrooms", "Terrace", "Kitchenette"],
    "imageUrl": "https://picsum.photos/seed/room4d/800/600"
  },
  {
    "id": "s1-r1", "hotelId": "s1", "name": "Classic Room", "type": "Double",
    "price": 250.0, "capacity": 2, "amenities": ["Garden View", "Luxury Amenities"],
    "imageUrl": "https://picsum.photos/seed/room5/800/600"
  },
  {
    "id": "s1-r2", "hotelId": "s1", "name": "Laguna Club Room", "type": "Double",
    "price": 300.0, "capacity": 2, "amenities": ["Club Access", "Sea View", "Premium Service"],
    "imageUrl": "https://picsum.photos/seed/room5b/800/600"
  },
  {
    "id": "s1-r3", "hotelId": "s1", "name": "Junior Suite", "type": "Suite",
    "price": 400.0, "capacity": 3, "amenities": ["Sea View", "Living Area", "Spa Bath"],
    "imageUrl": "https://picsum.photos/seed/room5c/800/600"
  },
  {
    "id": "s1-r4", "hotelId": "s1", "name": "Royal Suite", "type": "Suite",
    "price": 700.0, "capacity": 4, "amenities": ["Panoramic View", "2 Bedrooms", "Private Butler", "Terrace"],
    "imageUrl": "https://picsum.photos/seed/room5d/800/600"
  },
  {
    "id": "sh1-r1", "hotelId": "sh1", "name": "Deluxe Room", "type": "Double",
    "price": 280.0, "capacity": 2, "amenities": ["Sea View", "Balcony", "Luxury Amenities"],
    "imageUrl": "https://picsum.photos/seed/room6/800/600"
  },
  {
    "id": "sh1-r2", "hotelId": "sh1", "name": "Swim-Up Room", "type": "Double",
    "price": 380.0, "capacity": 2, "amenities": ["Direct Pool Access", "Adults Only", "Premium Bar"],
    "imageUrl": "https://picsum.photos/seed/room6b/800/600"
  },
  {
    "id": "sh1-r3", "hotelId": "sh1", "name": "Swim-Up Suite", "type": "Suite",
    "price": 450.0, "capacity": 3, "amenities": ["Direct Pool Access", "Living Area", "Adults Only"],
    "imageUrl": "https://picsum.photos/seed/room6c/800/600"
  },
  {
    "id": "sh1-r4", "hotelId": "sh1", "name": "Presidential Suite", "type": "Suite",
    "price": 800.0, "capacity": 4, "amenities": ["Private Pool", "Sea View", "Butler Service", "2 Bedrooms"],
    "imageUrl": "https://picsum.photos/seed/room6d/800/600"
  },
  {
    "id": "h1-r1", "hotelId": "h1", "name": "Gypster Room", "type": "Double",
    "price": 130.0, "capacity": 2, "amenities": ["Boho Design", "Unique Decor"],
    "imageUrl": "https://picsum.photos/seed/room7/800/600"
  },
  {
    "id": "h1-r2", "hotelId": "h1", "name": "Deluxe Gypster", "type": "Double",
    "price": 160.0, "capacity": 2, "amenities": ["Boho Design", "Sea View", "Premium Amenities"],
    "imageUrl": "https://picsum.photos/seed/room7b/800/600"
  },
  {
    "id": "h1-r3", "hotelId": "h1", "name": "Family Gypster", "type": "Family",
    "price": 220.0, "capacity": 4, "amenities": ["Boho Design", "Extra Space", "Kids Welcome"],
    "imageUrl": "https://picsum.photos/seed/room7c/800/600"
  },
  {
    "id": "h2-r1", "hotelId": "h2", "name": "Standard Room", "type": "Twin",
    "price": 90.0, "capacity": 2, "amenities": ["City View", "Basic Amenities"],
    "imageUrl": "https://picsum.photos/seed/room8/800/600"
  },
  {
    "id": "h2-r2", "hotelId": "h2", "name": "Superior Room", "type": "Double",
    "price": 110.0, "capacity": 3, "amenities": ["City View", "Balcony", "Mini Bar"],
    "imageUrl": "https://picsum.photos/seed/room8b/800/600"
  },
  {
    "id": "h2-r3", "hotelId": "h2", "name": "Family Room", "type": "Family",
    "price": 150.0, "capacity": 4, "amenities": ["City View", "Extra Bed", "Spacious"],
    "imageUrl": "https://picsum.photos/seed/room8c/800/600"
  },
  {
    "id": "am1-r1", "hotelId": "am1", "name": "Standard Room", "type": "Double",
    "price": 180.0, "capacity": 2, "amenities": ["Pool View", "Modern Design"],
    "imageUrl": "https://picsum.photos/seed/room9/800/600"
  },
  {
    "id": "am1-r2", "hotelId": "am1", "name": "Family Room", "type": "Family",
    "price": 220.0, "capacity": 4, "amenities": ["Pool View", "Extra Bed", "Kids Amenities"],
    "imageUrl": "https://picsum.photos/seed/room9b/800/600"
  },
  {
    "id": "am1-r3", "hotelId": "am1", "name": "Family Suite", "type": "Suite",
    "price": 280.0, "capacity": 4, "amenities": ["Pool View", "2 Bedrooms", "Living Room"],
    "imageUrl": "https://picsum.photos/seed/room9c/800/600"
  },
  {
    "id": "am1-r4", "hotelId": "am1", "name": "Deluxe Family Suite", "type": "Suite",
    "price": 350.0, "capacity": 5, "amenities": ["Sea View", "2 Bedrooms", "Terrace", "Premium Service"],
    "imageUrl": "https://picsum.photos/seed/room9d/800/600"
  },
  {
    "id": "am1-r5", "hotelId": "am1", "name": "Grand Family Suite", "type": "Suite",
    "price": 450.0, "capacity": 6, "amenities": ["Sea View", "3 Bedrooms", "Living Room", "Kitchenette", "Balcony"],
    "imageUrl": "https://picsum.photos/seed/room9e/800/600"
  },
  {
    "id": "rixos-r1", "hotelId": "rixos", "name": "Suite with Balcony", "type": "Suite",
    "price": 4648.0, "capacity": 2, "amenities": ["Sea View", "Balcony", "Luxury Amenities"],
    "imageUrl": "https://picsum.photos/seed/rixos_room1/800/600"
  },
  {
    "id": "rixos-r2", "hotelId": "rixos", "name": "Lagoon Villa", "type": "Villa",
    "price": 8000.0, "capacity": 4, "amenities": ["Private Pool", "Direct Lagoon Access", "Butler Service"],
    "imageUrl": "https://picsum.photos/seed/rixos_room2/800/600"
  },
  {
    "id": "aldau-r1", "hotelId": "aldau", "name": "Deluxe Sea View", "type": "Double",
    "price": 3500.0, "capacity": 2, "amenities": ["Sea View", "Balcony", "King Bed"],
    "imageUrl": "https://picsum.photos/seed/aldau_room1/800/600"
  },
  {
    "id": "aldau-r2", "hotelId": "aldau", "name": "Family Suite", "type": "Suite",
    "price": 5500.0, "capacity": 4, "amenities": ["Sea View", "2 Bedrooms", "Living Area"],
    "imageUrl": "https://picsum.photos/seed/aldau_room2/800/600"
  },
  {
    "id": "jaz_casa-r1", "hotelId": "jaz_casa", "name": "Standard Room", "type": "Double",
    "price": 2800.0, "capacity": 2, "amenities": ["Garden View", "Balcony"],
    "imageUrl": "https://picsum.photos/seed/jaz_casa_room1/800/600"
  },
  {
    "id": "jaz_casa-r2", "hotelId": "jaz_casa", "name": "Superior Sea View", "type": "Double",
    "price": 3200.0, "capacity": 2, "amenities": ["Sea View", "Balcony", "Mini Bar"],
    "imageUrl": "https://picsum.photos/seed/jaz_casa_room2/800/600"
  }
]
```

## 3. Offers

```json
[
  {
    "id": "rixos",
    "title": "Rixos Premium Magawish",
    "image": "https://picsum.photos/seed/rixos_offer/800/600",
    "discount": "35% OFF",
    "price": "EGP 4,648",
    "originalPrice": "EGP 7,151",
    "featured": true,
    "rating": 4.9,
    "reviewCount": 1250,
    "location": "Hurghada, Egypt",
    "distance": "9.2 km from downtown",
    "amenities": ["Private Beach", "Luxury Spa", "Fine Dining", "Horse Riding"],
    "roomType": "Suite with Balcony",
    "bedInfo": "2 full beds",
    "cancellationPolicy": "Free cancellation",
    "isAllInclusive": true
  },
  {
    "id": "aldau",
    "title": "Steigenberger ALDAU Beach",
    "image": "https://picsum.photos/seed/aldau_offer/800/600",
    "discount": "30% OFF",
    "price": "EGP 3,500",
    "originalPrice": "EGP 5,000",
    "featured": true,
    "rating": 4.8,
    "reviewCount": 980,
    "location": "Al Mamsha, Hurghada",
    "distance": "5 km from downtown",
    "amenities": ["Golf Course", "Water Park", "Dive Center", "Kids Club"],
    "roomType": "Deluxe Sea View",
    "bedInfo": "1 King Bed",
    "cancellationPolicy": "Free cancellation",
    "isAllInclusive": true
  },
  {
    "id": "jaz_casa",
    "title": "Jaz Casa Del Mar Beach",
    "image": "https://picsum.photos/seed/jaz_casa_offer/800/600",
    "discount": "20% OFF",
    "price": "EGP 2,800",
    "originalPrice": "EGP 3,500",
    "featured": false,
    "rating": 4.7,
    "reviewCount": 450,
    "location": "Al Mamsha, Hurghada",
    "distance": "4 km from downtown",
    "amenities": ["All Inclusive", "Family Friendly", "Evening Entertainment"],
    "roomType": "Standard Room",
    "bedInfo": "2 Twin Beds",
    "cancellationPolicy": "Non-refundable",
    "isAllInclusive": true
  },
  {
    "id": "m2",
    "title": "Sunrise Royal Makadi Resort",
    "image": "https://picsum.photos/seed/makadi_offer/800/600",
    "discount": "Family Deal",
    "price": "EGP 3,200",
    "originalPrice": "EGP 4,200",
    "featured": false,
    "rating": 4.6,
    "reviewCount": 2100,
    "location": "Makadi Bay, Hurghada",
    "distance": "30 km from downtown",
    "amenities": ["Aqua Park", "7 A la Carte Restaurants", "Snorkeling"],
    "roomType": "Family Suite",
    "bedInfo": "1 King + 2 Twin Beds",
    "cancellationPolicy": "Free cancellation",
    "isAllInclusive": true
  }
]
```
