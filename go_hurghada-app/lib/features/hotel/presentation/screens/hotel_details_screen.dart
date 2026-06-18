import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_details/hotel_photo_carousel.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_details/hotel_header_info.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_details/hotel_booking_bar.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_details/hotel_description.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/shared/hotel_facilities_widget.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_details/hotel_room_card.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_search_bottom_sheet.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/shared/widgets/favorite_button.dart';
import 'package:go_hurghada/features/home/domain/models/saved_hotel.dart';

class HotelDetailsScreen extends StatefulWidget {
  final String hotelId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? adults;
  final int? children;
  final int? rooms;

  const HotelDetailsScreen({
    super.key,
    required this.hotelId,
    this.checkIn,
    this.checkOut,
    this.adults,
    this.children,
    this.rooms,
  });

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _roomsSectionKey = GlobalKey();

  HotelDetails? _hotel;
  List<Room> _rooms = [];
  bool _isLoading = true;
  String? _error;

  // Local search state for independence per hotel
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _adults = 2;
  int _children = 0;
  int _roomsCount = 1;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadHotelAndRooms();
      // Initialize with passed parameters or defaults
      final now = DateTime.now();
      _checkIn = widget.checkIn ?? DateTime(now.year, now.month, now.day + 1);
      _checkOut = widget.checkOut ?? DateTime(now.year, now.month, now.day + 2);
      _adults = widget.adults ?? 2;
      _children = widget.children ?? 0;
      _roomsCount = widget.rooms ?? 1;
      _isInitialized = true;
    }
  }

  Future<void> _loadHotelAndRooms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = AppProvider.of(context).hotelRepository;
      final hotel = await repository.getHotelById(widget.hotelId);
      final rooms = await repository.getRoomsForHotel(widget.hotelId);

      if (mounted) {
        setState(() {
          _hotel = hotel;
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

  void _scrollToRooms() {
    final context = _roomsSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showSearchDialog() {
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $_error')),
      );
    }

    if (_hotel == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorHotelNotFound)),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with Image Slider
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ListenableBuilder(
                  listenable: AppProvider.of(context).favoritesViewModel,
                  builder: (context, _) {
                    final vm = AppProvider.of(context).favoritesViewModel;
                    final isSaved = vm.isHotelSaved(_hotel!.id);
                    return FavoriteButton(
                      isFavorite: isSaved,
                      onTap: () =>
                          vm.toggleHotel(SavedHotel.fromHotelDetails(_hotel!)),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _hotel!.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: HotelPhotoCarousel(
                photos: _hotel!.photos.isNotEmpty
                    ? _hotel!.photos
                    : [_hotel!.imageUrl],
                heroTag: 'hotel_${_hotel!.id}',
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HotelHeaderInfo(hotel: _hotel!),
                  const SizedBox(height: 32),
                  HotelBookingBar(
                    checkInDate: _checkIn,
                    checkOutDate: _checkOut,
                    roomsCount: _roomsCount,
                    adults: _adults,
                    children: _children,
                    onScrollToRooms: _scrollToRooms,
                    onTapDates: _showSearchDialog,
                    onTapOccupancy: _showSearchDialog,
                  ),
                  const SizedBox(height: 32),
                  HotelDescription(description: _hotel!.description),
                  const SizedBox(height: 32),
                  HotelFacilitiesWidget(amenities: _hotel!.amenities),
                  const SizedBox(height: 40),

                  // Rooms Section
                  Text(
                    l10n.availability,
                    key: _roomsSectionKey,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rooms List
                  if (_rooms.isEmpty)
                    Text(l10n.noRoomsAvailable)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _rooms.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return HotelRoomCard(
                          key: ValueKey(
                            '${_rooms[index].id}_${_checkIn}_${_checkOut}_$_roomsCount',
                          ),
                          room: _rooms[index],
                          checkIn: _checkIn,
                          checkOut: _checkOut,
                          roomsCount: _roomsCount,
                          adults: _adults,
                          children: _children,
                          isPerGuest: _hotel!.isAllInclusive,
                          discountPercentage: _hotel!.discountValue,
                          onBook: () {
                            context.push(
                              '/booking-form',
                              extra: {
                                'hotelId': widget.hotelId,
                                'roomId': _rooms[index].id,
                                'checkIn': _checkIn,
                                'checkOut': _checkOut,
                                'adults': _adults,
                                'children': _children,
                                'rooms': _roomsCount,
                                'discountPercentage': _hotel!.discountValue,
                              },
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
