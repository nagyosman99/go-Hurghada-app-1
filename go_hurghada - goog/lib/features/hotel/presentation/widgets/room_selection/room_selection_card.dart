import 'package:flutter/material.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/shared/room_card_shared_components.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class RoomSelectionCard extends StatelessWidget {
  const RoomSelectionCard({
    super.key,
    required this.room,
    required this.calculator,
    required this.onBook,
    this.discountPercentage,
  });

  final Room room;
  final HotelPriceCalculator calculator;
  final VoidCallback onBook;
  final double? discountPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final pricing = _RoomPricingData.calculate(
      room: room,
      calculator: calculator,
      discountPercentage: discountPercentage,
    );

    // Real app behavior: Check TOTAL guests (adults + children) fit
    final canAccommodate = calculator.guestsPerRoom <= room.capacity;

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      elevation: 0,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: const Color(0xFF1a1a1a),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            _buildContent(context, pricing, l10n, theme),
            const SizedBox(height: 16),
            if (!canAccommodate)
              RoomCapacityError(
                roomCapacity: room.capacity,
                adultsPerRoom: calculator.adultsPerRoom,
                l10n: l10n,
              ),
            RoomStatusRow(label: l10n.freeCancellation),
            const SizedBox(height: 20),
            _buildActionArea(l10n, canAccommodate),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    _RoomPricingData pricing,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppNetworkImage(
                  imageUrl: room.photos.isNotEmpty ? room.photos.first : '',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    height: 140,
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.bed, color: Colors.grey),
                  ),
                ),
              ),
              if (room.view != null) ...[
                const SizedBox(height: 12),
                RoomViewBadge(view: room.view!),
              ],
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 6,
          child: _buildPricingSection(context, pricing, l10n, theme),
        ),
      ],
    );
  }

  Widget _buildPricingSection(
    BuildContext context,
    _RoomPricingData pricing,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (pricing.discountPercent != null)
          _DiscountBadge(percent: pricing.discountPercent!),
        Text(
          '${l10n.nightsCountFormat(calculator.params.nights)}, ${l10n.guestsCountFormat(calculator.params.adults, calculator.params.children)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        if (pricing.displayOriginalPrice != null)
          Text(
            pricing.displayOriginalPrice!.formatPrice(context),
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Color(0xFFc60000),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              pricing.totalPrice.formatPrice(context),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                fontSize: 24,
              ),
            ),
            if (calculator.params.rooms > 1) ...[
              const SizedBox(width: 4),
              Text(
                'for ${calculator.params.rooms} rooms',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        _FeatureRow(icon: Icons.bed_outlined, text: room.bedConfiguration),
        const SizedBox(height: 8),
        _FeatureRow(
          icon: Icons.square_foot,
          text: '${room.size.toStringAsFixed(0)} m²',
        ),
      ],
    );
  }

  Widget _buildActionArea(AppLocalizations l10n, bool canBook) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Row(
        children: [
          Expanded(
            child: ReserveButton(
              canBook: canBook,
              onPressed: onBook,
              l10n: l10n,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomPricingData {
  final double totalPrice;
  final double? displayOriginalPrice;
  final int? discountPercent;

  _RoomPricingData({
    required this.totalPrice,
    this.displayOriginalPrice,
    this.discountPercent,
  });

  factory _RoomPricingData.calculate({
    required Room room,
    required HotelPriceCalculator calculator,
    double? discountPercentage,
  }) {
    final baseTotal = calculator.totalPrice;
    if (room.originalPrice != null && room.originalPrice! > room.price) {
      final original =
          room.originalPrice! *
          calculator.params.nights *
          (calculator.params.rooms > 0 ? calculator.params.rooms : 1);
      return _RoomPricingData(
        totalPrice: baseTotal,
        displayOriginalPrice: original,
        discountPercent:
            ((room.originalPrice! - room.price) / room.originalPrice! * 100)
                .round(),
      );
    } else if (discountPercentage != null && discountPercentage > 0) {
      return _RoomPricingData(
        totalPrice: calculator.getDiscountedPrice(discountPercentage),
        displayOriginalPrice: baseTotal,
        discountPercent: (discountPercentage * 100).round(),
      );
    }
    return _RoomPricingData(totalPrice: baseTotal);
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.percent});
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFe74c3c),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$percent% OFF',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
