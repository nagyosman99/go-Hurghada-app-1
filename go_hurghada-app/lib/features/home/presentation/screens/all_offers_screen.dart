import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/home/presentation/widgets/home/offer_card.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/config/routes/app_router.dart';

class AllOffersScreen extends StatelessWidget {
  const AllOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = AppProvider.of(context).homeViewModel;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.bestOffers),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: ListenableBuilder(
        listenable: homeViewModel,
        builder: (context, _) {
          final state = homeViewModel.state;
          final offers = state.offers;

          if (state.isLoading && offers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (offers.isEmpty) {
            return Center(
              child: Text(
                l10n.noHotelsFound, // Reusing localized string for empty state
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            itemCount: offers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final offer = offers[index];
              return SizedBox(
                height: 310, // Explicit height for the vertical card
                child: OfferCard(
                  offer: offer,
                  onTap: () {
                    context.push(AppRouter.hotelOfferResults, extra: offer);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
