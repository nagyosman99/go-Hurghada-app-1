class AppConstants {
  // App Info
  static const String appName = 'Go Hurghadda';
  static const String appVersion = '1.0.0';

  // API Endpoints (Future Use)
  static const String searchFlightsEndpoint = '/searchFlights';
  static const String getCityCodesEndpoint = '/getCityCodes';

  // Date Formats
  static const String displayDateFormat = 'dd-MM-yyyy';
  static const String apiDateFormat = 'yyyy-MM-dd';

  // Passenger Limits
  static const int minPassengers = 1;
  static const int maxPassengers = 9;

  // Travel Classes
  static const List<String> travelClasses = [
    'Economy',
    'Premium Economy',
    'Business',
    'First Class',
  ];

  // Trip Types
  static const String oneWay = 'One Way';
  static const String roundTrip = 'Round Trip';

  // Sort Options
  static const String sortByCheapest = 'Cheapest';
  static const String sortByFastest = 'Fastest';
  static const String sortByBest = 'Best';
}
