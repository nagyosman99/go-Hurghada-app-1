import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/activities_category_filter.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/activities_list_header.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/activity_card.dart';

class ActivitiesListPage extends StatefulWidget {
  final String? initialCategory;

  const ActivitiesListPage({super.key, this.initialCategory});

  @override
  State<ActivitiesListPage> createState() => _ActivitiesListPageState();
}

class _ActivitiesListPageState extends State<ActivitiesListPage> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      if (widget.initialCategory != null) {
        final viewModel = AppProvider.of(context).activitiesViewModel;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.filterByCategory(widget.initialCategory!);
        });
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = AppProvider.of(context).activitiesViewModel;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final state = viewModel.state;

          return CustomScrollView(
            slivers: [
              // Header
              const ActivitiesListHeader(),

              // Categories
              ActivitiesCategoryFilter(
                selectedCategory: state.selectedCategory,
                onCategorySelected: viewModel.filterByCategory,
              ),

              // List
              SliverPadding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                sliver: state.isLoading
                    ? const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : state.error != null
                    ? SliverFillRemaining(
                        child: Center(child: Text('Error: ${state.error}')),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final activity = state.filteredActivities[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ActivityCard(activity: activity),
                          );
                        }, childCount: state.filteredActivities.length),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
