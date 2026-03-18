import 'package:get/get.dart';
import 'package:taskflow_pro/data/models/notification_model.dart';
import 'package:taskflow_pro/data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _notificationRepository;

  NotificationController(this._notificationRepository);

  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> _unreadNotifications = <NotificationModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications => _unreadNotifications;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  int get unreadCount => _unreadNotifications.length;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      // TODO: Get current user ID from auth controller
      const userId = 'current_user_id';
      final notifications = await _notificationRepository.getNotifications(userId);
      final unreadNotifications = await _notificationRepository.getUnreadNotifications(userId);
      _notifications.assignAll(notifications);
      _unreadNotifications.assignAll(unreadNotifications);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationRepository.markAsRead(notificationId);
      final notification = _notifications.firstWhere((n) => n.id == notificationId);
      final updatedNotification = notification.copyWith(isRead: true);
      final index = _notifications.indexOf(notification);
      _notifications[index] = updatedNotification;
      _unreadNotifications.remove(notification);
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  Future<void> markAllAsRead() async {
    try {
      // TODO: Get current user ID from auth controller
      const userId = 'current_user_id';
      await _notificationRepository.markAllAsRead(userId);
      for (var notification in _notifications) {
        if (!notification.isRead) {
          final index = _notifications.indexOf(notification);
          _notifications[index] = notification.copyWith(isRead: true);
        }
      }
      _unreadNotifications.clear();
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationRepository.deleteNotification(notificationId);
      _notifications.removeWhere((n) => n.id == notificationId);
      _unreadNotifications.removeWhere((n) => n.id == notificationId);
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  Future<void> createNotification({
    required NotificationType type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      // TODO: Get current user ID from auth controller
      const userId = 'current_user_id';
      final notification = NotificationModel(
        id: '',
        userId: userId,
        type: type,
        title: title,
        message: message,
        data: data,
        isRead: false,
        createdAt: DateTime.now(),
      );
      await _notificationRepository.createNotification(notification);
      await loadNotifications(); // Refresh the list
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
