import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/flight/data/amadeus_flight_service.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';

/// Bottom sheet for selecting an airport
class AirportSelector extends StatefulWidget {
  final Function(Map<String, String>) onAirportSelected;

  const AirportSelector({super.key, required this.onAirportSelected});

  @override
  State<AirportSelector> createState() => _AirportSelectorState();
}

class _AirportSelectorState extends State<AirportSelector> {
  List<Map<String, String>> _airports = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late AmadeusFlightService _flightService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _flightService = AppProvider.of(context, listen: false).flightSearchViewModel.flightService;
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length < 2) {
        setState(() {
          _airports = [];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final results = await _flightService.searchAirports(query);
        setState(() {
          _airports = results;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXLarge),
          topRight: Radius.circular(AppDimensions.radiusXLarge),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Airport',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.headlineMedium?.color,
                  ),
                ),
                const SizedBox(height: 16),

                // Search Field
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search by city or airport code',
                    prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                    suffixIcon: _isLoading 
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                    filled: true,
                    fillColor: theme.cardColor,
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
              ],
            ),
          ),

          // Airport List
          Expanded(
            child: _airports.isEmpty && !_isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flight_takeoff, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.length < 2 
                          ? 'Type at least 2 characters'
                          : 'No airports found',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _airports.length,
                  itemBuilder: (context, index) {
                    final airport = _airports[index];
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
                        airport['city'] ?? '',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                      subtitle: Text(
                        '${airport['name']} (${airport['code']})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
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
