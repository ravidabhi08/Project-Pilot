import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_card.dart';
import 'package:taskflow_pro/data/models/dashboard_stats_model.dart';

class RecentActivityCard extends StatelessWidget {
  final RecentActivity activity;

  const RecentActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: _getActivityColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
              ),
              child: Icon(
                _getActivityIcon(),
                color: _getActivityColor(),
                size: AppDimensions.iconSizeMedium,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall / 2),
                  Text(
                    activity.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMedium),
            Text(
              _formatTimestamp(activity.timestamp),
              style: AppTextStyles.caption.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getActivityColor() {
    switch (activity.type) {
      case 'task_created':
        return AppColors.primary;
      case 'task_completed':
        return AppColors.success;
      case 'project_created':
        return AppColors.secondary;
      case 'comment_added':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  IconData _getActivityIcon() {
    switch (activity.type) {
      case 'task_created':
        return Icons.add_task;
      case 'task_completed':
        return Icons.check_circle;
      case 'project_created':
        return Icons.folder;
      case 'comment_added':
        return Icons.comment;
      default:
        return Icons.info;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}
