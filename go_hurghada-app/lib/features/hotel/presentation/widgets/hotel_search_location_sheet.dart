import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';

class HotelSearchLocationSheet extends StatefulWidget {
  const HotelSearchLocationSheet({super.key});

  @override
  State<HotelSearchLocationSheet> createState() =>
      _HotelSearchLocationSheetState();
}

class _HotelSearchLocationSheetState extends State<HotelSearchLocationSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<HotelSearchResult> _allHotels = [];
  List<HotelSearchResult> _filteredHotels = [];
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadHotels();
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterHotels);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHotels() async {
    try {
      final repository = AppProvider.of(context).hotelRepository;
      final hotels = await repository.searchHotels('');
      if (mounted) {
        setState(() {
          _allHotels = hotels;
          _filteredHotels = hotels;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterHotels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHotels = _allHotels.where((hotel) {
        return hotel.name.toLowerCase().contains(query) ||
            hotel.address.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchHotelsHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                filled: true,
                fillColor:
                    Theme.of(context).inputDecorationTheme.fillColor ??
                    Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          const Divider(height: 1),

          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredHotels.isEmpty
                ? Center(
                    child: Text(
                      'No hotels found',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredHotels.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final hotel = _filteredHotels[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: const Icon(
                            Icons.hotel,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          hotel.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          hotel.address,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context, hotel.name);
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
