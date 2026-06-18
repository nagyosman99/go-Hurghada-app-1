import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                0,
                Icons.home_rounded,
                AppLocalizations.of(context)?.navHome ?? 'Home',
              ),
              _buildNavItem(
                context,
                1,
                Icons.favorite_rounded,
                AppLocalizations.of(context)?.navSaved ?? 'Saved',
              ),
              const SizedBox(
                width: 80,
              ), // Increased from 48 to accommodate "My Bookings" text
              _buildNavItem(
                context,
                3,
                Icons.chat_bubble_rounded,
                AppLocalizations.of(context)?.navSupport ?? 'Support',
              ),
              _buildNavItem(
                context,
                4,
                Icons.person_rounded,
                AppLocalizations.of(context)?.navProfile ?? 'Profile',
              ),
            ],
          ),
          Positioned(
            top: -25,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: currentIndex == 2
                            ? AppColors.primary
                            : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                (currentIndex == 2
                                        ? AppColors.primary
                                        : Colors.black)
                                    .withValues(alpha: 0.2), // Adjusted alpha
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.confirmation_number_rounded,
                        color: currentIndex == 2
                            ? Colors.white
                            : Colors.blueGrey.withValues(alpha: 0.5),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)?.navMyBookings ??
                          'My Bookings',
                      style: TextStyle(
                        color: currentIndex == 2
                            ? AppColors.primary
                            : Colors.blueGrey.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: currentIndex == 2
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? AppColors.primary
        : Colors.blueGrey.withValues(alpha: 0.5);

    return InkWell(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
