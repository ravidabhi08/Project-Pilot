import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/modules/settings/controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appearance Section
              _buildSectionHeader(context, 'Appearance'),
              _buildSettingTile(
                context,
                'Dark Mode',
                'Toggle between light and dark themes',
                trailing: Switch(
                  value: controller.isDarkMode,
                  onChanged: (_) => controller.toggleDarkMode(),
                ),
              ),
              const Divider(),

              // Notifications Section
              _buildSectionHeader(context, 'Notifications'),
              _buildSettingTile(
                context,
                'Push Notifications',
                'Receive notifications about tasks and updates',
                trailing: Switch(
                  value: controller.notificationsEnabled,
                  onChanged: (_) => controller.toggleNotifications(),
                ),
              ),
              const Divider(),

              // Language Section
              _buildSectionHeader(context, 'Language'),
              _buildSettingTile(
                context,
                'App Language',
                'Choose your preferred language',
                trailing: DropdownButton<String>(
                  value: controller.language,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'fr', child: Text('Français')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.setLanguage(value);
                    }
                  },
                ),
              ),
              const Divider(),

              // Data & Storage Section
              _buildSectionHeader(context, 'Data & Storage'),
              _buildSettingTile(
                context,
                'Clear Cache',
                'Free up storage space by clearing cached data',
                onTap: () => _showClearCacheDialog(context, controller),
              ),
              _buildSettingTile(
                context,
                'Export Data',
                'Download a copy of your data',
                onTap: () => _showExportDataDialog(context, controller),
              ),
              const Divider(),

              // Account Section
              _buildSectionHeader(context, 'Account'),
              _buildSettingTile(
                context,
                'Reset Settings',
                'Restore all settings to default values',
                onTap: () => _showResetSettingsDialog(context, controller),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),

              // App Info Section
              _buildSectionHeader(context, 'About'),
              _buildSettingTile(context, 'Version', '1.0.0'),
              _buildSettingTile(
                context,
                'Privacy Policy',
                'Read our privacy policy',
                onTap: () {
                  // TODO: Navigate to privacy policy
                },
              ),
              _buildSettingTile(
                context,
                'Terms of Service',
                'Read our terms of service',
                onTap: () {
                  // TODO: Navigate to terms of service
                },
              ),
              _buildSettingTile(
                context,
                'Contact Support',
                'Get help or send feedback',
                onTap: () {
                  // TODO: Navigate to support
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    String subtitle, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showClearCacheDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cache'),
            content: const Text('This will clear all cached data. This action cannot be undone.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await controller.clearCache();
                  Get.snackbar('Success', 'Cache cleared successfully');
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  void _showExportDataDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Export Data'),
            content: const Text(
              'This will export all your data. The file will be saved to your downloads folder.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await controller.exportData();
                  Get.snackbar('Success', 'Data exported successfully');
                },
                child: const Text('Export'),
              ),
            ],
          ),
    );
  }

  void _showResetSettingsDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset Settings'),
            content: const Text(
              'This will reset all settings to their default values. This action cannot be undone.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await controller.resetSettings();
                  Get.snackbar('Success', 'Settings reset successfully');
                },
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }
}
