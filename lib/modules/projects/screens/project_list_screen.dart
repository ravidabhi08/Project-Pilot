import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_button.dart';
import 'package:taskflow_pro/core/widgets/loading_indicator.dart';
import 'package:taskflow_pro/modules/projects/controllers/project_controller.dart';
import 'package:taskflow_pro/modules/projects/widgets/project_card.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectController(Get.find()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
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
        ],
      ),
      body: Obx(() {
        if (controller.isLoading && controller.projects.isEmpty) {
          return const Center(child: LoadingIndicator(size: 32));
        }

        if (controller.projects.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProjects,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            itemCount: controller.projects.length,
            itemBuilder: (context, index) {
              final project = controller.projects[index];
              return ProjectCard(
                project: project,
                onTap: () {
                  // TODO: Navigate to project details screen
                  // context.push('${AppRoutes.projectDetails}/${project.id}');
                },
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create project screen
          // context.push(AppRoutes.createProject);
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
            Icons.folder_open,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text('No projects yet', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            'Create your first project to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingExtraLarge),
          CustomButton(
            text: 'Create Project',
            onPressed: () {
              // TODO: Navigate to create project screen
              // context.push(AppRoutes.createProject);
            },
          ),
        ],
      ),
    );
  }
}
