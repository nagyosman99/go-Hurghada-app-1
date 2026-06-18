import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/settings_viewmodel.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsViewModel = AppProvider.of(context).settingsViewModel;

    return ListenableBuilder(
      listenable: settingsViewModel,
      builder: (context, child) {
        final settingsState = settingsViewModel.state;

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.settingsTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.privacySecurity,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                _buildSwitchTile(
                  context,
                  icon: Icons.location_on,
                  title: AppLocalizations.of(context)!.locationAccess,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.locationAccessSubtitle,
                  value: settingsState.locationEnabled,
                  onChanged: settingsViewModel.toggleLocation,
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.share,
                  title: AppLocalizations.of(context)!.shareThirdParties,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.shareThirdPartiesSubtitle,
                  value: settingsState.thirdPartiesEnabled,
                  onChanged: settingsViewModel.toggleThirdParties,
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                Text(
                  AppLocalizations.of(context)!.themeTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                _buildSwitchTile(
                  context,
                  icon: Icons.dark_mode,
                  title: AppLocalizations.of(context)!.darkMode,
                  value: settingsState.themeMode == ThemeMode.dark,
                  onChanged: settingsViewModel.toggleTheme,
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                Text(
                  AppLocalizations.of(context)!.notificationsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                _buildSwitchTile(
                  context,
                  icon: Icons.local_offer,
                  title: AppLocalizations.of(context)!.offersPromotions,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.offersPromotionsSubtitle,
                  value: settingsState.notificationsEnabled,
                  onChanged: settingsViewModel.toggleNotifications,
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.notifications_active,
                  title: AppLocalizations.of(context)!.reminders,
                  subtitle: AppLocalizations.of(context)!.remindersSubtitle,
                  value: true, // Mock value
                  onChanged: (val) {},
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.notifications_off,
                  title: AppLocalizations.of(context)!.silentMode,
                  subtitle: AppLocalizations.of(context)!.silentModeSubtitle,
                  value: false, // Mock
                  onChanged: (val) {},
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                Text(
                  AppLocalizations.of(context)!.generalTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(AppLocalizations.of(context)!.changeLanguage),
                  subtitle: Text(
                    settingsState.locale.languageCode == 'ar'
                        ? AppLocalizations.of(context)!.arabic
                        : AppLocalizations.of(context)!.english,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.grey,
                  ),
                  onTap: () {
                    _showLanguageDialog(context, settingsViewModel);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    SettingsViewModel settingsViewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        children: [
          SimpleDialogOption(
            onPressed: () {
              settingsViewModel.updateLocale(const Locale('en'));
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.english),
          ),
          SimpleDialogOption(
            onPressed: () {
              settingsViewModel.updateLocale(const Locale('ar'));
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.arabic),
          ),
        ],
      ),
    );
  }
}
