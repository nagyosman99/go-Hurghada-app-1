import 'package:flutter/material.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class GuestInfoBanner extends StatelessWidget {
  final int totalGuests;
  final int roomsCount;
  final int guestsPerRoom;

  const GuestInfoBanner({
    super.key,
    required this.totalGuests,
    required this.roomsCount,
    required this.guestsPerRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(
                context,
              )!.guestInfoBannerFormat(totalGuests, roomsCount, guestsPerRoom),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
