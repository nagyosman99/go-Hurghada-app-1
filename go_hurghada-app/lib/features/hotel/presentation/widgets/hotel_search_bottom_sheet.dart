import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class HotelSearchBottomSheet extends StatefulWidget {
  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;
  final int initialAdults;
  final int initialChildren;
  final int initialRooms;
  final Function(DateTime?, DateTime?, int, int, int)? onApply;

  const HotelSearchBottomSheet({
    super.key,
    this.initialCheckIn,
    this.initialCheckOut,
    this.initialAdults = 2,
    this.initialChildren = 0,
    this.initialRooms = 1,
    this.onApply,
  });

  @override
  State<HotelSearchBottomSheet> createState() => _HotelSearchBottomSheetState();
}

class _HotelSearchBottomSheetState extends State<HotelSearchBottomSheet> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _adults = 2;
  int _children = 0;
  int _rooms = 1;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      if (widget.onApply != null) {
        _checkIn = widget.initialCheckIn;
        _checkOut = widget.initialCheckOut;
        _adults = widget.initialAdults;
        _children = widget.initialChildren;
        _rooms = widget.initialRooms;
      } else {
        // Initialize local state from ViewModel
        final state = AppProvider.of(context).hotelSearchViewModel.state;
        _checkIn = state.checkIn;
        _checkOut = state.checkOut;
        _adults = state.adults;
        _children = state.children;
        _rooms = state.rooms;
      }
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (_checkIn ?? DateTime.now())
          : (_checkOut ??
                _checkIn?.add(const Duration(days: 1)) ??
                DateTime.now().add(const Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          // Auto-set checkout to next day if not set or before checkin
          if (_checkOut == null || _checkOut!.isBefore(picked)) {
            _checkOut = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  void _updateSearch() {
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.pleaseSelectDates ??
                'Please select check-in and check-out dates',
          ),
        ),
      );
      return;
    }

    if (_checkOut!.isBefore(_checkIn!) ||
        _checkOut!.isAtSameMomentAs(_checkIn!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.errorGeneric ??
                'Check-out must be after check-in',
          ),
        ),
      );
      return;
    }

    if (widget.onApply != null) {
      widget.onApply!(_checkIn, _checkOut, _rooms, _adults, _children);
    } else {
      // Update global state via ViewModel
      final viewModel = AppProvider.of(context).hotelSearchViewModel;
      viewModel.updateDates(_checkIn, _checkOut);
      viewModel.updateOccupancy(
        rooms: _rooms,
        adults: _adults,
        children: _children,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.updateSearch ?? 'Update Search',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date Selection
          Row(
            children: [
              Expanded(
                child: _DateSelector(
                  label: AppLocalizations.of(context)?.checkIn ?? 'Check-in',
                  date: _checkIn,
                  onTap: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DateSelector(
                  label: AppLocalizations.of(context)?.checkOut ?? 'Check-out',
                  date: _checkOut,
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Guests & Rooms
          Text(
            AppLocalizations.of(context)?.guestsRooms ?? 'Guests & Rooms',
            style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 16),

          _CounterRow(
            label: AppLocalizations.of(context)?.rooms ?? 'Rooms',
            icon: Icons.hotel,
            count: _rooms,
            onDecrement: () => setState(() {
              if (_rooms > 1) _rooms--;
            }),
            onIncrement: () => setState(() {
              if (_rooms < 10) _rooms++;
            }),
          ),
          _CounterRow(
            label: AppLocalizations.of(context)?.adults ?? 'Adults',
            icon: Icons.person,
            count: _adults,
            onDecrement: () => setState(() {
              if (_adults > 1) _adults--;
            }),
            onIncrement: () => setState(() {
              if (_adults < 20) _adults++;
            }),
          ),
          _CounterRow(
            label: AppLocalizations.of(context)?.children ?? 'Children',
            icon: Icons.child_care,
            count: _children,
            onDecrement: () => setState(() {
              if (_children > 0) _children--;
            }),
            onIncrement: () => setState(() {
              if (_children < 10) _children++;
            }),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _updateSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)?.searchHotels ?? 'Search Hotels',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateSelector({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  date != null
                      ? DateFormat('MMM dd, yyyy').format(date!)
                      : (AppLocalizations.of(context)?.selectDates ??
                            'Select Date'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CounterRow({
    required this.label,
    required this.icon,
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.primary,
            iconSize: 28,
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.primary,
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}
