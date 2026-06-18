import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

/// A shared warning widget for room capacity issues.
class CapacityWarning extends StatelessWidget {
  const CapacityWarning({super.key, required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 14,
              color: Colors.orange.shade800,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                l10n.availableWithWarning,
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          l10n.childrenMayShareBeds,
          style: TextStyle(color: Colors.orange.shade800, fontSize: 10),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// A shared reserve button for room cards.
class ReserveButton extends StatelessWidget {
  const ReserveButton({
    super.key,
    required this.canBook,
    required this.onPressed,
    required this.l10n,
    this.height = 50,
  });

  final bool canBook;
  final VoidCallback onPressed;
  final AppLocalizations l10n;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: canBook ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canBook ? AppColors.primary : Colors.grey.shade400,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade400,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          canBook ? l10n.reserve : l10n.tooSmall,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// A shared status row (e.g., Free Cancellation).
class RoomStatusRow extends StatelessWidget {
  const RoomStatusRow({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 16,
          color: Color(0xFF008009),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF008009),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

/// A shared badge for room views (Garden, Sea, etc.).
class RoomViewBadge extends StatelessWidget {
  const RoomViewBadge({super.key, required this.view});
  final String view;

  @override
  Widget build(BuildContext context) {
    final isGarden = view.contains('Garden');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGarden ? Icons.park : Icons.water,
            size: 16,
            color: const Color(0xFF34495e),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              view,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF34495e),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// A shared error message for room capacity violations.
class RoomCapacityError extends StatelessWidget {
  const RoomCapacityError({
    super.key,
    required this.roomCapacity,
    required this.adultsPerRoom,
    required this.l10n,
  });

  final int roomCapacity;
  final num adultsPerRoom;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.roomCapacityWarning(roomCapacity, adultsPerRoom.toInt()),
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
