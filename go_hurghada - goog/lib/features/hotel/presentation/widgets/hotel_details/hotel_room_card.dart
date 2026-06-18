import 'package:flutter/material.dart';
import 'package:go_hurghada/core/utils/pricing_models.dart';
import 'package:go_hurghada/features/hotel/domain/models/hotel_models.dart';
import 'package:go_hurghada/features/hotel/presentation/widgets/shared/room_card_shared_components.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/extensions/currency_extension.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class HotelRoomCard extends StatefulWidget {
  const HotelRoomCard({
    super.key,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.roomsCount,
    required this.adults,
    required this.children,
    this.discountPercentage,
    required this.onBook,
    this.isPerGuest = false,
  });

  final Room room;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int roomsCount;
  final int adults;
  final int children;
  final double? discountPercentage;
  final VoidCallback onBook;
  final bool isPerGuest;

  @override
  State<HotelRoomCard> createState() => _HotelRoomCardState();
}

class _HotelRoomCardState extends State<HotelRoomCard> {
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
    final calculator = _createCalculator();
    final discountedCalc = _createDiscountedCalculator(calculator);
    final canBook = calculator.guestsPerRoom <= widget.room.capacity;
    final hasDiscount = (widget.discountPercentage ?? 0) > 0;
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
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: const Color(0xFF1a1a1a),
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
                          if (hasDiscount) ...[
                            Text(
                              calculator.totalPrice.formatPrice(context),
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
                                '/ ${widget.roomsCount} ${widget.roomsCount == 1 ? l10n.room : l10n.rooms}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.checkIn != null
                                ? '${l10n.nightsCountFormat(calculator.params.nights)}, ${l10n.guestsCountFormat(widget.adults, widget.children)}'
                                : calculator.breakdown,
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
                if (!canBook) ...[
                  const SizedBox(height: 12),
                  RoomCapacityError(
                    roomCapacity: widget.room.capacity,
                    adultsPerRoom: calculator.adultsPerRoom,
                    l10n: l10n,
                  ),
                ],
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

  HotelPriceCalculator _createCalculator() {
    return HotelPriceCalculator(
      basePricePerUnit: widget.room.price,
      params: BookingParams(
        checkIn: widget.checkIn,
        checkOut: widget.checkOut,
        adults: widget.adults,
        children: widget.children,
        rooms: widget.roomsCount,
      ),
      isPerGuest: widget.isPerGuest,
    );
  }

  HotelPriceCalculator _createDiscountedCalculator(HotelPriceCalculator calc) {
    final discount = widget.discountPercentage ?? 0;
    final discountedPrice = widget.room.price * (1 - discount);
    return HotelPriceCalculator(
      basePricePerUnit: discountedPrice,
      params: calc.params,
      isPerGuest: calc.isPerGuest,
    );
  }
}
