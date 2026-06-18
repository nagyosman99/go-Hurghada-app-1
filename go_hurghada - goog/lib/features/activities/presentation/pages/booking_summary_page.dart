import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/booking/booking_summary_card.dart';
import 'package:go_hurghada/features/payment/presentation/widgets/payment_method_selector.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';
import 'package:go_hurghada/features/payment/domain/models/payment_request.dart';
import 'package:go_hurghada/core/services/payment_service.dart';
import 'package:go_hurghada/features/payment/presentation/screens/paymob_webview_screen.dart';

class BookingSummaryPage extends StatefulWidget {
  final Activity activity;

  const BookingSummaryPage({super.key, required this.activity});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  String _selectedPaymentMethod = 'pay_at_location';

  Future<void> _confirmBooking() async {
    final appProvider = AppProvider.of(context);
    final bookingViewModel = appProvider.activityBookingViewModel;
    final paymentViewModel = appProvider.paymentViewModel;
    final l10n = AppLocalizations.of(context)!;
    
    final state = bookingViewModel.state;
    final totalPrice = state.totalPrice;
    
    bool success = false;
    
    if (_selectedPaymentMethod == 'pay_at_location') {
      success = true;
    } else {
      final convertedPrice = appProvider.currencyService.convertFromUsd(totalPrice, 'EGP');

      // Card payment
      final paymentRequest = PaymentRequest(
        amount: convertedPrice,
        currency: 'EGP',
        description: 'Activity Booking: ${widget.activity.title}',
        customerName: state.userName.isNotEmpty ? state.userName : 'Guest',
        customerEmail: state.userEmail.isNotEmpty ? state.userEmail : 'guest@gohurghada.com',
        customerPhone: state.userPhone.isNotEmpty ? state.userPhone : '+201000000000',
        isPayAtHotel: false,
      );
      
      final payMobService = appProvider.paymentService as PayMobPaymentService?;
      if (payMobService == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment service not available')),
        );
        return;
      }
      
      // Generate PayMob payment URL
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
      if (paymentUrl == null || !mounted) return;
      
      // Open WebView
      final result = await Navigator.of(context).push<PayMobPaymentResult>(
        MaterialPageRoute(
          builder: (_) => PayMobWebViewScreen(paymentUrl: paymentUrl),
        ),
      );
      
      if (!mounted) return;
      
      switch (result) {
        case PayMobPaymentResult.success:
          success = true;
          break;
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
          return;
      }
    }

    if (success && mounted) {
      final bookingId = await bookingViewModel.confirmBooking(
        activityId: widget.activity.id,
        activityName: widget.activity.title,
      );

      if (mounted && bookingId != null) {
        final state = bookingViewModel.state;
        final booking = Booking(
          id: bookingId,
          type: BookingType.activity,
          activityId: widget.activity.id,
          activityName: widget.activity.title,
          selectedDate: state.selectedDate ?? DateTime.now(),
          persons: state.persons,
          totalPrice: state.totalPrice,
          guestName: state.userName,
          guestEmail: state.userEmail,
          guestPhone: state.userPhone,
          pickupLocation: state.pickupLocation,
          status: 'confirmed',
          createdAt: DateTime.now(),
        );

        context.go('/booking-confirmation', extra: booking);
      } else if (mounted && bookingViewModel.state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bookingViewModel.state.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingViewModel = AppProvider.of(context).activityBookingViewModel;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(l10n.reviewBooking), centerTitle: true),
      body: ListenableBuilder(
        listenable: bookingViewModel,
        builder: (context, _) {
          final state = bookingViewModel.state;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingSummaryCard(
                    activity: widget.activity,
                    selectedDate: state.selectedDate ?? DateTime.now(),
                    persons: state.persons,
                    pickupLocation: state.pickupLocation,
                    totalPrice: state.totalPrice,
                  ),
                  const SizedBox(height: 16),
                  PaymentMethodSelector(
                    selectedMethod: _selectedPaymentMethod,
                    onMethodChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    payInPersonTitle: 'Pay at Location',
                    payInPersonSubtitle: 'Pay when you arrive at the activity',
                    payInPersonValue: 'pay_at_location',
                    payInPersonIcon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: bookingViewModel,
        builder: (context, _) {
          final isProcessing = bookingViewModel.state.isSubmitting;
          return Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: isProcessing ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
