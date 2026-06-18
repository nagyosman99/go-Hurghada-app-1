import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class BookingGuestForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController notesController;

  const BookingGuestForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.enterYourDetails ??
                  'Enter your details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.fullName,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? (AppLocalizations.of(context)?.pleaseEnterName ??
                        'Please enter your name')
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.emailAddress,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || !value.contains('@')
                  ? (AppLocalizations.of(context)?.pleaseEnterValidEmail ??
                        'Please enter a valid email')
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.mobilePhone,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.isEmpty
                  ? (AppLocalizations.of(context)?.pleaseEnterPhoneNumber ??
                        'Please enter your phone number')
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.specialRequests,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
