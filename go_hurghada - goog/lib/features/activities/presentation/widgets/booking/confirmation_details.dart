import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

class ConfirmationDetails extends StatelessWidget {
  final String bookingId;
  final Activity activity;
  final DateTime date;
  final int persons;
  final double totalPrice;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String pickupLocation;
  final String paymentMethod;

  const ConfirmationDetails({
    super.key,
    required this.bookingId,
    required this.activity,
    required this.date,
    required this.persons,
    required this.totalPrice,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.pickupLocation,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Activity Details Card
        _buildCard(
          context,
          title: 'Activity Details',
          children: [
            _DetailRow(label: 'Activity', value: activity.title),
            const Divider(height: 24),
            _DetailRow(label: 'Category', value: activity.category),
            const Divider(height: 24),
            _DetailRow(label: 'Duration', value: activity.duration),
            const Divider(height: 24),
            _DetailRow(
              label: 'Date',
              value: DateFormat('EEEE, MMMM dd, yyyy').format(date),
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Guests',
              value: '$persons ${persons > 1 ? 'persons' : 'person'}',
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Customer Information Card
        _buildCard(
          context,
          title: 'Customer Information',
          children: [
            _DetailRow(label: 'Name', value: userName),
            const Divider(height: 24),
            _DetailRow(label: 'Email', value: userEmail),
            const Divider(height: 24),
            _DetailRow(label: 'Phone', value: userPhone),
            if (pickupLocation.isNotEmpty) ...[
              const Divider(height: 24),
              _DetailRow(label: 'Pickup Location', value: pickupLocation),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // Pickup Information Card (if applicable)
        if (activity.pickupIncluded && activity.pickupInfo != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pickup Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Pickup Time: ${activity.pickupInfo!.timeWindow}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Driver will contact you via ${activity.pickupInfo!.contactMethod} ${activity.pickupInfo!.contactTiming}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        if (activity.pickupIncluded && activity.pickupInfo != null)
          const SizedBox(height: 16),

        // Payment & Price Card
        _buildCard(
          context,
          title: 'Payment Details',
          children: [
            _DetailRow(
              label: 'Payment Method',
              value: paymentMethod == 'pay_at_location'
                  ? 'Pay at Location'
                  : 'Credit/Debit Card',
            ),
            const Divider(height: 24),
            _DetailRow(
              label:
                  '${activity.price.formatPrice(context)} x $persons ${persons > 1 ? 'persons' : 'person'}',
              value: totalPrice.formatPrice(context),
            ),
            if (activity.freeCancellation) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Free cancellation up to 24h',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  totalPrice.formatPrice(context),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
