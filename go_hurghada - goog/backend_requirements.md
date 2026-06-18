# Backend Data Requirements

This document outlines the data structures required for the Hotel, Room, and Offer entities in the application.

## 1. Hotel Model

**Endpoint Recommendation:** `/api/hotels` or `/api/hotels/{id}`

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `id` | `String` | Yes | Unique identifier for the hotel. |
| `name` | `String` | Yes | Name of the hotel. |
| `address` | `String` | Yes | Physical address of the hotel. |
| `rating` | `double` | Yes | Star rating (e.g., 4.5). |
| `pricePerNight` | `double` | Yes | Base price per night. |
| `imageUrl` | `String` | Yes | URL for the main cover image. |
| `photos` | `List<String>` | No | Gallery of additional photo URLs. Default is `[]`. |
| `amenities` | `List<String>` | Yes | List of provided amenities (e.g., "Pool", "WiFi"). |
| `description` | `String` | Yes | Detailed description of the hotel. |
| `discount` | `String` | No | Discount text (e.g., "20% OFF"). Nullable. |
| `originalPrice` | `double` | No | Original price before discount. Nullable. |
| `isAllInclusive` | `bool` | No | Whether the hotel is all-inclusive. Default `false`. |

### JSON Example
```json
{
  "id": "h123",
  "name": "Sunny Resort Hurghada",
  "address": "123 Beach Road, Hurghada",
  "rating": 4.8,
  "pricePerNight": 150.00,
  "imageUrl": "https://example.com/hotel_cover.jpg",
  "photos": [
    "https://example.com/photo1.jpg",
    "https://example.com/photo2.jpg"
  ],
  "amenities": ["Pool", "WiFi", "Gym", "Beach Access"],
  "description": "A beautiful resort right on the beach...",
  "discount": "10% OFF",
  "originalPrice": 165.00,
  "isAllInclusive": true
}
```

---

## 2. Room Model

**Context:** A Hotel contains a list of Rooms.
**Endpoint Recommendation:** `/api/hotels/{id}/rooms`

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `id` | `String` | Yes | Unique identifier for the room. |
| `hotelId` | `String` | Yes | ID of the hotel this room belongs to. |
| `name` | `String` | Yes | Name of the room (e.g., "Deluxe Ocean View"). |
| `type` | `String` | Yes | Type of room (e.g., "Single", "Double", "Suite"). |
| `price` | `double` | Yes | Price per night for this specific room. |
| `capacity` | `int` | Yes | Maximum number of guests. |
| `amenities` | `List<String>` | Yes | Room-specific amenities (e.g., "Balcony", "Mini Bar"). |
| `imageUrl` | `String` | Yes | URL for the room image. |

### JSON Example
```json
{
  "id": "r456",
  "hotelId": "h123",
  "name": "Deluxe Ocean View",
  "type": "Double",
  "price": 200.00,
  "capacity": 2,
  "amenities": ["Ocean View", "King Bed", "Balcony"],
  "imageUrl": "https://example.com/room_deluxe.jpg"
}
```

---

## 3. Offer Model

**Context:** Special offers or featured deals.

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `id` | `String` | Yes | Unique identifier for the offer. |
| `title` | `String` | Yes | Title of the offer (often the Hotel Name). |
| `image` | `String` | Yes | URL for the offer/hotel image. |
| `discount` | `String` | Yes | Discount text (e.g., "50% Off"). |
| `price` | `String` | Yes | Price string (e.g., "$100"). |
| `featured` | `bool` | No | Is this a featured offer? Default `false`. |
| `rating` | `double` | No | Rating. Default `4.5`. |
| `location` | `String` | No | Location string. Default "Hurghada, Egypt". |
| `amenities` | `List<String>` | No | List of amenities included. |
| `originalPrice` | `String` | No | Original price string. Nullable. |
| `reviewCount` | `int` | No | Number of reviews. Default `100`. |
| `distance` | `String` | No | Distance description. Default "5 km from downtown". |
| `roomType` | `String` | No | Type of room included. Default "Standard Room". |
| `bedInfo` | `String` | No | Bed information. Default "1 King Bed". |
| `cancellationPolicy`| `String` | No | Cancellation policy. Default "Free cancellation". |
| `isAllInclusive` | `bool` | No | Is it all-inclusive? Default `true`. |

### JSON Example
```json
{
  "id": "o789",
  "title": "Grand Hotel Special",
  "image": "https://example.com/offer_image.jpg",
  "discount": "50% Off",
  "price": "$120",
  "featured": true,
  "rating": 4.7,
  "location": "Makadi Bay, Hurghada",
  "amenities": ["Water Park", "All Inclusive"],
  "originalPrice": "$240",
  "reviewCount": 250,
  "distance": "20 km from downtown",
  "roomType": "Suite",
  "bedInfo": "2 Queen Beds",
  "cancellationPolicy": "Free cancellation until 24h",
  "isAllInclusive": true
}
```
