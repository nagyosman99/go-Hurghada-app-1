# Go Hurghada - All Data Models Examples


---

## 1. Flight Model


```dart
Flight(
  id: '1',
  airlineCode: 'MS',
  airlineName: 'EgyptAir',
  origin: 'CAI',
  destination: 'HRG',
  departureTime: DateTime.now().add(const Duration(days: 1, hours: 6)),
  arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 7)),
  durationMinutes: 60,
  stops: 0,
  price: 1500.0,
  currency: 'EGP',
  bookingUrl: 'https://www.egyptair.com',
  flightNumber: 'MS 123',
  aircraftType: 'A320',
)
```

**Fields:**
- `id`: Unique flight identifier
- `airlineCode`: IATA airline code (e.g., MS, SM, NP)
- `airlineName`: Full airline name
- `origin`: Origin airport code (IATA)
- `destination`: Destination airport code (IATA)
- `departureTime`: Flight departure date/time
- `arrivalTime`: Flight arrival date/time
- `durationMinutes`: Flight duration in minutes
- `stops`: Number of stops (0 for direct)
- `price`: Ticket price
- `currency`: Currency code
- `bookingUrl`: External booking URL
- `flightNumber`: Flight number (optional)
- `aircraftType`: Aircraft model (optional)

---

## 2. Hotel Model


```dart
Hotel(
  id: 'g1',
  name: 'Sheraton Miramar Resort El Gouna',
  address: 'El Gouna, Red Sea',
  rating: 4.7,
  pricePerNight: 200.0,
  imageUrl: 'https://picsum.photos/seed/sheraton/800/600',
  photos: [
    'https://picsum.photos/seed/sheraton1/800/600',
    'https://picsum.photos/seed/sheraton2/800/600',
    'https://picsum.photos/seed/sheraton3/800/600',
  ],
  amenities: [
    'Private Beach',
    'Pools',
    'Spa',
    'Water Sports',
    'Free WiFi',
    'Gym',
    'Kids Club',
    'Restaurants',
    'Bar',
    'Room Service',
  ],
  description: 'Designed by Michael Graves, this resort offers a unique blend of Arabic and Nubian styles. Spread across nine islands, the resort features spacious rooms with stunning views of the lagoons and private beaches.',
  discount: '20% OFF',
  originalPrice: 250.0,
  isAllInclusive: true,
)
```

**Fields:**
- `id`: Unique hotel identifier
- `name`: Hotel name
- `address`: Full address/location
- `rating`: Star rating (0.0 - 5.0)
- `pricePerNight`: Base price per night
- `imageUrl`: Main hotel image URL
- `photos`: Gallery of hotel photos (default: empty list)
- `amenities`: List of hotel facilities
- `description`: Hotel description
- `discount`: Discount text (optional, e.g., "20% OFF")
- `originalPrice`: Original price before discount (optional)
- `isAllInclusive`: Whether all-inclusive package (default: false)

---

## 3. Room Model


```dart
Room(
  id: 'g1-r1',
  hotelId: 'g1',
  name: 'Classic Room',
  type: 'Double',
  price: 200.0,
  capacity: 2,
  amenities: ['Lagoon View', 'Balcony', 'Mini Bar'],
  imageUrl: 'https://picsum.photos/seed/room1/800/600',
)
```

**Fields:**
- `id`: Unique room identifier
- `hotelId`: Associated hotel ID
- `name`: Room name/category
- `type`: Room type (Double, Twin, Suite, Family, Villa)
- `price`: Price per night
- `capacity`: Maximum number of guests
- `amenities`: List of room amenities
- `imageUrl`: Room image URL

---

## 4. Activity Model


```dart
ActivityModel(
  id: '1',
  title: 'Dolphin House Snorkeling',
  description: 'Experience an unforgettable trip with two long snorkeling stops in the Red Sea.',
  fullDescription: 'Embark on an extraordinary journey to the Dolphin House, one of the Red Sea\'s most spectacular snorkeling destinations. This full-day adventure offers you the unique opportunity to swim alongside wild dolphins in their natural habitat...',
  price: 35.0,
  location: 'Hurghada Marina',
  duration: '7 hours',
  rating: 4.8,
  images: ['assets/diving.jpg', 'assets/water_sports.jpg'],
  category: 'Water Sports',
  availableDates: [
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 3)),
    // ... up to 30 days
  ],
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
  pickupInfo: PickupInfoModel(
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
)
```

**Fields:**
- `id`: Unique activity identifier
- `title`: Activity title
- `description`: Short description
- `fullDescription`: Detailed description
- `price`: Activity price per person
- `location`: Starting location
- `duration`: Activity duration
- `rating`: Customer rating (0.0 - 5.0)
- `images`: List of activity images
- `category`: Category (Water Sports, Safari, Boat Trips, Family, Luxury)
- `availableDates`: List of available dates
- `ageRequirement`: Age requirement (e.g., "5+", "12+", "All ages")
- `pickupIncluded`: Whether hotel pickup is included
- `languages`: Available tour languages
- `instantConfirmation`: Whether booking is instantly confirmed
- `freeCancellation`: Whether free cancellation is available
- `whatsIncluded`: List of included items/services
- `whatsNotIncluded`: List of excluded items/services
- `pickupInfo`: Pickup information (optional)

---

## 5. Pickup Info Model

**Location:** `lib/features/activities/data/models/pickup_info_model.dart`

```dart
PickupInfoModel(
  timeWindow: '7:00 AM - 8:30 AM',
  locations: [
    'All hotels in Hurghada',
    'Makadi Bay',
    'Sahl Hasheesh',
    'El Gouna (+\$5)',
  ],
  contactMethod: 'WhatsApp',
  contactTiming: '24 hours before the trip',
)
```

**Fields:**
- `timeWindow`: Pickup time range
- `locations`: List of pickup locations
- `contactMethod`: How customer will be contacted
- `contactTiming`: When customer will be contacted

---

## 6. Activity Booking Model


```dart
BookingModel(
  bookingId: 'BK123456',
  activityId: '1',
  selectedDate: DateTime(2025, 12, 15),
  persons: 2,
  totalPrice: 70.0,
  status: 'confirmed', // 'confirmed', 'pending', 
)
```

**Fields:**
- `bookingId`: Unique booking identifier
- `activityId`: Associated activity ID
- `selectedDate`: Selected activity date
- `persons`: Number of persons
- `totalPrice`: Total booking price
- `status`: Booking status (confirmed, pending, cancelled)

---

## 7. Hotel Booking Model

**Location:** `lib/features/booking/domain/models/booking.dart`

```dart
Booking(
  id: 'BK789012',
  hotelId: 'g1',
  hotelName: 'Sheraton Miramar Resort El Gouna',
  roomId: 'g1-r1',
  roomName: 'Classic Room',
  checkInDate: DateTime(2025, 12, 20),
  checkOutDate: DateTime(2025, 12, 25),
  totalPrice: 1000.0,
  guestName: 'John Doe',
  guestEmail: 'john.doe@example.com',
  guestPhone: '+20 123 456 7890',
  adults: 2,
  children: 1,
  roomsCount: 1,
  status: 'confirmed', // 'confirmed', 'cancelled', 'pending'
  createdAt: DateTime.now(),
)
```

**Fields:**
- `id`: Unique booking identifier
- `hotelId`: Associated hotel ID
- `hotelName`: Hotel name
- `roomId`: Associated room ID
- `roomName`: Room name
- `checkInDate`: Check-in date
- `checkOutDate`: Check-out date
- `totalPrice`: Total booking price
- `guestName`: Guest full name
- `guestEmail`: Guest email
- `guestPhone`: Guest phone number
- `adults`: Number of adults (default: 2)
- `children`: Number of children (default: 0)
- `roomsCount`: Number of rooms (default: 1)
- `status`: Booking status
- `createdAt`: Booking creation timestamp

---

## 8. Location Model (Home)

**Location:** `lib/features/home/domain/models/travel_models.dart`

```dart
LocationModel(
  id: 'loc1',
  name: 'El Gouna',
  image: 'assets/elgouna.jpg',
)
```

**Fields:**
- `id`: Unique location identifier
- `name`: Location name
- `image`: Location image path

---

## 9. Offer Model (Home)


```dart
OfferModel(
  id: 'offer1',
  title: 'Steigenberger ALDAU Beach',
  image: 'assets/aldau.jpg',
  discount: '20% OFF',
  price: '3500 EGP',
  originalPrice: '4375 EGP',
  featured: true,
  rating: 4.8,
  location: 'Al Mamsha, Hurghada',
  amenities: ['Golf Course', 'Water Park', 'Dive Center', 'Kids Club'],
  reviewCount: 250,
  distance: '15 km from downtown',
  roomType: 'Deluxe Sea View',
  bedInfo: '1 King Bed',
  cancellationPolicy: 'Free cancellation',
  isAllInclusive: true,
)
```

**Fields:**
- `id`: Unique offer identifier
- `title`: Offer title (usually hotel name)
- `image`: Offer image path
- `discount`: Discount text
- `price`: Display price
- `originalPrice`: Original price before discount (optional)
- `featured`: Whether featured offer (default: false)
- `rating`: Rating (default: 4.5)
- `location`: Location (default: 'Hurghada, Egypt')
- `amenities`: List of amenities (default: ['Water Park', 'Family Friendly', 'All Inclusive'])
- `reviewCount`: Number of reviews (default: 100)
- `distance`: Distance from downtown (default: '5 km from downtown')
- `roomType`: Room type (default: 'Standard Room')
- `bedInfo`: Bed information (default: '1 King Bed')
- `cancellationPolicy`: Cancellation policy (default: 'Free cancellation')
- `isAllInclusive`: Whether all-inclusive (default: true)

---

## 10. Category Model (Home)


```dart
CategoryModel(
  id: 'cat1',
  name: 'Hotels',
  imagePath: 'assets/hotel_icon.png',
  backgroundColor: Colors.blue,
  page: HotelSearchScreen(),
)
```

**Fields:**
- `id`: Unique category identifier
- `name`: Category name
- `imagePath`: Asset image path
- `backgroundColor`: Card background color
- `page`: Destination screen widget

---

## 11. Activity Model (Home - Simple)


```dart
ActivityModel(
  id: 'act1',
  name: 'Diving',
  image: 'assets/diving.jpg',
  description: 'Explore the underwater world',
)
```

**Fields:**
- `id`: Unique activity identifier
- `name`: Activity name
- `image`: Activity image path
- `description`: Activity description (optional)

---

## Common Airport Codes

**Egyptian Airports:**
- `CAI` - Cairo International Airport
- `HRG` - Hurghada International Airport
- `SSH` - Sharm El Sheikh International Airport
- `LXR` - Luxor International Airport
- `ASW` - Aswan International Airport

---

## Common Airline Codes

**Egyptian Airlines:**
- `MS` - EgyptAir
- `SM` - Air Cairo
- `NP` - Nile Air

---

## Popular Hurghada Locations

1. **El Gouna** - Luxury resort town
2. **Makadi Bay** - Family-friendly resort area
3. **Soma Bay** - Premium beach destination
4. **Sahl Hasheesh** - Exclusive resort community
5. **Al Mamsha** - Waterfront promenade area
6. **Hurghada City Center** - Downtown area

---

## Activity Categories

1. **Water Sports** - Snorkeling, diving, water activities
2. **Safari** - Desert adventures, quad biking
3. **Boat Trips** - Island tours, yacht trips


---

## Booking Status Values

- `confirmed` - Booking is confirmed
- `pending` - Booking is pending confirmation

---

## Notes

- All prices are typically in **EGP** (Egyptian Pounds) unless specified
- Dates use Dart's `DateTime` class
- Images can be either asset paths (`assets/...`) or URLs (`https://...`)
- All models use **Freezed** for immutability and code generation
- Optional fields are marked with `?` in Dart
- Default values are specified with `@Default(value)` annotation
