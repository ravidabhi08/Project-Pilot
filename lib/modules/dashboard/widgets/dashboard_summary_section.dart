import 'package:flutter/material.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/data/models/dashboard_stats_model.dart';
import 'package:taskflow_pro/modules/dashboard/widgets/stats_card.dart';

class DashboardSummarySection extends StatelessWidget {
  final DashboardStats stats;

  const DashboardSummarySection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid columns based on available width
        final crossAxisCount =
            constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 600
                ? 2
                : 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppDimensions.paddingSmall),
            GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppDimensions.paddingMedium,
              mainAxisSpacing: AppDimensions.paddingMedium,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                StatsCard(
                  title: 'Projects',
                  value: stats.totalProjects.toString(),
                  icon: Icons.folder,
                  color: AppColors.primary,
                ),
                StatsCard(
                  title: 'Tasks',
                  value: stats.totalTasks.toString(),
                  icon: Icons.task,
                  color: AppColors.secondary,
                ),
                StatsCard(
                  title: 'Completed',
                  value: stats.completedTasks.toString(),
                  icon: Icons.check_circle,
                  color: AppColors.success,
                ),
                StatsCard(
                  title: 'Pending',
                  value: stats.pendingTasks.toString(),
                  icon: Icons.pending,
                  color: AppColors.warning,
                ),
                StatsCard(
                  title: 'Overdue',
                  value: stats.overdueTasks.toString(),
                  icon: Icons.warning,
                  color: AppColors.error,
                ),
                StatsCard(
                  title: 'Due Today',
                  value: stats.tasksDueToday.toString(),
                  icon: Icons.today,
                  color: AppColors.info,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
