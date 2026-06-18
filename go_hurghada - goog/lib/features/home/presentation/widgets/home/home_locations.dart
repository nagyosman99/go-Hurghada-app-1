import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/home/presentation/widgets/location_card.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class HomeLocations extends StatelessWidget {
  final List<LocationModel> locations;

  const HomeLocations({super.key, required this.locations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)?.popularDestinations ??
                    'Popular Hurghada Destinations',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: locations.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final location = locations[index];
              String localizedName = location.name;
              final l10n = AppLocalizations.of(context);

              if (location.name == 'El Gouna') {
                localizedName = l10n?.locationElGouna ?? location.name;
              } else if (location.name == 'Makadi Bay') {
                localizedName = l10n?.locationMakadiBay ?? location.name;
              } else if (location.name == 'Soma Bay') {
                localizedName = l10n?.locationSomaBay ?? location.name;
              } else if (location.name == 'Sahl Hasheesh') {
                localizedName = l10n?.locationSahlHasheesh ?? location.name;
              }

              return LocationCard(
                location: location,
                localizedName: localizedName,
                onTap: () {
                  // Navigate to hotel search screen with pre-filled location
                  context.push(
                    AppRouter.hotel,
                    extra: {'initialLocation': location.name},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
