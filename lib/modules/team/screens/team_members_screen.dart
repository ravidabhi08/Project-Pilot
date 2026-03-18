import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_button.dart';
import 'package:taskflow_pro/core/widgets/loading_indicator.dart';
import 'package:taskflow_pro/modules/team/controllers/team_controller.dart';

class TeamMembersScreen extends StatelessWidget {
  const TeamMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateTeamDialog(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const LoadingIndicator();
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: AppDimensions.paddingLarge),
                Text('Error loading teams', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  controller.errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                CustomButton(text: 'Retry', onPressed: controller.loadTeams),
              ],
            ),
          );
        }

        if (controller.teams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                Text('No teams yet', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  'Create your first team to get started',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                CustomButton(
                  text: 'Create Team',
                  onPressed: () => _showCreateTeamDialog(context, controller),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          itemCount: controller.teams.length,
          itemBuilder: (context, index) {
            final team = controller.teams[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
              child: Card(
                child: ListTile(
                  title: Text(team.name),
                  subtitle: Text(team.description),
                  trailing: Text('${team.memberIds.length} members'),
                  onTap: () => _showTeamDetails(context, team, controller),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showCreateTeamDialog(BuildContext context, TeamController controller) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create New Team'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Team Name',
                    hintText: 'Enter team name',
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter team description',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              CustomButton(
                text: 'Create',
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    await controller.createTeam(nameController.text, descriptionController.text);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
    );
  }

  void _showTeamDetails(BuildContext context, team, TeamController controller) {
    // TODO: Navigate to team details screen
    // For now, show a simple dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(team.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(team.description),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text('${team.memberIds.length} members'),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
            ],
          ),
    );
  }
}
