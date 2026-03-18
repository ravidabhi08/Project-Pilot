import 'package:flutter/material.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';

class DashboardProjectProgressSection extends StatelessWidget {
  final double completionRate;
  final int completedTasks;
  final int totalTasks;

  const DashboardProjectProgressSection({
    super.key,
    required this.completionRate,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Project Progress', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          totalTasks == 0
              ? 'No tasks yet. Create a project to get started.'
              : '${(completionRate * 100).toStringAsFixed(0)}% complete',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        LinearProgressIndicator(
          value: completionRate,
          minHeight: 10,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppDimensions.paddingLarge),
        if (totalTasks > 0) ...[
          Text(
            'Completed $completedTasks of $totalTasks tasks',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }
}
