/// Hurghada regions and areas for hotel location selection
class HurghadaRegions {
  HurghadaRegions._(); // Private constructor to prevent instantiation

  /// All available Hurghada regions
  static const List<String> all = [
    'All Hurghada',
    'El Gouna',
    'Makadi Bay',
    'Soma Bay',
    'Sahl Hasheesh',
    'Hurghada City Center',
    'Hurghada Marina',
    'Al Mamsha',
  ];

  /// Default region for initial selection
  static const String defaultRegion = 'All Hurghada';

  /// Check if a region is valid
  static bool isValid(String region) {
    return all.contains(region);
  }

  /// Get display name for a region
  static String getDisplayName(String region) {
    return region;
  }
}
