import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/activities/domain/entities/activity.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/activity_booking_bar.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/activity_quick_info.dart';
import 'package:go_hurghada/shared/widgets/rating_badge.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/image_slider_with_indicator.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/section_header.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/included_item.dart';
import 'package:go_hurghada/features/activities/presentation/widgets/pickup_info_card.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class ActivityDetailsPage extends StatefulWidget {
  final String activityId;

  const ActivityDetailsPage({super.key, required this.activityId});

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  bool _isDescriptionExpanded = false;
  bool _isIncludedExpanded = false;
  Activity? _activity;
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadActivity();
      _isInitialized = true;
    }
  }

  Future<void> _loadActivity() async {
    final viewModel = AppProvider.of(context).activitiesViewModel;

    // Check if activities are already loaded
    if (viewModel.state.activities.isEmpty) {
      await viewModel.loadActivities();
    }

    _activity = viewModel.getActivityById(widget.activityId);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_activity == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Activity not found')),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image Slider
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ImageSliderWithIndicator(
                images: _activity!.images,
                height: 300,
                heroTag: 'activity_${_activity!.id}',
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).cardColor,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home/activities');
                  }
                },
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _activity!.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      RatingBadge(rating: _activity!.rating),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Category Chip
                  Chip(
                    label: Text(_activity!.category),
                    backgroundColor: AppColors.categoryFlight,
                    labelStyle: const TextStyle(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),

                  // Quick Info Row (Scrollable)
                  ActivityQuickInfo(activity: _activity!),
                  const SizedBox(height: 24),

                  // Full Description
                  SectionHeader(title: l10n.description),
                  const SizedBox(height: 12),
                  Text(
                    _activity!.fullDescription,
                    maxLines: _isDescriptionExpanded ? null : 2,
                    overflow: _isDescriptionExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.6,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isDescriptionExpanded = !_isDescriptionExpanded;
                      });
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(
                      _isDescriptionExpanded ? l10n.showLess : l10n.showMore,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // What's Included
                  SectionHeader(title: l10n.whatsIncluded),
                  const SizedBox(height: 12),
                  ..._activity!.whatsIncluded
                      .take(
                        _isIncludedExpanded
                            ? _activity!.whatsIncluded.length
                            : 2,
                      )
                      .map(
                        (item) => IncludedItem(text: item, isIncluded: true),
                      ),
                  if (_activity!.whatsIncluded.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isIncludedExpanded = !_isIncludedExpanded;
                        });
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        _isIncludedExpanded
                            ? l10n.showLess
                            : '${l10n.showMore} (${_activity!.whatsIncluded.length - 2})',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // What's Not Included
                  SectionHeader(title: l10n.whatsNotIncluded),
                  const SizedBox(height: 12),
                  ..._activity!.whatsNotIncluded.map(
                    (item) => IncludedItem(text: item, isIncluded: false),
                  ),
                  const SizedBox(height: 24),

                  // Pickup Information (conditional)
                  if (_activity!.pickupIncluded &&
                      _activity!.pickupInfo != null) ...[
                    SectionHeader(title: l10n.pickupInformation),
                    const SizedBox(height: 12),
                    PickupInfoCard(pickupInfo: _activity!.pickupInfo!),
                    const SizedBox(height: 24),
                  ],

                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ActivityBookingBar(activity: _activity!),
    );
  }
}
