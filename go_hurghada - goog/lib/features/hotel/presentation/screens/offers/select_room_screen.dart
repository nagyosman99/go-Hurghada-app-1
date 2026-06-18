import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/room_selection/hotel_info_card.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/room_selection/date_selector_widget.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/room_selection/guest_selection_panel.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class SelectRoomScreen extends StatefulWidget {
  final OfferCardModel offer;

  const SelectRoomScreen({super.key, required this.offer});

  @override
  State<SelectRoomScreen> createState() => _SelectRoomScreenState();
}

class _SelectRoomScreenState extends State<SelectRoomScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _adults = 2;
  int _children = 0;
  int _rooms = 1;

  @override
  void initState() {
    super.initState();
    // Initialize with defaults: tomorrow and day after
    final now = DateTime.now();
    _checkIn = DateTime(now.year, now.month, now.day + 1);
    _checkOut = DateTime(now.year, now.month, now.day + 2);
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
          if (_checkOut == null || _checkOut!.isBefore(picked)) {
            _checkOut = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  void _showAvailableRooms() {
    final l10n = AppLocalizations.of(context)!;
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectDates)));
      return;
    }

    if (_checkOut!.isBefore(_checkIn!) ||
        _checkOut!.isAtSameMomentAs(_checkIn!)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.checkOutAfterCheckIn)));
      return;
    }

    // Navigate to room selection with local parameters
    context.push(
      '/hotel-rooms/${widget.offer.id}',
      extra: {
        'checkIn': _checkIn,
        'checkOut': _checkOut,
        'adults': _adults,
        'children': _children,
        'rooms': _rooms,
        'discountPercentage': widget.offer.discountValue,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectRoomTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HotelInfoCard(offer: widget.offer),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: DateSelectorWidget(
                    label: l10n.checkIn,
                    date: _checkIn,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DateSelectorWidget(
                    label: l10n.checkOut,
                    date: _checkOut,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GuestSelectionPanel(
              rooms: _rooms,
              adults: _adults,
              children: _children,
              onRoomsDecrement: () => setState(() {
                if (_rooms > 1) _rooms--;
              }),
              onRoomsIncrement: () => setState(() {
                if (_rooms < 10) _rooms++;
              }),
              onAdultsDecrement: () => setState(() {
                if (_adults > 1) _adults--;
              }),
              onAdultsIncrement: () => setState(() {
                if (_adults < 20) _adults++;
              }),
              onChildrenDecrement: () => setState(() {
                if (_children > 0) _children--;
              }),
              onChildrenIncrement: () => setState(() {
                if (_children < 10) _children++;
              }),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showAvailableRooms,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.seeAvailability,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
