import 'package:flutter/material.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_card.dart';

class DashboardQuickActionsSection extends StatelessWidget {
  final VoidCallback onCreateProject;
  final VoidCallback onCreateTask;

  const DashboardQuickActionsSection({
    super.key,
    required this.onCreateProject,
    required this.onCreateTask,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppDimensions.paddingSmall),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add,
                label: 'New Project',
                onPressed: onCreateProject,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.task_alt,
                label: 'New Task',
                onPressed: onCreateTask,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickActionButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(label, style: AppTextStyles.labelMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
