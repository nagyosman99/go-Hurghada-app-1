import 'package:flutter/material.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/shared/room_card_shared_components.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class RoomCard extends StatefulWidget {
  const RoomCard({
    super.key,
    required this.room,
    required this.calculator,
    required this.onBook,
    this.discountPercentage = 0.0,
  });

  final Room room;
  final HotelPriceCalculator calculator;
  final VoidCallback onBook;
  final double discountPercentage;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final discountedCalc = _createDiscountedCalculator();
    final canBook = widget.calculator.guestsPerRoom <= widget.room.capacity;
    final images = widget.room.photos.isNotEmpty
        ? widget.room.photos
        : ['https://placehold.co/600x400/png?text=No+Image'];

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Carousel with overlays
          Stack(
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentImageIndex = i),
                  itemCount: images.length,
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AppNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorWidget: Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.bed,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Page indicator dots
              if (images.length > 1)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (index) => Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(
                            alpha: _currentImageIndex == index ? 0.9 : 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // View badge
              if (widget.room.view != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: RoomViewBadge(view: widget.room.view!),
                ),
              // Discount badge
              if (widget.discountPercentage > 0)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFe74c3c),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${(widget.discountPercentage * 100).toStringAsFixed(0)}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Title
                Text(
                  widget.room.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: const Color(0xFF1a1a1a),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. One-line Room Specs (Bed | Size | Guests)
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bed,
                          size: 20,
                          color: Color(0xFF0084ff),
                        ),
                        const SizedBox(width: 6),
                        Text(widget.room.bedConfiguration, style: _specStyle()),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.straighten,
                          size: 20,
                          color: Color(0xFF0084ff),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.room.size.toInt()} m²',
                          style: _specStyle(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.groups_outlined,
                          size: 20,
                          color: Color(0xFF0084ff),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.maxGuests(widget.room.capacity),
                          style: _specStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Amenities List (Checkmarks)
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: widget.room.amenities
                      .take(4)
                      .map(
                        (amenity) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 18,
                              color: Color(0xFF0084ff),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              amenity,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),

                const Divider(height: 1),
                const SizedBox(height: 16),

                // 5. Price & Action Row (Bottom)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left: Price Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.discountPercentage > 0) ...[
                            Text(
                              widget.calculator.totalPrice.formatPrice(context),
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                discountedCalc.totalPrice.formatPrice(context),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '/ ${widget.calculator.params.rooms} ${widget.calculator.params.rooms == 1 ? l10n.room : l10n.rooms}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.calculator.params.checkIn != null
                                ? '${l10n.nightsCountFormat(widget.calculator.params.nights)}, ${l10n.guestsCountFormat(widget.calculator.params.adults, widget.calculator.params.children)}'
                                : widget.calculator.breakdown,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right: Reserve Button
                    ReserveButton(
                      canBook: canBook,
                      onPressed: widget.onBook,
                      l10n: l10n,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _specStyle() => const TextStyle(
    fontSize: 14,
    color: Color(0xFF1a1a1a),
    fontWeight: FontWeight.w500,
  );

  HotelPriceCalculator _createDiscountedCalculator() {
    final discountedPrice = widget.room.price * (1 - widget.discountPercentage);
    return HotelPriceCalculator(
      basePricePerUnit: discountedPrice,
      params: widget.calculator.params,
      isPerGuest: widget.calculator.isPerGuest,
    );
  }
}
