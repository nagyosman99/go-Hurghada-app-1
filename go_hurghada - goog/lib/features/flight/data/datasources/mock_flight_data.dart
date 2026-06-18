import 'package:go_hurghada/features/flight/domain/entities/flight.dart';

class MockFlightData {
  static List<Flight> getMockFlights() {
    return [
      // Cairo to Hurghada
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
      ),
      Flight(
        id: '2',
        airlineCode: 'SM',
        airlineName: 'Air Cairo',
        origin: 'CAI',
        destination: 'HRG',
        departureTime: DateTime.now().add(const Duration(days: 1, hours: 8)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
        durationMinutes: 60,
        stops: 0,
        price: 1200.0,
        currency: 'EGP',
        bookingUrl: 'https://www.aircairo.com',
        flightNumber: 'SM 456',
        aircraftType: 'A320',
      ),
      Flight(
        id: '3',
        airlineCode: 'NP',
        airlineName: 'Nile Air',
        origin: 'CAI',
        destination: 'HRG',
        departureTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 11)),
        durationMinutes: 60,
        stops: 0,
        price: 1350.0,
        currency: 'EGP',
        bookingUrl: 'https://www.nileair.com',
        flightNumber: 'NP 789',
        aircraftType: 'A320',
      ),

      // Cairo to Sharm El Sheikh
      Flight(
        id: '4',
        airlineCode: 'MS',
        airlineName: 'EgyptAir',
        origin: 'CAI',
        destination: 'SSH',
        departureTime: DateTime.now().add(const Duration(days: 1, hours: 7)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 8)),
        durationMinutes: 60,
        stops: 0,
        price: 1600.0,
        currency: 'EGP',
        bookingUrl: 'https://www.egyptair.com',
        flightNumber: 'MS 234',
        aircraftType: 'A320',
      ),
      Flight(
        id: '5',
        airlineCode: 'SM',
        airlineName: 'Air Cairo',
        origin: 'CAI',
        destination: 'SSH',
        departureTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
        durationMinutes: 60,
        stops: 0,
        price: 1300.0,
        currency: 'EGP',
        bookingUrl: 'https://www.aircairo.com',
        flightNumber: 'SM 567',
        aircraftType: 'A320',
      ),

      // Cairo to Luxor
      Flight(
        id: '6',
        airlineCode: 'MS',
        airlineName: 'EgyptAir',
        origin: 'CAI',
        destination: 'LXR',
        departureTime: DateTime.now().add(
          const Duration(days: 1, hours: 6, minutes: 30),
        ),
        arrivalTime: DateTime.now().add(
          const Duration(days: 1, hours: 7, minutes: 30),
        ),
        durationMinutes: 60,
        stops: 0,
        price: 1400.0,
        currency: 'EGP',
        bookingUrl: 'https://www.egyptair.com',
        flightNumber: 'MS 345',
        aircraftType: 'A320',
      ),

      // Cairo to Aswan
      Flight(
        id: '7',
        airlineCode: 'MS',
        airlineName: 'EgyptAir',
        origin: 'CAI',
        destination: 'ASW',
        departureTime: DateTime.now().add(
          const Duration(days: 1, hours: 8, minutes: 30),
        ),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
        durationMinutes: 90,
        stops: 0,
        price: 1800.0,
        currency: 'EGP',
        bookingUrl: 'https://www.egyptair.com',
        flightNumber: 'MS 456',
        aircraftType: 'A320',
      ),

      // Hurghada to Cairo (Return flights)
      Flight(
        id: '8',
        airlineCode: 'MS',
        airlineName: 'EgyptAir',
        origin: 'HRG',
        destination: 'CAI',
        departureTime: DateTime.now().add(const Duration(days: 3, hours: 18)),
        arrivalTime: DateTime.now().add(const Duration(days: 3, hours: 19)),
        durationMinutes: 60,
        stops: 0,
        price: 1500.0,
        currency: 'EGP',
        bookingUrl: 'https://www.egyptair.com',
        flightNumber: 'MS 124',
        aircraftType: 'A320',
      ),
      Flight(
        id: '9',
        airlineCode: 'SM',
        airlineName: 'Air Cairo',
        origin: 'HRG',
        destination: 'CAI',
        departureTime: DateTime.now().add(const Duration(days: 3, hours: 20)),
        arrivalTime: DateTime.now().add(const Duration(days: 3, hours: 21)),
        durationMinutes: 60,
        stops: 0,
        price: 1200.0,
        currency: 'EGP',
        bookingUrl: 'https://www.aircairo.com',
        flightNumber: 'SM 457',
        aircraftType: 'A320',
      ),
    ];
  }

  static List<Flight> getFlightsByRoute(String origin, String destination) {
    return getMockFlights()
        .where(
          (flight) =>
              flight.origin == origin && flight.destination == destination,
        )
        .toList();
  }

  static List<Flight> sortFlightsByCheapest(List<Flight> flights) {
    final sorted = List<Flight>.from(flights);
    sorted.sort((a, b) => a.price.compareTo(b.price));
    return sorted;
  }

  static List<Flight> sortFlightsByFastest(List<Flight> flights) {
    final sorted = List<Flight>.from(flights);
    sorted.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
    return sorted;
  }

  static List<Flight> sortFlightsByBest(List<Flight> flights) {
    // Best = combination of price and duration
    final sorted = List<Flight>.from(flights);
    sorted.sort((a, b) {
      final scoreA = (a.price / 100) + (a.durationMinutes / 10);
      final scoreB = (b.price / 100) + (b.durationMinutes / 10);
      return scoreA.compareTo(scoreB);
    });
    return sorted;
  }
}
