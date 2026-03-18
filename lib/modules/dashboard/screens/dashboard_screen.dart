import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/loading_indicator.dart';
import 'package:taskflow_pro/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:taskflow_pro/modules/dashboard/widgets/dashboard_project_progress_section.dart';
import 'package:taskflow_pro/modules/dashboard/widgets/dashboard_quick_actions_section.dart';
import 'package:taskflow_pro/modules/dashboard/widgets/dashboard_recent_activity_section.dart';
import 'package:taskflow_pro/modules/dashboard/widgets/dashboard_summary_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController(Get.find()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: controller.refreshDashboard),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading && !controller.hasData) {
          return const Center(child: LoadingIndicator(size: 32));
        }

        if (controller.errorMessage.isNotEmpty && !controller.hasData) {
          return _DashboardErrorView(
            message: controller.errorMessage,
            onRetry: controller.refreshDashboard,
          );
        }

        return LoadingOverlay(
          isLoading: controller.isLoading,
          child: RefreshIndicator(
            onRefresh: controller.refreshDashboard,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 1000;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      Text('Welcome back!', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Text(
                        'Here\'s an overview of your projects and tasks.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),

                      // Dashboard layout
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DashboardSummarySection(stats: controller.dashboardStats),
                                  const SizedBox(height: AppDimensions.paddingLarge),
                                  DashboardProjectProgressSection(
                                    completionRate: controller.completionRate,
                                    completedTasks: controller.dashboardStats.completedTasks,
                                    totalTasks: controller.dashboardStats.totalTasks,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingLarge),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DashboardRecentActivitySection(
                                    activities: controller.recentActivities,
                                    onViewAll: () {
                                      // TODO: Navigate to full activity screen
                                    },
                                  ),
                                  const SizedBox(height: AppDimensions.paddingLarge),
                                  DashboardQuickActionsSection(
                                    onCreateProject: () {
                                      // TODO: Navigate to create project
                                    },
                                    onCreateTask: () {
                                      // TODO: Navigate to create task
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      else ...[
                        DashboardSummarySection(stats: controller.dashboardStats),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        DashboardProjectProgressSection(
                          completionRate: controller.completionRate,
                          completedTasks: controller.dashboardStats.completedTasks,
                          totalTasks: controller.dashboardStats.totalTasks,
                        ),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        DashboardRecentActivitySection(
                          activities: controller.recentActivities,
                          onViewAll: () {
                            // TODO: Navigate to full activity screen
                          },
                        ),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        DashboardQuickActionsSection(
                          onCreateProject: () {
                            // TODO: Navigate to create project
                          },
                          onCreateTask: () {
                            // TODO: Navigate to create task
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class _DashboardErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _DashboardErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
