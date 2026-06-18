import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/features/payment/presentation/widgets/booking_summary.dart';
import 'package:go_hurghada/features/payment/presentation/widgets/payment_form.dart';
import 'package:go_hurghada/features/payment/domain/models/payment_request.dart';
import 'package:go_hurghada/core/services/payment_service.dart';
import 'package:go_hurghada/features/payment/presentation/screens/paymob_webview_screen.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;

  const PaymentScreen({super.key, required this.bookingDetails});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'pay_at_hotel';

  Future<void> _confirmBooking() async {
    final details = widget.bookingDetails;
    final hotelId = details['hotelId'] as String;
    final roomId = details['roomId'] as String;

    final appProvider = AppProvider.of(context);
    final hotelRepository = appProvider.hotelRepository;
    final paymentViewModel = appProvider.paymentViewModel;
    final l10n = AppLocalizations.of(context)!;

    try {
      // Resolve hotel and room names (prefer pre-passed, fallback to fetch)
      final hotelName = details['hotelName'] as String?;
      final roomName = details['roomName'] as String?;

      final String finalHotelName;
      final String finalRoomName;

      if (hotelName != null && roomName != null) {
        finalHotelName = hotelName;
        finalRoomName = roomName;
      } else {
        final hotel = await hotelRepository.getHotelById(hotelId);
        final rooms = await hotelRepository.getRoomsForHotel(hotelId);
        final room = rooms.firstWhere(
          (r) => r.id == roomId,
          orElse: () => rooms.first,
        );
        if (hotel == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.errorHotelNotFound)));
          }
          return;
        }
        finalHotelName = hotel.name;
        finalRoomName = room.name;
      }

      // Parse booking dates and guest counts
      final checkInDate = details['checkInDate'] != null
          ? DateTime.parse(details['checkInDate'] as String)
          : DateTime.now();
      final checkOutDate = details['checkOutDate'] != null
          ? DateTime.parse(details['checkOutDate'] as String)
          : DateTime.now().add(const Duration(days: 1));
      final roomsCount = details['roomsCount'] as int? ?? 1;
      final adults = details['adults'] as int? ?? 2;
      final children = details['children'] as int? ?? 0;

      // Resolve total price
      final double totalPrice;
      if (details['totalPrice'] != null) {
        totalPrice = (details['totalPrice'] as num).toDouble();
      } else {
        final hotel = await hotelRepository.getHotelById(hotelId);
        final rooms = await hotelRepository.getRoomsForHotel(hotelId);
        final room = rooms.firstWhere(
          (r) => r.id == roomId,
          orElse: () => rooms.first,
        );
        if (hotel == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.errorHotelNotFound)));
          }
          return;
        }
        final isPerGuest = details['isPerGuest'] as bool? ?? false;
        final calculator = HotelPriceCalculator(
          basePricePerUnit: room.price,
          params: BookingParams(
            checkIn: checkInDate,
            checkOut: checkOutDate,
            rooms: roomsCount,
            adults: adults,
            children: children,
          ),
          isPerGuest: isPerGuest,
        );
        final discount = (details['discountPercentage'] as double?) ?? 0.0;
        totalPrice = calculator.getDiscountedPrice(discount);
      }

      final convertedPrice = appProvider.currencyService.convertFromUsd(totalPrice, 'EGP');

      // Process payment
      final paymentRequest = PaymentRequest(
        amount: convertedPrice,
        currency: 'EGP',
        description: 'Booking for $finalHotelName - $finalRoomName',
        customerName: details['guestName'] ?? '',
        customerEmail: details['guestEmail'] ?? '',
        customerPhone: details['guestPhone'] ?? '',
        isPayAtHotel: _selectedPaymentMethod == 'pay_at_hotel',
      );

      bool success = false;

      if (_selectedPaymentMethod == 'pay_at_hotel') {
        // Pay at hotel - no online payment needed
        success = await paymentViewModel.processPayment(paymentRequest);
      } else {
        // Online card payment via PayMob WebView
        final payMobService = appProvider.paymentService as PayMobPaymentService?;
        if (payMobService == null) {
          throw Exception('PayMob service not available');
        }

        // Generate the PayMob payment URL
        final processSuccess = await paymentViewModel.processPayment(paymentRequest);
        if (!mounted) return;
        if (!processSuccess) {
          final error = paymentViewModel.state.error ?? l10n.bookingFailed;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
          return;
        }

        final paymentUrl = payMobService.lastPaymentUrl;
        if (paymentUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ فشل إنشاء رابط الدفع.')),
          );
          return;
        }

        // Open PayMob WebView and wait for result
        final result = await Navigator.of(context).push<PayMobPaymentResult>(
          MaterialPageRoute(
            builder: (_) => PayMobWebViewScreen(paymentUrl: paymentUrl),
          ),
        );

        if (!mounted) return;

        switch (result) {
          case PayMobPaymentResult.success:
            success = true;
          case PayMobPaymentResult.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ فشل الدفع. يرجى المحاولة مرة أخرى.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          case PayMobPaymentResult.cancelled:
          case null:
            return; // User cancelled - do nothing
        }
      }

      if (!mounted) return;

      if (success) {
        // ── Backend call: atomic Firestore transaction ──────────────────────
        try {
          final bookingId =
              await appProvider.myBookingsViewModel.createHotelBooking(
            hotelId: hotelId,
            roomId: roomId,
            checkIn: checkInDate,
            checkOut: checkOutDate,
            guestName: details['guestName'] ?? '',
            guestEmail: details['guestEmail'] ?? '',
            hotelName: finalHotelName,
            roomName: finalRoomName,
            totalPrice: totalPrice,
          );

          if (!mounted) return;

          // Build local Booking object for confirmation screen
          final booking = Booking(
            id: bookingId,
            hotelId: hotelId,
            hotelName: finalHotelName,
            roomId: roomId,
            roomName: finalRoomName,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            totalPrice: totalPrice,
            guestName: details['guestName'] ?? '',
            guestEmail: details['guestEmail'] ?? '',
            guestPhone: details['guestPhone'] ?? '',
            adults: adults,
            children: children,
            roomsCount: roomsCount,
            status: 'confirmed',
            createdAt: DateTime.now(),
          );

          context.go(AppRouter.bookingConfirmation, extra: booking);
        } on Exception catch (e) {
          if (!mounted) return;
          final isAvailability = e.toString().toLowerCase().contains('not available') ||
              e.toString().toLowerCase().contains('fully booked');
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Booking Failed'),
              content: Text(isAvailability
                  ? '❌ Room just became unavailable.\nPlease go back and select different dates.'
                  : '${l10n.bookingFailed}: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        final error = paymentViewModel.state.error ?? l10n.bookingFailed;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.bookingFailed}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.bookingDetails;
    final paymentViewModel = AppProvider.of(context).paymentViewModel;

    final checkInDate = details['checkInDate'] != null
        ? DateTime.parse(details['checkInDate'] as String)
        : DateTime.now();
    final checkOutDate = details['checkOutDate'] != null
        ? DateTime.parse(details['checkOutDate'] as String)
        : DateTime.now().add(const Duration(days: 1));
    final nights = checkOutDate.difference(checkInDate).inDays;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.completeBooking)),
      body: ListenableBuilder(
        listenable: paymentViewModel,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              final isLoading = paymentViewModel.state.isLoading;

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: PaymentForm(
                        selectedPaymentMethod: _selectedPaymentMethod,
                        onPaymentMethodChanged: (val) {
                          setState(() => _selectedPaymentMethod = val);
                        },
                        onConfirm: _confirmBooking,
                        isLoading: isLoading,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: BookingSummary(
                        bookingDetails: details,
                        nights: nights,
                      ),
                    ),
                  ],
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      BookingSummary(bookingDetails: details, nights: nights),
                      PaymentForm(
                        selectedPaymentMethod: _selectedPaymentMethod,
                        onPaymentMethodChanged: (val) {
                          setState(() => _selectedPaymentMethod = val);
                        },
                        onConfirm: _confirmBooking,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
