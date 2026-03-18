import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_button.dart';
import 'package:taskflow_pro/core/widgets/custom_text_field.dart';
import 'package:taskflow_pro/core/widgets/loading_indicator.dart';
import 'package:taskflow_pro/data/models/user_model.dart';
import 'package:taskflow_pro/modules/profile/controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProfileDialog(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const LoadingIndicator();
        }

        final user = controller.currentUser;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: AppDimensions.paddingLarge),
                Text('Failed to load profile', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppDimensions.paddingLarge),
                CustomButton(text: 'Retry', onPressed: controller.loadUserProfile),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),

              // Profile Information
              _buildProfileInfoCard(context, 'Name', user.displayName ?? 'Not set', Icons.person),
              const SizedBox(height: AppDimensions.paddingMedium),

              _buildProfileInfoCard(context, 'Email', user.email, Icons.email),
              const SizedBox(height: AppDimensions.paddingMedium),

              _buildProfileInfoCard(context, 'Role', user.role.displayName, Icons.work),
              const SizedBox(height: AppDimensions.paddingMedium),

              _buildProfileInfoCard(
                context,
                'Member Since',
                '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                Icons.calendar_today,
              ),
              const SizedBox(height: AppDimensions.paddingLarge),

              // Action Buttons
              CustomButton(
                text: 'Change Password',
                onPressed: () => _showChangePasswordDialog(context, controller),
                width: double.infinity,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              CustomButton(
                text: 'Delete Account',
                onPressed: () => _showDeleteAccountDialog(context, controller),
                backgroundColor: Theme.of(context).colorScheme.error,
                width: double.infinity,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileInfoCard(BuildContext context, String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall / 2),
                  Text(value, style: AppTextStyles.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, ProfileController controller) {
    final nameController = TextEditingController(text: controller.currentUser?.displayName ?? '');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: nameController,
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              CustomButton(
                text: 'Save',
                onPressed: () async {
                  await controller.updateProfile(displayName: nameController.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, ProfileController controller) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: currentPasswordController,
                  labelText: 'Current Password',
                  hintText: 'Enter current password',
                  obscureText: true,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                CustomTextField(
                  controller: newPasswordController,
                  labelText: 'New Password',
                  hintText: 'Enter new password',
                  obscureText: true,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                CustomTextField(
                  controller: confirmPasswordController,
                  labelText: 'Confirm New Password',
                  hintText: 'Confirm new password',
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              CustomButton(
                text: 'Change',
                onPressed: () async {
                  if (newPasswordController.text == confirmPasswordController.text) {
                    await controller.changePassword(
                      currentPasswordController.text,
                      newPasswordController.text,
                    );
                    Navigator.of(context).pop();
                  } else {
                    Get.snackbar('Error', 'Passwords do not match');
                  }
                },
              ),
            ],
          ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  await controller.deleteAccount();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
