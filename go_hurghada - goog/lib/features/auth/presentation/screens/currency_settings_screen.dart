import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';

class CurrencySettingsScreen extends StatelessWidget {
  const CurrencySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsViewModel = AppProvider.of(context).settingsViewModel;

    final l10n = AppLocalizations.of(context);
    final currencies = [
      {
        'code': 'EGP',
        'name': l10n?.egyptianPound ?? 'Egyptian Pound',
        'flag': '🇪🇬',
      },
      {
        'code': 'AED',
        'name': l10n?.uaeDirham ?? 'United Arab Emirates Dirham',
        'flag': '🇦🇪',
      },
      {
        'code': 'USD',
        'name': l10n?.usDollar ?? 'United States Dollar',
        'flag': '🇺🇸',
      },
      {'code': 'EUR', 'name': l10n?.euro ?? 'Euro', 'flag': '🇪🇺'},
    ];

    return ListenableBuilder(
      listenable: settingsViewModel,
      builder: (context, child) {
        final settingsState = settingsViewModel.state;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)?.currencySettings ??
                  'Currency Settings',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.selectCurrency ??
                      'Select currency',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)?.selectCurrencyDescription ??
                      'Select your preferred currency for pricing and transactions.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                Expanded(
                  child: ListView.separated(
                    itemCount: currencies.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final currency = currencies[index];
                      final isSelected =
                          settingsState.currency == currency['code'];
                      return GestureDetector(
                        onTap: () {
                          settingsViewModel.updateCurrency(
                            currency['code'] as String,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(
                            AppDimensions.paddingMedium,
                          ),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMedium,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : theme.dividerColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  currency['flag'] as String,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              const SizedBox(
                                width: AppDimensions.paddingMedium,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currency['name'] as String,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    Text(
                                      currency['code'] as String,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.circle,
                                  color: AppColors.primary,
                                  size: 16,
                                )
                              else
                                Icon(
                                  Icons.circle_outlined,
                                  color: theme.disabledColor,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)?.savePreference ??
                          'Save Preference',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
