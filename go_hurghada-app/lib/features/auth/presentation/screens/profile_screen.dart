import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ProfileViewModel should now be powered by FirebaseAuthRepository in DI
    final profileViewModel = AppProvider.of(context).profileViewModel;
    final settingsViewModel = AppProvider.of(context).settingsViewModel;

    return ListenableBuilder(
      listenable: profileViewModel,
      builder: (context, child) {
        final userProfile = profileViewModel.state;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)?.myAccount ?? 'My Account',
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => context.go(AppRouter.home),
            ),
            actions: [
              ListenableBuilder(
                listenable: settingsViewModel,
                builder: (context, _) {
                  final themeMode = settingsViewModel.state.themeMode;
                  final isDark =
                      themeMode == ThemeMode.dark ||
                      (themeMode == ThemeMode.system &&
                          MediaQuery.platformBrightnessOf(context) ==
                              Brightness.dark);

                  return IconButton(
                    icon: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    ),
                    onPressed: () {
                      settingsViewModel.toggleTheme(!isDark);
                    },
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Blue Header Section
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Profile Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'profile_image',
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: userProfile.profileImagePath != null
                                  ? ClipOval(
                                      child:
                                          userProfile.profileImagePath!
                                              .startsWith('http')
                                          ? AppNetworkImage(
                                              imageUrl: userProfile.profileImagePath!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(
                                                userProfile.profileImagePath!,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: theme.iconTheme.color,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProfile.fullName.isNotEmpty
                                      ? userProfile.fullName
                                      : AppLocalizations.of(
                                              context,
                                            )?.guestUser ??
                                            'Guest User',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  userProfile.email.isNotEmpty
                                      ? userProfile.email
                                      : AppLocalizations.of(
                                              context,
                                            )?.noEmailSet ??
                                            'No email set',
                                  style: theme.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: theme.iconTheme.color,
                            ),
                            onPressed: () =>
                                context.push(AppRouter.editProfile),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Main Action Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              context,
                              title:
                                  AppLocalizations.of(
                                    context,
                                  )?.currencySettings ??
                                  'Currency Settings',
                              icon: Icons.currency_exchange,
                              color: const Color(0xFFFFE0B2), // Light Orange
                              onTap: () =>
                                  context.push(AppRouter.currencySettings),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              context,
                              title:
                                  AppLocalizations.of(
                                    context,
                                  )?.accountSettings ??
                                  'Account Settings',
                              icon: Icons.settings,
                              color: AppColors.primary,
                              textColor: AppColors.white,
                              onTap: () => context.push(AppRouter.settings),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // My Bookings Button
                      _buildActionCard(
                        context,
                        title:
                            AppLocalizations.of(context)?.myBookingsButton ??
                            'My Bookings',
                        icon: Icons.receipt_long,
                        color: const Color(0xFFB3E5FC), // Light Blue
                        onTap: () => context.push(AppRouter.myBookings),
                      ),
                    ],
                  ),
                ),
              ),

              // Logout Button - Pinned to bottom
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final authVM = AppProvider.of(context).authViewModel;
                      final profileVM = AppProvider.of(context).profileViewModel;
                      await authVM.signOut();
                      await profileVM.clearProfile();
                      if (context.mounted) {
                        context.go(AppRouter.signIn);
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(
                      AppLocalizations.of(context)?.logOut ?? 'Log out',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.authSecondary, // Pink/Red
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: textColor ?? theme.iconTheme.color),
            const SizedBox(height: 12),
            Text(
              title.replaceFirst(' ', '\n'), // Force wrap for design match
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor ?? theme.textTheme.titleMedium?.color,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
