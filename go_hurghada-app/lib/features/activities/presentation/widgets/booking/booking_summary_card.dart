import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';

class BookingSummaryCard extends StatelessWidget {
  final Activity activity;
  final DateTime selectedDate;
  final int persons;
  final String pickupLocation;
  final double totalPrice;

  const BookingSummaryCard({
    super.key,
    required this.activity,
    required this.selectedDate,
    required this.persons,
    required this.pickupLocation,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity Name
              Text(
                activity.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                activity.category,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.lightGrey),
              const SizedBox(height: 16),

              // Date
              _SummaryRow(
                label: 'Date',
                value: DateFormat('EEE, MMM dd, yyyy').format(selectedDate),
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 12),

              // Duration
              _SummaryRow(
                label: 'Duration',
                value: activity.duration,
                icon: Icons.access_time,
              ),
              const SizedBox(height: 12),

              // Persons
              _SummaryRow(
                label: 'Guests',
                value: '$persons ${persons > 1 ? 'persons' : 'person'}',
                icon: Icons.people_outline,
              ),
              const SizedBox(height: 12),

              // Pickup Location
              if (activity.pickupIncluded) ...[
                _SummaryRow(
                  label: 'Pickup',
                  value: pickupLocation,
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.lightGrey),
                const SizedBox(height: 16),
              ],

              // Price Breakdown
              _SummaryRow(
                label: 'Price per person',
                value: activity.price.formatPrice(context),
              ),
              const SizedBox(height: 16),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    totalPrice.formatPrice(context),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _SummaryRow({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
