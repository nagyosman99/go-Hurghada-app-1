import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class Airport {
  final String code;
  final String name;
  final String city;

  const Airport({required this.code, required this.name, required this.city});

  String getLocalizedName(AppLocalizations l10n) {
    switch (code) {
      case 'CAI':
        return l10n.cairoAirport;
      case 'HRG':
        return l10n.hurghadaAirport;
      case 'SSH':
        return l10n.sharmElSheikhAirport;
      case 'LXR':
        return l10n.luxorAirport;
      case 'ASW':
        return l10n.aswanAirport;
      case 'ALY':
        return l10n.elNouzhaAirport;
      case 'MUH':
        return l10n.marsaAlamAirport;
      case 'SPX':
        return l10n.sphinxAirport;
      default:
        return name;
    }
  }

  String getLocalizedCity(AppLocalizations l10n) {
    switch (code) {
      case 'CAI':
        return l10n.cairo;
      case 'HRG':
        return l10n.hurghada;
      case 'SSH':
        return l10n.sharmElSheikh;
      case 'LXR':
        return l10n.luxor;
      case 'ASW':
        return l10n.aswan;
      case 'ALY':
        return l10n.alexandria;
      case 'MUH':
        return l10n.marsaAlam;
      case 'SPX':
        return l10n.giza;
      default:
        return city;
    }
  }
}

class EgyptAirports {
  static const List<Airport> airports = [
    Airport(code: 'CAI', name: 'Cairo International Airport', city: 'Cairo'),
    Airport(
      code: 'HRG',
      name: 'Hurghada International Airport',
      city: 'Hurghada',
    ),
    Airport(
      code: 'SSH',
      name: 'Sharm El Sheikh International Airport',
      city: 'Sharm El Sheikh',
    ),
    Airport(code: 'LXR', name: 'Luxor International Airport', city: 'Luxor'),
    Airport(code: 'ASW', name: 'Aswan International Airport', city: 'Aswan'),
    Airport(code: 'ALY', name: 'El Nouzha Airport', city: 'Alexandria'),
    Airport(
      code: 'MUH',
      name: 'Marsa Alam International Airport',
      city: 'Marsa Alam',
    ),
    Airport(code: 'SPX', name: 'Sphinx International Airport', city: 'Giza'),
  ];

  static Airport? getAirportByCode(String code) {
    try {
      return airports.firstWhere((airport) => airport.code == code);
    } catch (e) {
      return null;
    }
  }

  static List<Airport> searchAirports(String query) {
    if (query.isEmpty) return airports;

    final lowerQuery = query.toLowerCase();
    return airports.where((airport) {
      return airport.code.toLowerCase().contains(lowerQuery) ||
          airport.name.toLowerCase().contains(lowerQuery) ||
          airport.city.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
