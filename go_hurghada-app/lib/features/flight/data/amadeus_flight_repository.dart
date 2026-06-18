import 'package:dartz/dartz.dart';
import 'package:go_hurghada/features/flight/data/amadeus_flight_service.dart';
import 'package:go_hurghada/features/flight/data/datasources/mock_flight_data.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/flight/domain/entities/search_params.dart';
import 'package:go_hurghada/features/flight/domain/repositories/flight_repository.dart';

class AmadeusFlightRepository implements FlightRepository {
  // ignore: unused_field
  final AmadeusFlightService _amadeusService;

  AmadeusFlightRepository(this._amadeusService);

  @override
  Future<Either<String, List<Flight>>> searchFlights(SearchParams params) async {
    // Return only domestic Egypt mock flights directly
    final mockFlights = MockFlightData.getFlightsByRoute(params.origin, params.destination);
    if (mockFlights.isNotEmpty) {
      return Right(mockFlights);
    }
    return const Left('No flights found for this route (Egypt domestic flights only)');
  }

  @override
  Future<Either<String, List<Flight>>> getFlightsByRoute(String origin, String destination) async {
    // Return only domestic Egypt mock return flights directly
    final mockFlights = MockFlightData.getFlightsByRoute(origin, destination);
    if (mockFlights.isNotEmpty) {
      return Right(mockFlights);
    }
    return const Left('No return flights found (Egypt domestic flights only)');
  }
}
