import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/core/services/booking_api_service.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/booking/presentation/widgets/booking_hotel_summary.dart';
import 'package:go_hurghada/features/booking/presentation/widgets/booking_price_breakdown.dart';
import 'package:go_hurghada/features/booking/presentation/widgets/booking_guest_form.dart';

class BookingFormScreen extends StatefulWidget {
  final String hotelId;
  final String roomId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? adults;
  final int? children;
  final int? rooms;
  final double? discountPercentage;

  const BookingFormScreen({
    super.key,
    required this.hotelId,
    required this.roomId,
    this.checkIn,
    this.checkOut,
    this.adults,
    this.children,
    this.rooms,
    this.discountPercentage,
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  HotelDetails? _hotel;
  Room? _room;
  bool _isLoading = true;
  String? _error;

  // ── Availability state ──────────────────────────────────────────────────
  bool _isCheckingAvailability = false;
  List<DateAvailability>? _availabilityResult;
  String? _availabilityError;

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
      final hotel = await repository.getHotelById(widget.hotelId);
      final rooms = await repository.getRoomsForHotel(widget.hotelId);
      final room = rooms.firstWhere(
        (r) => r.id == widget.roomId,
        orElse: () => rooms.first,
      );

      if (mounted) {
        setState(() {
          _hotel = hotel;
          _room = room;
          _isLoading = false;
        });
        // Auto-check availability once data is loaded
        _checkAvailability();
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

  Future<void> _checkAvailability() async {
    final searchViewModel = AppProvider.of(context).hotelSearchViewModel;
    final checkIn = widget.checkIn ?? searchViewModel.state.checkIn;
    final checkOut = widget.checkOut ?? searchViewModel.state.checkOut;

    if (checkIn == null || checkOut == null) return;
    if (!checkOut.isAfter(checkIn)) return;

    setState(() {
      _isCheckingAvailability = true;
      _availabilityError = null;
      _availabilityResult = null;
    });

    try {
      final api = BookingApiService();
      final result = await api.checkAvailability(
        hotelId: widget.hotelId,
        roomId: widget.roomId,
        startDate: checkIn,
        endDate: checkOut,
      );
      if (mounted) {
        setState(() {
          _availabilityResult = result;
          _isCheckingAvailability = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _availabilityError = e.toString();
          _isCheckingAvailability = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _allDatesAvailable {
    if (_availabilityResult == null) return false;
    return _availabilityResult!.every((d) => d.available);
  }

  List<String> get _unavailableDates {
    if (_availabilityResult == null) return [];
    return _availabilityResult!
        .where((d) => !d.available)
        .map((d) => d.date)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final searchViewModel = AppProvider.of(context).hotelSearchViewModel;
    final searchState = searchViewModel.state;

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

    if (_hotel == null || _room == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorHotelNotFound)),
      );
    }

    final calculator = HotelPriceCalculator(
      basePricePerUnit: _room!.price,
      params: BookingParams(
        checkIn: checkIn,
        checkOut: checkOut,
        adults: adults,
        children: children,
        rooms: roomsCount,
      ),
      isPerGuest: false,
    );

    final double totalPrice;
    final double totalOriginalPrice;
    final bool hasDiscount;
    final double discountPercent;

    if (widget.discountPercentage != null && widget.discountPercentage! > 0) {
      totalOriginalPrice = calculator.totalPrice;
      totalPrice = calculator.getDiscountedPrice(widget.discountPercentage!);
      hasDiscount = true;
      discountPercent = widget.discountPercentage! * 100;
    } else if (_room!.originalPrice != null &&
        _room!.originalPrice! > _room!.price) {
      totalOriginalPrice =
          _room!.originalPrice! *
          calculator.params.nights *
          (calculator.params.rooms > 0 ? calculator.params.rooms : 1);
      totalPrice = calculator.totalPrice;
      hasDiscount = true;
      discountPercent =
          ((_room!.originalPrice! - _room!.price) /
          _room!.originalPrice! *
          100);
    } else {
      totalOriginalPrice = calculator.totalPrice;
      totalPrice = totalOriginalPrice;
      hasDiscount = false;
      discountPercent = 0;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.reviewBooking),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingHotelSummary(
                hotel: _hotel!,
                room: _room!,
                checkInDate: checkIn,
                checkOutDate: checkOut,
                nights: calculator.params.nights,
                adults: adults,
                children: children,
                roomsCount: roomsCount,
              ),
              const SizedBox(height: 16),

              // ── Availability Banner ────────────────────────────────────
              _buildAvailabilityBanner(context),
              const SizedBox(height: 16),

              BookingPriceBreakdown(
                originalPrice: totalOriginalPrice,
                discountedPrice: totalPrice,
                hasDiscount: hasDiscount,
                discountPercent: discountPercent,
                roomsCount: roomsCount,
              ),
              const SizedBox(height: 16),
              BookingGuestForm(
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                notesController: _notesController,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isCheckingAvailability ||
                          (_availabilityResult != null && !_allDatesAvailable))
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            final bookingDetails = {
                              'hotelId': widget.hotelId,
                              'roomId': widget.roomId,
                              'guestName': _nameController.text,
                              'guestEmail': _emailController.text,
                              'guestPhone': _phoneController.text,
                              'notes': _notesController.text,
                              'checkInDate': checkIn?.toIso8601String(),
                              'checkOutDate': checkOut?.toIso8601String(),
                              'roomsCount': roomsCount,
                              'adults': adults,
                              'children': children,
                              'hotelName': _hotel!.name,
                              'hotelAddress': _hotel!.address,
                              'roomName': _room!.name,
                              'totalPrice': totalPrice,
                              'totalOriginalPrice': totalOriginalPrice,
                              'discountPercentage': hasDiscount
                                  ? (discountPercent / 100)
                                  : 0.0,
                              'isPerGuest': false,
                            };

                            context.push(AppRouter.payment, extra: bookingDetails);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.nextStepPayment,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailabilityBanner(BuildContext context) {
    if (_isCheckingAvailability) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Checking availability…'),
          ],
        ),
      );
    }

    if (_availabilityError != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.orange, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Could not check availability. You can still proceed.',
                style: TextStyle(color: Colors.orange.shade800),
              ),
            ),
            TextButton(
              onPressed: _checkAvailability,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_availabilityResult == null) return const SizedBox.shrink();

    if (_allDatesAvailable) {
      final minRemaining = _availabilityResult!
          .map((d) => d.remainingRooms)
          .reduce((a, b) => a < b ? a : b);

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                minRemaining <= 3
                    ? '✅ Available — only $minRemaining room(s) left!'
                    : '✅ Room is available for your selected dates.',
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Some dates are unavailable
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cancel, color: Colors.red, size: 20),
              const SizedBox(width: 10),
              Text(
                '❌ Room not available',
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Fully booked on: ${_unavailableDates.join(", ")}',
            style: TextStyle(color: Colors.red.shade700, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            'Please go back and choose different dates.',
            style: TextStyle(color: Colors.red.shade700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
