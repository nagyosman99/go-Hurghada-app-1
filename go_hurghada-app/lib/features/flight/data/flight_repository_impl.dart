import 'package:dartz/dartz.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/flight/domain/entities/search_params.dart';
import 'package:go_hurghada/features/flight/domain/repositories/flight_repository.dart';
import 'datasources/mock_flight_data.dart';

/// Mock implementation of [FlightRepository] using local data.
class FlightRepositoryImpl implements FlightRepository {
  @override
  Future<Either<String, List<Flight>>> searchFlights(
    SearchParams params,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Get flights for the route
      final flights = MockFlightData.getFlightsByRoute(
        params.origin,
        params.destination,
      );

      if (flights.isEmpty) {
        return const Left('No flights found for this route');
      }

      // Sort by best (default)
      final sortedFlights = MockFlightData.sortFlightsByBest(flights);

      return Right(sortedFlights);
    } catch (e) {
      return Left('Error searching flights: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<Flight>>> getFlightsByRoute(
    String origin,
    String destination,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final flights = MockFlightData.getFlightsByRoute(origin, destination);

      if (flights.isEmpty) {
        return const Left('No flights found for this route');
      }

      return Right(flights);
    } catch (e) {
      return Left('Error getting flights: ${e.toString()}');
    }
  }
}
