import 'package:dartz/dartz.dart';
import 'package:go_hurghada/features/flight/domain/entities/flight.dart';
import 'package:go_hurghada/features/flight/domain/entities/search_params.dart';

/// Repository interface for flight operations
abstract class FlightRepository {
  /// Search for flights based on search parameters
  Future<Either<String, List<Flight>>> searchFlights(SearchParams params);

  /// Get flights by specific route
  Future<Either<String, List<Flight>>> getFlightsByRoute(
    String origin,
    String destination,
  );
}
