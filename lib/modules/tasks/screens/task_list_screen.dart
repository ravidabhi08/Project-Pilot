import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_button.dart';
import 'package:taskflow_pro/core/widgets/loading_indicator.dart';
import 'package:taskflow_pro/modules/tasks/controllers/task_controller.dart';
import 'package:taskflow_pro/modules/tasks/widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskController(Get.find()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // TODO: Handle sort options
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'due_date', child: Text('Sort by Due Date')),
                  const PopupMenuItem(value: 'priority', child: Text('Sort by Priority')),
                  const PopupMenuItem(value: 'status', child: Text('Sort by Status')),
                ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading && controller.tasks.isEmpty) {
          return const Center(child: LoadingIndicator(size: 32));
        }

        if (controller.tasks.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshTasks,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return TaskCard(
                task: task,
                onTap: () {
                  // TODO: Navigate to task details screen
                  // context.push('${AppRoutes.taskDetails}/${task.id}');
                },
                onStatusChanged: (status) {
                  controller.updateTask(task.copyWith(status: status));
                },
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create task screen
          // context.push(AppRoutes.createTask);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text('No tasks yet', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            'Create your first task to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingExtraLarge),
          CustomButton(
            text: 'Create Task',
            onPressed: () {
              // Navigate to create task
            },
          ),
        ],
      ),
    );
  }
}
