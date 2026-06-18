import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;
  final Widget? cardForm;
  final String? payInPersonTitle;
  final String? payInPersonSubtitle;
  final String? payInPersonValue;
  final IconData? payInPersonIcon;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
    this.cardForm,
    this.payInPersonTitle,
    this.payInPersonSubtitle,
    this.payInPersonValue,
    this.payInPersonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.paymentMethod ?? 'Payment Method',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Pay in Person (Hotel/Location)
            _PaymentMethodTile(
              value: payInPersonValue ?? 'pay_at_hotel',
              title:
                  payInPersonTitle ??
                  (AppLocalizations.of(context)?.payAtHotel ?? 'Pay at Hotel'),
              subtitle:
                  payInPersonSubtitle ??
                  (AppLocalizations.of(context)?.noPrepaymentNeeded ??
                      'No prepayment needed'),
              icon: payInPersonIcon ?? Icons.hotel,
              groupValue: selectedMethod,
              onChanged: onMethodChanged,
            ),

            const Divider(height: 24),

            // Credit/Debit Card
            _PaymentMethodTile(
              value: 'card',
              title:
                  AppLocalizations.of(context)?.creditOrDebitCard ??
                  'Credit or Debit Card',
              subtitle:
                  AppLocalizations.of(context)?.cardAcceptedBrands ??
                  'Visa, Mastercard, Amex',
              icon: Icons.credit_card,
              groupValue: selectedMethod,
              onChanged: onMethodChanged,
            ),

            if (selectedMethod == 'card' && cardForm != null) ...[
              const SizedBox(height: 16),
              cardForm!,
            ],
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle;
  final IconData icon;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _PaymentMethodTile({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : Theme.of(context).dividerColor,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : null,
      ),
      child: RadioListTile<String>(
        value: value,
        // ignore: deprecated_member_use
        groupValue: groupValue,
        // ignore: deprecated_member_use
        onChanged: (val) {
          if (val != null) {
            onChanged(val);
          }
        },
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected
                ? AppColors.primary
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
        secondary: Icon(
          icon,
          color: isSelected
              ? AppColors.primary
              : Theme.of(context).iconTheme.color,
        ),
        activeColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}
