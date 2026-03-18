import 'package:flutter/material.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_card.dart';
import 'package:taskflow_pro/data/models/dashboard_stats_model.dart';
import 'package:taskflow_pro/modules/dashboard/widgets/recent_activity_card.dart';

class DashboardRecentActivitySection extends StatelessWidget {
  final List<RecentActivity> activities;
  final VoidCallback onViewAll;

  const DashboardRecentActivitySection({
    super.key,
    required this.activities,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Recent Activities', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            TextButton(onPressed: onViewAll, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        if (activities.isEmpty)
          CustomCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      'No recent activities',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length > 5 ? 5 : activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return RecentActivityCard(activity: activity);
            },
          ),
      ],
    );
  }
}
