import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';
import 'package:go_hurghada/core/services/pdf_service.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';
import 'package:go_router/go_router.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final viewModel = AppProvider.of(context).myBookingsViewModel;
      if (viewModel.state.bookings.isEmpty) {
        viewModel.loadBookings();
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = AppProvider.of(context).myBookingsViewModel;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookingDetails)),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final state = viewModel.state;

          if (state.isLoading && state.bookings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.bookings.isEmpty) {
            return Center(child: Text(l10n.noBookingsFound));
          }

          final booking = state.bookings.where((b) => b.id == widget.bookingId);

          if (booking.isEmpty) {
            return const Center(child: Text('Booking not found'));
          }

          final item = booking.first;
          final isActivity = item.type == BookingType.activity;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBanner(context, item.status),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRect(
                    // Important to constrain cutouts if they go too far,
                    // but we actually want them to "bite" the edges.
                    // We'll use a Stack inside the Padding.
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildSectionTitle(
                              context,
                              isActivity
                                  ? 'Activity Information'
                                  : 'Hotel Information',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                if (isActivity) ...[
                                  _buildInfoRow(
                                    context,
                                    'Activity',
                                    item.activityName ?? '',
                                  ),
                                  _buildInfoRow(
                                    context,
                                    'Persons',
                                    '${item.persons ?? 0}',
                                  ),
                                  if (item.pickupLocation != null &&
                                      item.pickupLocation!.isNotEmpty)
                                    _buildInfoRow(
                                      context,
                                      'Pickup',
                                      item.pickupLocation!,
                                    ),
                                ] else ...[
                                  _buildInfoRow(
                                    context,
                                    'Hotel',
                                    item.hotelName ?? '',
                                  ),
                                  _buildInfoRow(
                                    context,
                                    'Room',
                                    item.roomName ?? '',
                                  ),
                                ],
                                _buildInfoRow(
                                  context,
                                  'Location',
                                  'Hurghada, Egypt',
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildSectionTitle(
                              context,
                              isActivity ? 'Date' : 'Dates',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                if (isActivity)
                                  _buildInfoRow(
                                    context,
                                    'Date',
                                    DateFormat('MMM dd, yyyy').format(
                                      item.selectedDate ?? DateTime.now(),
                                    ),
                                  )
                                else ...[
                                  _buildInfoRow(
                                    context,
                                    'Check-in',
                                    DateFormat('MMM dd, yyyy').format(
                                      item.checkInDate ?? DateTime.now(),
                                    ),
                                  ),
                                  _buildInfoRow(
                                    context,
                                    'Check-out',
                                    DateFormat('MMM dd, yyyy').format(
                                      item.checkOutDate ?? DateTime.now(),
                                    ),
                                  ),
                                  _buildInfoRow(
                                    context,
                                    'Nights',
                                    (item.checkOutDate ?? DateTime.now())
                                        .difference(
                                          item.checkInDate ?? DateTime.now(),
                                        )
                                        .inDays
                                        .toString(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Divider(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildSectionTitle(context, 'Guest Details'),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                _buildInfoRow(context, 'Name', item.guestName),
                                _buildInfoRow(
                                  context,
                                  'Email',
                                  item.guestEmail,
                                ),
                                _buildInfoRow(
                                  context,
                                  'Phone',
                                  item.guestPhone,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTicketSeparator(context),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildSectionTitle(context, 'Payment'),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  context,
                                  'Total Price',
                                  item.totalPrice.formatPrice(context),
                                  isBold: true,
                                  valueColor: AppColors.primary,
                                ),
                                _buildInfoRow(
                                  context,
                                  'Payment Method',
                                  isActivity
                                      ? 'Pay at Location'
                                      : 'Pay at Hotel',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (item.status != 'cancelled') ...[
                  if (isActivity) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          try {
                            final pdfService = PDFService();
                            await pdfService.printActivityTicket(
                              bookingId: item.id,
                              activityTitle: item.activityName ?? 'Activity',
                              date: item.selectedDate ?? DateTime.now(),
                              persons: item.persons ?? 0,
                              totalPrice: item.totalPrice,
                              userName: item.guestName,
                              userEmail: item.guestEmail,
                              userPhone: item.guestPhone,
                              pickupLocation: item.pickupLocation ?? '',
                            );
                          } catch (e) {
                            if (mounted) {
                              messenger.showSnackBar(
                                SnackBar(content: Text(l10n.errorGeneric)),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download Ticket'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          try {
                            final pdfService = PDFService();
                            await pdfService.shareActivityTicket(
                              bookingId: item.id,
                              activityTitle: item.activityName ?? 'Activity',
                              date: item.selectedDate ?? DateTime.now(),
                              persons: item.persons ?? 0,
                              totalPrice: item.totalPrice,
                              userName: item.guestName,
                              userEmail: item.guestEmail,
                              userPhone: item.guestPhone,
                              pickupLocation: item.pickupLocation ?? '',
                            );
                          } catch (e) {
                            if (mounted) {
                              messenger.showSnackBar(
                                SnackBar(content: Text(l10n.errorGeneric)),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share Ticket'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(l10n.cancelBookingQuestion),
                            content: const Text(
                              'Are you sure you want to cancel this booking?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l10n.no),
                              ),
                              TextButton(
                                onPressed: () {
                                  viewModel.cancelBooking(item.id);
                                  Navigator.of(context).pop(); // dialog
                                  if (context.canPop()) {
                                    context.pop(); // screen
                                  } else {
                                    context.go('/my-bookings');
                                  }
                                },
                                child: Text(
                                  l10n.yesCancel,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.errorContainer.withValues(alpha: 0.1),
                        foregroundColor: Theme.of(context).colorScheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(l10n.cancelBooking),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, String status) {
    Color color;
    IconData icon;
    String text;

    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.green;
        icon = Icons.check_circle;
        text = 'Booking Confirmed';
        break;
      case 'cancelled':
        color = Theme.of(context).colorScheme.error;
        icon = Icons.cancel;
        text = 'Booking Cancelled';
        break;
      default:
        color = Colors.orange;
        icon = Icons.info;
        text = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketSeparator(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: List.generate(
                (constraints.maxWidth / 10).floor(),
                (index) => Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
            ),
            Positioned(
              left: -10,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -10,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).hintColor)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
