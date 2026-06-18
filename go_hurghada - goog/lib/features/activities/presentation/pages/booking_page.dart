import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/booking/activity_booking_preview.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/booking/booking_date_selection.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/booking/booking_guest_counter.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/booking/booking_price_summary.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/booking/booking_user_info_form.dart';

class BookingPage extends StatefulWidget {
  final String activityId;

  const BookingPage({super.key, required this.activityId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Activity? _activity;
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadActivity();
      _isInitialized = true;
    }
  }

  Future<void> _loadActivity() async {
    final viewModel = AppProvider.of(context).activitiesViewModel;

    if (viewModel.state.activities.isEmpty) {
      await viewModel.loadActivities();
    }

    _activity = viewModel.getActivityById(widget.activityId);

    if (_activity != null && mounted) {
      final bookingViewModel = AppProvider.of(context).activityBookingViewModel;
      bookingViewModel.initialize(_activity!.price);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_activity == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Activity not found')),
      );
    }

    final bookingViewModel = AppProvider.of(context).activityBookingViewModel;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookActivity)),
      body: ListenableBuilder(
        listenable: bookingViewModel,
        builder: (context, _) {
          final state = bookingViewModel.state;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity Preview
                ActivityBookingPreview(activity: _activity!),
                const SizedBox(height: 24),

                // Date Selection
                BookingDateSelection(
                  availableDates: _activity!.availableDates,
                  selectedDate: state.selectedDate,
                  onDateSelected: bookingViewModel.setDate,
                ),
                const SizedBox(height: 24),

                // Persons Counter
                BookingGuestCounter(
                  persons: state.persons,
                  onPersonsChanged: bookingViewModel.setPersons,
                ),
                const SizedBox(height: 24),

                // Pickup Information Display
                if (_activity!.pickupIncluded &&
                    _activity!.pickupInfo != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pickup Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pickup between ${_activity!.pickupInfo!.timeWindow}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Driver will contact you via ${_activity!.pickupInfo!.contactMethod} ${_activity!.pickupInfo!.contactTiming}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // User Information Form
                BookingUserInfoForm(
                  pickupIncluded: _activity!.pickupIncluded,
                  onNameChanged: bookingViewModel.setUserName,
                  onEmailChanged: bookingViewModel.setUserEmail,
                  onPhoneChanged: bookingViewModel.setUserPhone,
                  onPickupLocationChanged: bookingViewModel.setPickupLocation,
                  onSpecialRequestsChanged: bookingViewModel.setSpecialRequests,
                ),
                const SizedBox(height: 24),

                // Price Breakdown
                BookingPriceSummary(
                  calculator: bookingViewModel.calculator,
                  freeCancellation: _activity!.freeCancellation,
                ),
                const SizedBox(height: 16),

                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.errorContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.error!,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (bookingViewModel.validate()) {
                        context.push(
                          '/activity/${widget.activityId}/booking/summary',
                          extra: {
                            'activity': _activity,
                            'selectedDate': state.selectedDate,
                            'persons': state.persons,
                            'pickupLocation': state.pickupLocation,
                            'userName': state.userName,
                            'userEmail': state.userEmail,
                            'userPhone': state.userPhone,
                            'specialRequests': state.specialRequests,
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Continue to Payment'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
