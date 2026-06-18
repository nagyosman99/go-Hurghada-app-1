import 'package:flutter/material.dart';
import 'package:go_hurghada/shared/widgets/common/custom_text_field.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class CreditCardForm extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController cardHolderController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;

  const CreditCardForm({
    super.key,
    required this.cardNumberController,
    required this.cardHolderController,
    required this.expiryController,
    required this.cvvController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: cardNumberController,
          label: AppLocalizations.of(context)?.cardNumber ?? 'Card Number',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: cardHolderController,
          label:
              AppLocalizations.of(context)?.cardholderName ?? 'Cardholder Name',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: expiryController,
                label: AppLocalizations.of(context)?.expiryDateHint ?? 'MM/YY',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                controller: cvvController,
                label: AppLocalizations.of(context)?.cvv ?? 'CVV',
                keyboardType: TextInputType.number,
                isPassword: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
