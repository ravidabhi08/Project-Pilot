import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';
import 'package:taskflow_pro/core/widgets/custom_button.dart';
import 'package:taskflow_pro/core/widgets/loading_indicator.dart';
import 'package:taskflow_pro/modules/notifications/controllers/notification_controller.dart';
import 'package:taskflow_pro/modules/notifications/widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Obx(() {
            if (controller.unreadCount > 0) {
              return TextButton(
                onPressed: controller.markAllAsRead,
                child: const Text('Mark all read'),
              );
            }
            return const SizedBox.shrink();
          }),
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
                Text(
                  'Error loading notifications',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  controller.errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                CustomButton(text: 'Retry', onPressed: controller.loadNotifications),
              ],
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                Text('No notifications yet', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  'You\'ll see updates about your tasks and projects here',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                child: NotificationCard(
                  notification: notification,
                  onTap: () => _handleNotificationTap(context, notification, controller),
                  onDismiss: () => controller.deleteNotification(notification.id),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    notification,
    NotificationController controller,
  ) {
    // Mark as read if not already read
    if (!notification.isRead) {
      controller.markAsRead(notification.id);
    }

    // Handle navigation based on notification type and data
    // TODO: Implement navigation to relevant screens based on notification data
    // For example, navigate to task details, project details, etc.

    // For now, just show a snackbar
    Get.snackbar(
      'Notification',
      notification.message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
