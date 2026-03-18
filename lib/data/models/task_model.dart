import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { todo, inProgress, review, done }

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.review:
        return 'Review';
      case TaskStatus.done:
        return 'Done';
    }
  }

  static TaskStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'todo':
        return TaskStatus.todo;
      case 'in_progress':
      case 'inprogress':
        return TaskStatus.inProgress;
      case 'review':
        return TaskStatus.review;
      case 'done':
        return TaskStatus.done;
      default:
        return TaskStatus.todo;
    }
  }
}

enum TaskPriority { low, medium, high, urgent }

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  static TaskPriority fromString(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      case 'urgent':
        return TaskPriority.urgent;
      default:
        return TaskPriority.medium;
    }
  }
}

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final String projectId;
  final String assignedTo;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final int estimatedHours;
  final List<String> labels;
  final List<TaskChecklistItem> checklist;
  final List<TaskComment> comments;
  final List<String> attachments;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.projectId,
    required this.assignedTo,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.estimatedHours = 0,
    this.labels = const [],
    this.checklist = const [],
    this.comments = const [],
    this.attachments = const [],
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: TaskStatusExtension.fromString(data['status'] ?? 'todo'),
      priority: TaskPriorityExtension.fromString(data['priority'] ?? 'medium'),
      projectId: data['projectId'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      estimatedHours: data['estimatedHours'] ?? 0,
      labels: List<String>.from(data['labels'] ?? []),
      checklist:
          (data['checklist'] as List<dynamic>?)
              ?.map((item) => TaskChecklistItem.fromMap(item))
              .toList() ??
          [],
      comments:
          (data['comments'] as List<dynamic>?)
              ?.map((comment) => TaskComment.fromMap(comment))
              .toList() ??
          [],
      attachments: List<String>.from(data['attachments'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'projectId': projectId,
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'estimatedHours': estimatedHours,
      'labels': labels,
      'checklist': checklist.map((item) => item.toMap()).toList(),
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'attachments': attachments,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    String? projectId,
    String? assignedTo,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    int? estimatedHours,
    List<String>? labels,
    List<TaskChecklistItem>? checklist,
    List<TaskComment>? comments,
    List<String>? attachments,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      assignedTo: assignedTo ?? this.assignedTo,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      labels: labels ?? this.labels,
      checklist: checklist ?? this.checklist,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class TaskChecklistItem {
  final String id;
  final String text;
  final bool isCompleted;

  TaskChecklistItem({required this.id, required this.text, this.isCompleted = false});

  factory TaskChecklistItem.fromMap(Map<String, dynamic> map) {
    return TaskChecklistItem(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'text': text, 'isCompleted': isCompleted};
  }
}

class TaskComment {
  final String id;
  final String text;
  final String userId;
  final String userName;
  final DateTime createdAt;
  final List<String> attachments;

  TaskComment({
    required this.id,
    required this.text,
    required this.userId,
    required this.userName,
    required this.createdAt,
    this.attachments = const [],
  });

  factory TaskComment.fromMap(Map<String, dynamic> map) {
    return TaskComment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      attachments: List<String>.from(map['attachments'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'userId': userId,
      'userName': userName,
      'createdAt': Timestamp.fromDate(createdAt),
      'attachments': attachments,
    };
  }
}
