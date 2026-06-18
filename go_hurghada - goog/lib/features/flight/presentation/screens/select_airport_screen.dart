import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/config/constants/egypt_airports.dart';

class SelectAirportScreen extends StatefulWidget {
  final Function(Airport) onAirportSelected;

  const SelectAirportScreen({super.key, required this.onAirportSelected});

  @override
  State<SelectAirportScreen> createState() => _SelectAirportScreenState();
}

class _SelectAirportScreenState extends State<SelectAirportScreen> {
  List<Airport> _filteredAirports = EgyptAirports.airports;

  void _onSearchChanged(String query) {
    setState(() {
      _filteredAirports = EgyptAirports.searchAirports(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.selectAirport,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchPrompt,
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.grey),
                  onPressed: () {
                    // Clear search
                  },
                ),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Airport List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredAirports.length,
              itemBuilder: (context, index) {
                final airport = _filteredAirports[index];
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                    ),
                    child: const Icon(
                      Icons.flight_takeoff,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    airport.getLocalizedCity(AppLocalizations.of(context)!),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  subtitle: Text(
                    '${airport.getLocalizedName(AppLocalizations.of(context)!)} (${airport.code})',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                  ),
                  onTap: () {
                    widget.onAirportSelected(airport);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
