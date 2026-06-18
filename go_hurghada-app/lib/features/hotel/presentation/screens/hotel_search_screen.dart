import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/constants/hurghada_regions.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/hotel/presentation/viewmodels/hotel_search_viewmodel.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/search/date_selector.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/search/guest_selector.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/config/routes/app_router.dart';

class HotelSearchScreen extends StatelessWidget {
  final String? initialLocation;

  const HotelSearchScreen({super.key, this.initialLocation});

  @override
  Widget build(BuildContext context) {
    final viewModel = AppProvider.of(context).hotelSearchViewModel;

    // Initialize search if it's the first time or if initialLocation is provided
    if (initialLocation != null && viewModel.state.query != initialLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.updateQuery(initialLocation!);
      });
    } else if (viewModel.state.query.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.updateQuery(HurghadaRegions.defaultRegion);
      });
    }

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final state = viewModel.state;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)?.findHotels ??
                  'Find Hotels in Hurghada',
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLocationDropdown(context, viewModel, state),
                const SizedBox(height: 16),
                _buildDateSelectors(context, viewModel, state),
                const SizedBox(height: 16),
                _buildGuestSelector(viewModel, state),
                const SizedBox(height: 24),
                _buildSearchButton(context, viewModel, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationDropdown(
    BuildContext context,
    HotelSearchViewModel viewModel,
    HotelSearchState state,
  ) {
    return DropdownButtonFormField<String>(
      value: state.query.isEmpty
          ? HurghadaRegions.defaultRegion
          : state.query,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)?.location ?? 'Location',
        prefixIcon: const Icon(Icons.location_on),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: HurghadaRegions.all.map((String region) {
        return DropdownMenuItem<String>(value: region, child: Text(region));
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          viewModel.updateQuery(newValue);
        }
      },
    );
  }

  Widget _buildDateSelectors(
    BuildContext context,
    HotelSearchViewModel viewModel,
    HotelSearchState state,
  ) {
    return Row(
      children: [
        Expanded(
          child: DateSelector(
            label: AppLocalizations.of(context)?.checkIn ?? 'Check-in',
            date: state.checkIn,
            onTap: () => _selectDate(context, viewModel, true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DateSelector(
            label: AppLocalizations.of(context)?.checkOut ?? 'Check-out',
            date: state.checkOut,
            onTap: () => _selectDate(context, viewModel, false),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    HotelSearchViewModel viewModel,
    bool isCheckIn,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (viewModel.state.checkIn ?? DateTime.now())
          : (viewModel.state.checkOut ??
                (viewModel.state.checkIn?.add(const Duration(days: 1)) ??
                    DateTime.now().add(const Duration(days: 1)))),
      firstDate: isCheckIn
          ? DateTime.now()
          : (viewModel.state.checkIn?.add(const Duration(days: 1)) ??
                DateTime.now().subtract(
                  const Duration(days: 1),
                )), // Fixed: Ensure firstDate is not after initialDate
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      if (isCheckIn) {
        final checkOut = viewModel.state.checkOut;
        DateTime? newCheckOut = checkOut;
        if (checkOut == null ||
            checkOut.isBefore(picked) ||
            checkOut.isAtSameMomentAs(picked)) {
          newCheckOut = picked.add(const Duration(days: 1));
        }
        viewModel.updateDates(picked, newCheckOut);
      } else {
        viewModel.updateDates(viewModel.state.checkIn, picked);
      }
    }
  }

  Widget _buildGuestSelector(
    HotelSearchViewModel viewModel,
    HotelSearchState state,
  ) {
    return GuestSelector(
      rooms: state.rooms,
      adults: state.adults,
      children: state.children,
      onRoomsChanged: (value) => viewModel.updateOccupancy(rooms: value),
      onAdultsChanged: (value) => viewModel.updateOccupancy(adults: value),
      onChildrenChanged: (value) => viewModel.updateOccupancy(children: value),
    );
  }

  Widget _buildSearchButton(
    BuildContext context,
    HotelSearchViewModel viewModel,
    HotelSearchState state,
  ) {
    return ElevatedButton(
      onPressed: () => _searchHotels(context, viewModel, state),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        AppLocalizations.of(context)?.searchHotels ?? 'Search Hotels',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _searchHotels(
    BuildContext context,
    HotelSearchViewModel viewModel,
    HotelSearchState state,
  ) {
    if (_validateSearch(context, state)) {
      context.push(AppRouter.hotelResults);
    }
  }

  bool _validateSearch(BuildContext context, HotelSearchState state) {
    if (state.checkIn == null) {
      _showSnackBar(
        context,
        AppLocalizations.of(context)?.pleaseSelectCheckIn ??
            'Please select check-in date',
      );
      return false;
    }

    if (state.checkOut == null) {
      _showSnackBar(
        context,
        AppLocalizations.of(context)?.pleaseSelectCheckOut ??
            'Please select check-out date',
      );
      return false;
    }

    if (state.checkOut!.isBefore(state.checkIn!) ||
        state.checkOut!.isAtSameMomentAs(state.checkIn!)) {
      _showSnackBar(
        context,
        AppLocalizations.of(context)?.checkOutAfterCheckIn ??
            'Check-out must be after check-in',
      );
      return false;
    }

    return true;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
