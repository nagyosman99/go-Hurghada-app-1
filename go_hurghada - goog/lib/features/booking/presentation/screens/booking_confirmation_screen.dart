import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/services/notification_service.dart';
import 'package:go_hurghada/core/services/pdf_service.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Booking booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  bool _notificationsSent = false;

  @override
  void initState() {
    super.initState();
    _sendConfirmations();
  }

  Future<void> _sendConfirmations() async {
    final emailService = EmailNotificationService();
    final smsService = SMSNotificationService();

    try {
      await Future.wait([
        emailService.sendBookingConfirmation(widget.booking),
        smsService.sendBookingConfirmation(widget.booking),
      ]);

      if (mounted) {
        setState(() {
          _notificationsSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.bookingConfirmationSent,
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error sending confirmations: $e');
    }
  }

  Future<void> _downloadPDF() async {
    try {
      final pdfService = PDFService();
      await pdfService.shareBookingInvoice(widget.booking);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.errorGeneric}: $e'),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isActivity = widget.booking.type == BookingType.activity;
    final nights = !isActivity
        ? (widget.booking.checkOutDate ?? DateTime.now())
              .difference(widget.booking.checkInDate ?? DateTime.now())
              .inDays
        : 0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              // Success Message
              Text(
                AppLocalizations.of(context)?.bookingConfirmed ??
                    'Booking Confirmed!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                AppLocalizations.of(context)?.reservationSuccessMessage ??
                    'Your reservation has been successfully confirmed',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Booking Details Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
                elevation: 0,
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking ID
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${AppLocalizations.of(context)?.bookingIdLabel ?? 'Booking ID'}: #${widget.booking.id.substring(0, 8).toUpperCase()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Hotel and Room or Activity
                      _DetailSection(
                        title: isActivity
                            ? 'Activity Details'
                            : (AppLocalizations.of(context)?.accommodation ??
                                  'Accommodation'),
                        children: [
                          if (isActivity) ...[
                            _DetailRow(
                              label: 'Activity',
                              value: widget.booking.activityName ?? '',
                            ),
                            _DetailRow(
                              label: 'Persons',
                              value: '${widget.booking.persons ?? 0}',
                            ),
                            if (widget.booking.pickupLocation != null &&
                                widget.booking.pickupLocation!.isNotEmpty)
                              _DetailRow(
                                label: 'Pickup',
                                value: widget.booking.pickupLocation!,
                              ),
                          ] else ...[
                            _DetailRow(
                              label:
                                  AppLocalizations.of(context)?.hotel ??
                                  'Hotel',
                              value: widget.booking.hotelName ?? '',
                            ),
                            _DetailRow(
                              label:
                                  AppLocalizations.of(context)?.room ?? 'Room',
                              value: widget.booking.roomName ?? '',
                            ),
                          ],
                        ],
                      ),

                      const Divider(height: 32),

                      // Dates
                      _DetailSection(
                        title: isActivity ? 'Date' : 'Stay Details',
                        children: [
                          if (isActivity)
                            _DetailRow(
                              label: 'Date',
                              value: _formatDate(
                                widget.booking.selectedDate ?? DateTime.now(),
                              ),
                            )
                          else ...[
                            _DetailRow(
                              label:
                                  AppLocalizations.of(context)?.checkIn ??
                                  'Check-in',
                              value: _formatDate(
                                widget.booking.checkInDate ?? DateTime.now(),
                              ),
                            ),
                            _DetailRow(
                              label:
                                  AppLocalizations.of(context)?.checkOut ??
                                  'Check-out',
                              value: _formatDate(
                                widget.booking.checkOutDate ?? DateTime.now(),
                              ),
                            ),
                            _DetailRow(
                              label:
                                  AppLocalizations.of(context)?.duration ??
                                  'Duration',
                              value: AppLocalizations.of(
                                context,
                              )!.totalLengthOfStay(nights),
                            ),
                          ],
                        ],
                      ),

                      const Divider(height: 32),

                      // Guest Information
                      _DetailSection(
                        title:
                            AppLocalizations.of(context)?.guestUser ??
                            'Guest Information',
                        children: [
                          _DetailRow(
                            label: AppLocalizations.of(context)?.name ?? 'Name',
                            value: widget.booking.guestName,
                          ),
                          _DetailRow(
                            label:
                                AppLocalizations.of(context)?.email ?? 'Email',
                            value: widget.booking.guestEmail,
                          ),
                          _DetailRow(
                            label:
                                AppLocalizations.of(context)?.phone ?? 'Phone',
                            value: widget.booking.guestPhone,
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      // Total Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.totalAmount ??
                                'Total Amount',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.booking.totalPrice.formatPrice(context),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Download PDF Button
              OutlinedButton.icon(
                onPressed: _downloadPDF,
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(AppLocalizations.of(context)!.downloadPdf),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Notification Status
              if (_notificationsSent)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)?.bookingConfirmationSent ??
                            'Confirmation sent to email and phone',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Back to Home Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.backToHome ?? 'Back to Home',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
