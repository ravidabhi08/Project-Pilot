import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_card.dart';
import 'package:taskflow_pro/data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final ValueChanged<TaskStatus>? onStatusChanged;

  const TaskCard({super.key, required this.task, this.onTap, this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            if (task.description.isNotEmpty) ...[
              Text(
                task.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
            ],
            Row(
              children: [
                _buildPriorityIndicator(),
                const SizedBox(width: AppDimensions.paddingMedium),
                if (task.dueDate != null) ...[
                  Icon(
                    Icons.calendar_today,
                    size: AppDimensions.iconSizeSmall,
                    color: _getDueDateColor(),
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall / 2),
                  Text(
                    DateFormat('MMM d').format(task.dueDate!),
                    style: AppTextStyles.caption.copyWith(color: _getDueDateColor()),
                  ),
                ],
                const Spacer(),
                if (task.checklist.isNotEmpty) ...[
                  Icon(
                    Icons.checklist,
                    size: AppDimensions.iconSizeSmall,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall / 2),
                  Text(
                    '${task.checklist.where((item) => item.isCompleted).length}/${task.checklist.length}',
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
            if (task.labels.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingMedium),
              Wrap(
                spacing: AppDimensions.paddingSmall,
                runSpacing: AppDimensions.paddingSmall / 2,
                children: task.labels.map((label) => _buildLabelChip(label)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return GestureDetector(
      onTap: onStatusChanged != null ? () => _showStatusMenu(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall, vertical: 2),
        decoration: BoxDecoration(
          color: _getStatusColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
          border: Border.all(color: _getStatusColor().withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: _getStatusColor(), shape: BoxShape.circle),
            ),
            const SizedBox(width: AppDimensions.paddingSmall / 2),
            Text(
              task.status.displayName,
              style: AppTextStyles.caption.copyWith(
                color: _getStatusColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onStatusChanged != null) ...[
              const SizedBox(width: AppDimensions.paddingSmall / 2),
              Icon(Icons.arrow_drop_down, size: 14, color: _getStatusColor()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall, vertical: 2),
      decoration: BoxDecoration(
        color: _getPriorityColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      ),
      child: Text(
        task.priority.displayName,
        style: AppTextStyles.caption.copyWith(
          color: _getPriorityColor(),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLabelChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.todo:
        return AppColors.secondary;
      case TaskStatus.inProgress:
        return AppColors.primary;
      case TaskStatus.review:
        return AppColors.warning;
      case TaskStatus.done:
        return AppColors.success;
    }
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.low:
        return AppColors.info;
      case TaskPriority.medium:
        return AppColors.secondary;
      case TaskPriority.high:
        return AppColors.warning;
      case TaskPriority.urgent:
        return AppColors.error;
    }
  }

  Color _getDueDateColor() {
    if (task.dueDate == null) return AppColors.textSecondaryLight;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);

    if (dueDate.isBefore(today)) {
      return AppColors.error;
    } else if (dueDate.isAtSameMomentAs(today)) {
      return AppColors.warning;
    } else {
      return AppColors.textSecondaryLight;
    }
  }

  void _showStatusMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children:
                TaskStatus.values.map((status) {
                  return ListTile(
                    leading: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getStatusColorForStatus(status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(status.displayName),
                    onTap: () {
                      Navigator.pop(context);
                      onStatusChanged?.call(status);
                    },
                  );
                }).toList(),
          ),
    );
  }

  Color _getStatusColorForStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.secondary;
      case TaskStatus.inProgress:
        return AppColors.primary;
      case TaskStatus.review:
        return AppColors.warning;
      case TaskStatus.done:
        return AppColors.success;
    }
  }
}
