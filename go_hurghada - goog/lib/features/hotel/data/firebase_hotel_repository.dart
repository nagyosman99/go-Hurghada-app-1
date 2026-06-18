import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_hurghada/features/hotel/data/hotel_repository.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';

class FirebaseHotelRepository implements HotelRepository {
  final FirebaseFirestore _firestore;

  FirebaseHotelRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<HotelSearchResult>> searchHotels(
    String query, {
    DateTime? checkIn,
    DateTime? checkOut,
    int rooms = 1,
    int adults = 1,
    int children = 0,
  }) async {
    // In a real app, you'd might use Algolia or a more complex query.
    // For now, we'll fetch all and filter client-side or do a simple startAt query.
    // Simple implementation: Fetch all hotels and filter by name manually (not efficient for large DBs)

    final snapshot = await _firestore.collection('hotels').get();

    final hotels = snapshot.docs.map((doc) {
      final data = doc.data();
      // Ensure ID is set from doc ID if missing in data
      data['id'] = doc.id;
      return HotelDetails.fromMap(data);
    }).toList();

    // Filter by query — fall back to all hotels if no name/address match
    // (handles broad AI queries like 'budget', 'luxury', 'all-inclusive')
    List<HotelDetails> filtered;
    if (query.isEmpty) {
      filtered = hotels;
    } else {
      final queryLower = query.toLowerCase();
      filtered = hotels.where((h) {
        return h.name.toLowerCase().contains(queryLower) ||
            h.address.toLowerCase().contains(queryLower);
      }).toList();
      // If nothing matched by name/address, return all (generic AI query)
      if (filtered.isEmpty) {
        filtered = hotels;
      }
    }

    // Convert to Search Result
    return filtered
        .map(
          (h) => HotelSearchResult(
            id: h.id,
            name: h.name,
            address: h.address,
            rating: h.rating,
            pricePerNight: h.pricePerNight,
            imageUrl: h.imageUrl,
            amenities: h.amenities,
            isAllInclusive: h.isAllInclusive,
            discount: h.discount,
            originalPrice: h.originalPrice,
          ),
        )
        .toList();
  }

  @override
  Future<HotelDetails?> getHotelById(String id) async {
    final doc = await _firestore.collection('hotels').doc(id).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    data['id'] = doc.id;
    return HotelDetails.fromMap(data);
  }

  @override
  Future<HotelOffer?> getOfferById(String id) async {
    final doc = await _firestore.collection('offers').doc(id).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    data['id'] = doc.id;
    return HotelOffer.fromMap(data);
  }

  @override
  Future<List<Room>> getRoomsForHotel(String hotelId) async {
    final snapshot = await _firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('rooms')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Room.fromMap(data);
    }).toList();
  }
}
