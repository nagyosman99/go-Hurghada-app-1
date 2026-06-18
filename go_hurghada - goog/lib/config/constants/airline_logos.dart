class AirlineLogos {
  // Mapping airline codes to their logo asset paths
  static const Map<String, String> _logoMap = {
    'MS': 'assets/logos/egyptair-logo.png',
    'SM': 'assets/logos/air-cairo-logo-tail.png',
    'NP': 'assets/logos/nile-air-logo.png',
  };

  /// Returns the asset path for the given [airlineCode] or null if not available.
  static String? getLogoPath(String airlineCode) => _logoMap[airlineCode];

  /// Checks whether a logo exists for the given [airlineCode].
  static bool hasLogo(String airlineCode) => _logoMap.containsKey(airlineCode);
}
