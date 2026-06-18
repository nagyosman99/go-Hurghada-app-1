import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/home/presentation/widgets/home/home_offers_header.dart';
import 'package:go_hurghada/features/home/presentation/widgets/home/offer_card.dart';

class HomeOffers extends StatelessWidget {
  final List<OfferCardModel> offers;

  const HomeOffers({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeOffersHeader(onSeeAll: () => context.push(AppRouter.allOffers)),
        const SizedBox(height: 12),
        SizedBox(
          height: 540,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 280,
                child: OfferCard(
                  offer: offers[index],
                  onTap: () {
                    context.push(
                      AppRouter.hotelOfferResults,
                      extra: offers[index],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
