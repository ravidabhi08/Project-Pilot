import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  taskAssigned,
  taskCompleted,
  taskDue,
  projectUpdated,
  teamMemberAdded,
  commentAdded,
  deadlineApproaching,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.taskAssigned:
        return 'Task Assigned';
      case NotificationType.taskCompleted:
        return 'Task Completed';
      case NotificationType.taskDue:
        return 'Task Due';
      case NotificationType.projectUpdated:
        return 'Project Updated';
      case NotificationType.teamMemberAdded:
        return 'Team Member Added';
      case NotificationType.commentAdded:
        return 'Comment Added';
      case NotificationType.deadlineApproaching:
        return 'Deadline Approaching';
    }
  }

  String get iconName {
    switch (this) {
      case NotificationType.taskAssigned:
        return 'assignment';
      case NotificationType.taskCompleted:
        return 'check_circle';
      case NotificationType.taskDue:
        return 'schedule';
      case NotificationType.projectUpdated:
        return 'update';
      case NotificationType.teamMemberAdded:
        return 'person_add';
      case NotificationType.commentAdded:
        return 'comment';
      case NotificationType.deadlineApproaching:
        return 'warning';
    }
  }
}

class NotificationModel {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => NotificationType.taskAssigned,
      ),
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      data: data['data'],
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type.name,
      'title': title,
      'message': message,
      'data': data,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
