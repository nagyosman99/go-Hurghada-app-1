import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/config/routes/app_router.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final viewModel = AppProvider.of(context).myBookingsViewModel;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadBookings();
      });
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = AppProvider.of(context).myBookingsViewModel;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myBookings),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.loadBookings(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final state = viewModel.state;

          if (state.isLoading && state.bookings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.bookings.isEmpty) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state.bookings.isEmpty) {
            return Center(child: Text(l10n.noBookingsFound));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.bookings.length,
            itemBuilder: (context, index) {
              final booking = state.bookings[index];
              return _BookingCard(booking: booking);
            },
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final viewModel = AppProvider.of(context).myBookingsViewModel;
    final isCancelled = booking.status == 'cancelled';
    final l10n = AppLocalizations.of(context)!;
    final isActivity = booking.type == BookingType.activity;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () => context.push('${AppRouter.bookingDetails}/${booking.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isActivity
                          ? (booking.activityName ?? 'Activity')
                          : (booking.hotelName ?? 'Hotel'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isCancelled
                          ? Colors.red.shade100
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      booking.status.toUpperCase(),
                      style: TextStyle(
                        color: isCancelled
                            ? Colors.red.shade800
                            : Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Remove Booking'),
                          content: const Text(
                            'Are you sure you want to remove this booking from your history?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.no),
                            ),
                            TextButton(
                              onPressed: () {
                                viewModel.deleteBooking(booking.id);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.grey.shade600,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isActivity
                    ? '${booking.persons ?? 0} Persons'
                    : (booking.roomName ?? ''),
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isActivity
                        ? DateFormat(
                            'MMM dd, yyyy',
                          ).format(booking.selectedDate ?? DateTime.now())
                        : '${DateFormat('MMM dd').format(booking.checkInDate ?? DateTime.now())} - ${DateFormat('MMM dd, yyyy').format(booking.checkOutDate ?? DateTime.now())}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (!isCancelled) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l10n.cancelBookingQuestion),
                          content: Text(l10n.cancelBookingConfirmation),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.no),
                            ),
                            TextButton(
                              onPressed: () {
                                viewModel.cancelBooking(booking.id);
                                Navigator.pop(context);
                              },
                              child: Text(
                                l10n.yesCancel,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      l10n.cancel,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
