import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/room_selection/guest_info_banner.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/room_selection/room_selection_card.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class RoomSelectionScreen extends StatefulWidget {
  final String hotelId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? adults;
  final int? children;
  final int? rooms;
  final double? discountPercentage;

  const RoomSelectionScreen({
    super.key,
    required this.hotelId,
    this.checkIn,
    this.checkOut,
    this.adults,
    this.children,
    this.rooms,
    this.discountPercentage,
  });

  @override
  State<RoomSelectionScreen> createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  List<Room> _rooms = [];
  bool _isLoading = true;
  String? _error;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadData();
      _isInitialized = true;
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = AppProvider.of(context).hotelRepository;
      final results = await Future.wait([
        repository.getRoomsForHotel(widget.hotelId),
        repository.getHotelById(widget.hotelId),
      ]);

      final rooms = results[0] as List<Room>;

      if (mounted) {
        setState(() {
          _rooms = rooms;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final searchViewModel = AppProvider.of(context).hotelSearchViewModel;
    final searchState = searchViewModel.state;

    // Use widget parameters if available, otherwise fallback to global state
    final checkIn = widget.checkIn ?? searchState.checkIn;
    final checkOut = widget.checkOut ?? searchState.checkOut;
    final adults = widget.adults ?? searchState.adults;
    final children = widget.children ?? searchState.children;
    final roomsCount = widget.rooms ?? searchState.rooms;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $_error')),
      );
    }

    final totalGuests = adults + children;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectRoom)),
      body: Column(
        children: [
          GuestInfoBanner(
            totalGuests: totalGuests,
            roomsCount: roomsCount,
            guestsPerRoom: roomsCount > 0
                ? (totalGuests / roomsCount).ceil()
                : totalGuests,
          ),
          Expanded(
            child: _rooms.isEmpty
                ? const Center(child: Text('No rooms available'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _rooms.length,
                    itemBuilder: (context, index) {
                      final room = _rooms[index];
                      final calculator = HotelPriceCalculator(
                        basePricePerUnit: room.price,
                        params: BookingParams(
                          checkIn: checkIn,
                          checkOut: checkOut,
                          adults: adults,
                          children: children,
                          rooms: roomsCount,
                        ),
                        isPerGuest: false,
                      );

                      return RoomSelectionCard(
                        room: room,
                        calculator: calculator,
                        discountPercentage: widget.discountPercentage,
                        onBook: () {
                          context.push(
                            '/booking-form',
                            extra: {
                              'hotelId': widget.hotelId,
                              'roomId': room.id,
                              'checkIn': checkIn,
                              'checkOut': checkOut,
                              'adults': adults,
                              'children': children,
                              'rooms': roomsCount,
                              'discountPercentage': widget.discountPercentage,
                            },
                          );
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
