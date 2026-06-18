import 'package:flutter/material.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';

/// Widget that observes app lifecycle and refreshes data on resume
class AppLifecycleObserver extends StatefulWidget {
  final Widget child;

  const AppLifecycleObserver({super.key, required this.child});

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Nuclear Refresh: If app returns from background, refresh key data ViewModels
    // to ensure they absolutely re-fetch fresh data from the source.
    if (state == AppLifecycleState.resumed) {
      debugPrint('App resumed: Refreshing data for fresh load');

      // Refresh MVVM ViewModels
      final appProvider = AppProvider.of(context);
      appProvider.activitiesViewModel.loadActivities();
      appProvider.myBookingsViewModel.loadBookings();
      appProvider.homeViewModel.loadHomeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
