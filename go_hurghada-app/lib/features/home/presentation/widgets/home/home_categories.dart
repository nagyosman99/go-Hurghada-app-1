import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/home/domain/models/travel_models.dart';
import 'package:go_hurghada/features/home/presentation/widgets/category_card.dart';

import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class HomeCategories extends StatelessWidget {
  final List<CategoryModel> categories;

  const HomeCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) {
          String localizedName = category.name;
          if (category.name == 'Flight') {
            localizedName = l10n.categoryFlight;
          } else if (category.name == 'Hotel') {
            localizedName = l10n.categoryHotel;
          } else if (category.name == 'Activities') {
            localizedName = l10n.categoryActivities;
          }

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CategoryCard(
                category: category,
                localizedName: localizedName,
                onTap: () {
                  if (category.name == 'Flight') {
                    context.push(AppRouter.flightSearch);
                  } else if (category.name == 'Hotel') {
                    context.push(AppRouter.hotel);
                  } else if (category.name == 'Activities') {
                    context.push(
                      AppRouter.activities,
                      extra: {'initialCategory': 'All'},
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => category.page),
                    );
                  }
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
