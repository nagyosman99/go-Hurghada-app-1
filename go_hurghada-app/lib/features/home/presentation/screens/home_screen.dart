import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/home/presentation/widgets/home/home_activities.dart';
import 'package:go_hurghada/features/home/presentation/widgets/home/home_categories.dart';
import 'package:go_hurghada/features/home/presentation/widgets/home/home_locations.dart';
import 'package:go_hurghada/features/home/presentation/widgets/home/home_offers.dart';
import 'package:go_hurghada/shared/widgets/custom_header.dart';
import 'package:go_hurghada/features/home/presentation/widgets/home/home_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = AppProvider.of(context).homeViewModel;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: homeViewModel,
          builder: (context, _) {
            final state = homeViewModel.state;

            if (state.isLoading && state.categories.isEmpty) {
              return const HomeSkeleton();
            }

            if (state.error != null && state.categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(
                            context,
                          )?.errorOccurred(state.error.toString()) ??
                          'Error: ${state.error}',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: homeViewModel.refreshHomeData,
                      child: Text(
                        AppLocalizations.of(context)?.retry ?? 'Retry',
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: homeViewModel.refreshHomeData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHeader(),
                      const SizedBox(height: 20),

                      // Categories
                      HomeCategories(categories: state.categories),
                      const SizedBox(height: 32),

                      // Popular Locations
                      HomeLocations(locations: state.locations),
                      const SizedBox(height: 32),

                      // Popular Activities
                      HomeActivities(activities: state.activities),
                      const SizedBox(height: 32),

                      // Best Offers
                      HomeOffers(offers: state.offers),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
