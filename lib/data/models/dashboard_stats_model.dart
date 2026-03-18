import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStats {
  final int totalProjects;
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int overdueTasks;
  final int tasksDueToday;
  final List<RecentActivity> recentActivities;

  DashboardStats({
    required this.totalProjects,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.overdueTasks,
    required this.tasksDueToday,
    required this.recentActivities,
  });

  factory DashboardStats.empty() {
    return DashboardStats(
      totalProjects: 0,
      totalTasks: 0,
      completedTasks: 0,
      pendingTasks: 0,
      overdueTasks: 0,
      tasksDueToday: 0,
      recentActivities: [],
    );
  }

  DashboardStats copyWith({
    int? totalProjects,
    int? totalTasks,
    int? completedTasks,
    int? pendingTasks,
    int? overdueTasks,
    int? tasksDueToday,
    List<RecentActivity>? recentActivities,
  }) {
    return DashboardStats(
      totalProjects: totalProjects ?? this.totalProjects,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      overdueTasks: overdueTasks ?? this.overdueTasks,
      tasksDueToday: tasksDueToday ?? this.tasksDueToday,
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }
}

class RecentActivity {
  final String id;
  final String type; // 'task_created', 'task_completed', 'project_created', etc.
  final String title;
  final String description;
  final DateTime timestamp;
  final String? userId;
  final String? userName;
  final String? projectId;
  final String? projectName;
  final String? taskId;
  final String? taskName;

  RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.userId,
    this.userName,
    this.projectId,
    this.projectName,
    this.taskId,
    this.taskName,
  });

  factory RecentActivity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecentActivity(
      id: doc.id,
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data['userId'],
      userName: data['userName'],
      projectId: data['projectId'],
      projectName: data['projectName'],
      taskId: data['taskId'],
      taskName: data['taskName'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
      'userName': userName,
      'projectId': projectId,
      'projectName': projectName,
      'taskId': taskId,
      'taskName': taskName,
    };
  }
}
