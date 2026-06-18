import 'package:flutter/material.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class ActivitiesListHeader extends StatelessWidget {
  const ActivitiesListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 0,
      centerTitle: false,
      title: Text(
        AppLocalizations.of(context)?.activitiesInHurghada ??
            'Activities in Hurghada',
      ),
    );
  }
}
