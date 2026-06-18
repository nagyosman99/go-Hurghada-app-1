import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_details/hotel_booking_bar.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_search_bottom_sheet.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/room_selection/guest_info_banner.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/offer_details/room_card.dart';

class HotelAvailabilitySection extends StatefulWidget {
  final String hotelId;
  final List<Room> rooms;
  final double discountPercentage;
  final bool isPerGuest;

  const HotelAvailabilitySection({
    super.key,
    required this.hotelId,
    required this.rooms,
    this.discountPercentage = 0.0,
    this.isPerGuest = false,
  });

  @override
  State<HotelAvailabilitySection> createState() =>
      _HotelAvailabilitySectionState();
}

class _HotelAvailabilitySectionState extends State<HotelAvailabilitySection> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _adults = 2;
  int _children = 0;
  int _roomsCount = 1;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _checkIn = DateTime(now.year, now.month, now.day + 1);
    _checkOut = DateTime(now.year, now.month, now.day + 2);
  }

  void _showSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      builder: (context) => HotelSearchBottomSheet(
        initialCheckIn: _checkIn,
        initialCheckOut: _checkOut,
        initialAdults: _adults,
        initialChildren: _children,
        initialRooms: _roomsCount,
        onApply: (checkIn, checkOut, rooms, adults, children) {
          setState(() {
            _checkIn = checkIn;
            _checkOut = checkOut;
            _roomsCount = rooms;
            _adults = adults;
            _children = children;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalGuests = _adults + _children;
    final guestsPerRoom = _roomsCount > 0
        ? (totalGuests / _roomsCount).ceil()
        : totalGuests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HotelBookingBar(
          checkInDate: _checkIn,
          checkOutDate: _checkOut,
          roomsCount: _roomsCount,
          adults: _adults,
          children: _children,
          onScrollToRooms: () {
            // Rooms are below
          },
          onTapDates: () => _showSearchDialog(context),
          onTapOccupancy: () => _showSearchDialog(context),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
          ),
          child: Text(
            'Rooms',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
          ),
          child: GuestInfoBanner(
            totalGuests: totalGuests,
            roomsCount: _roomsCount,
            guestsPerRoom: guestsPerRoom,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        ...widget.rooms.map((room) {
          final calculator = HotelPriceCalculator(
            basePricePerUnit: room.price,
            params: BookingParams(
              checkIn: _checkIn,
              checkOut: _checkOut,
              rooms: _roomsCount,
              adults: _adults,
              children: _children,
            ),
            isPerGuest: widget.isPerGuest,
          );

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingSmall,
            ),
            child: RoomCard(
              room: room,
              calculator: calculator,
              discountPercentage: widget.discountPercentage,
              onBook: () => context.push(
                '/booking-form',
                extra: {
                  'hotelId': widget.hotelId,
                  'roomId': room.id,
                  'checkIn': _checkIn,
                  'checkOut': _checkOut,
                  'adults': _adults,
                  'children': _children,
                  'rooms': _roomsCount,
                  'discountPercentage': widget.discountPercentage,
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
