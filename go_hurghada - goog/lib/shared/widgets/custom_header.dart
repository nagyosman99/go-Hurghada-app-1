import 'package:flutter/material.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/config/constants/app_constants.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = AppProvider.of(context).profileViewModel;

    return ListenableBuilder(
      listenable: profileViewModel,
      builder: (context, _) {
        final user = profileViewModel.state;
        final hasImage =
            user.profileImagePath != null && user.profileImagePath!.isNotEmpty;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.welcomeBackComma ??
                      'Welcome back,',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 16, // Increased from 14
                  ),
                ),
                const SizedBox(height: 6), // Increased spacing
                Row(
                  children: [
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 26, // Explicitly increased size
                            color: Theme.of(
                              context,
                            ).textTheme.titleLarge?.color,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.flight_takeoff,
                      color: AppColors.primary,
                      size: 24, // Increased from 20
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                // Notification Button
                Container(
                  width: 30, // Increased from 40
                  height: 30, // Increased from 40
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: Theme.of(context).iconTheme.color,
                          size: 26, // Increased from 22
                        ),
                      ),
                      Positioned(
                        top: 12, // Adjusted for larger size
                        right: 12, // Adjusted for larger size
                        child: Container(
                          width: 10, // Increased from 8
                          height: 10, // Increased from 8
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Profile Avatar
                GestureDetector(
                  onTap: () {
                    context.push(AppRouter.profile);
                  },
                  child: Container(
                    width: 60, // Increased from 40
                    height: 60, // Increased from 40
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: hasImage
                          ? AppNetworkImage(
                              imageUrl: user.profileImagePath!,
                              width: 60, // Matched container
                              height: 60, // Matched container
                              fit: BoxFit.cover,
                            )
                          : AppNetworkImage(
                              imageUrl: 'https://i.pravatar.cc/150?u=${user.email}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorWidget: Container(
                                color: AppColors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
