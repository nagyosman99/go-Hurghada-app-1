import 'package:flutter/material.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/hotel_search_location_sheet.dart';

class BookingUserInfoForm extends StatefulWidget {
  final bool pickupIncluded;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onPickupLocationChanged;
  final ValueChanged<String> onSpecialRequestsChanged;

  const BookingUserInfoForm({
    super.key,
    required this.pickupIncluded,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onPickupLocationChanged,
    required this.onSpecialRequestsChanged,
  });

  @override
  State<BookingUserInfoForm> createState() => _BookingUserInfoFormState();
}

class _BookingUserInfoFormState extends State<BookingUserInfoForm> {
  final TextEditingController _pickupController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    super.dispose();
  }

  Future<void> _showHotelSearch() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HotelSearchLocationSheet(),
    );

    if (result != null) {
      setState(() {
        _pickupController.text = result;
      });
      widget.onPickupLocationChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Information',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        // Full Name
        TextField(
          onChanged: widget.onNameChanged,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.fullName,
            hintText: AppLocalizations.of(context)!.enterFullName,
            prefixIcon: const Icon(Icons.person_outline),
            filled: true,
            fillColor:
                Theme.of(context).inputDecorationTheme.fillColor ??
                Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Email
        TextField(
          onChanged: widget.onEmailChanged,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.emailAddress,
            hintText: AppLocalizations.of(context)!.enterEmail,
            prefixIcon: const Icon(Icons.email_outlined),
            filled: true,
            fillColor:
                Theme.of(context).inputDecorationTheme.fillColor ??
                Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Phone Number
        TextField(
          onChanged: widget.onPhoneChanged,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.mobilePhone,
            hintText: AppLocalizations.of(context)!.enterPhone,
            prefixIcon: const Icon(Icons.phone_outlined),
            filled: true,
            fillColor:
                Theme.of(context).inputDecorationTheme.fillColor ??
                Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Pickup Location
        if (widget.pickupIncluded) ...[
          TextField(
            controller: _pickupController,
            readOnly: true,
            onTap: _showHotelSearch,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.locationLabel,
              hintText: AppLocalizations.of(context)!.selectHotel,
              prefixIcon: const Icon(Icons.hotel_outlined),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              filled: true,
              fillColor:
                  Theme.of(context).inputDecorationTheme.fillColor ??
                  Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Special Requests
        TextField(
          onChanged: widget.onSpecialRequestsChanged,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.specialRequests,
            hintText: AppLocalizations.of(context)!.specialRequestsHint,
            filled: true,
            fillColor:
                Theme.of(context).inputDecorationTheme.fillColor ??
                Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
