import 'package:taskflow_pro/data/datasources/notification_datasource.dart';
import 'package:taskflow_pro/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<List<NotificationModel>> getUnreadNotifications(String userId);
  Future<String> createNotification(NotificationModel notification);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDatasource _notificationDatasource;

  NotificationRepositoryImpl(this._notificationDatasource);

  @override
  Future<List<NotificationModel>> getNotifications(String userId) =>
      _notificationDatasource.getNotifications(userId);

  @override
  Future<List<NotificationModel>> getUnreadNotifications(String userId) =>
      _notificationDatasource.getUnreadNotifications(userId);

  @override
  Future<String> createNotification(NotificationModel notification) =>
      _notificationDatasource.createNotification(notification);

  @override
  Future<void> markAsRead(String notificationId) =>
      _notificationDatasource.markAsRead(notificationId);

  @override
  Future<void> markAllAsRead(String userId) => _notificationDatasource.markAllAsRead(userId);

  @override
  Future<void> deleteNotification(String notificationId) =>
      _notificationDatasource.deleteNotification(notificationId);
}
