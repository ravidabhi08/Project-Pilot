import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskflow_pro/data/models/dashboard_stats_model.dart';

abstract class DashboardDataSource {
  Future<DashboardStats> getDashboardStats(String userId);
  Stream<List<RecentActivity>> getRecentActivities(String userId);
}

class DashboardDataSourceImpl implements DashboardDataSource {
  final FirebaseFirestore _firestore;

  DashboardDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<DashboardStats> getDashboardStats(String userId) async {
    try {
      // Get projects count
      final projectsQuery =
          await _firestore.collection('projects').where('members', arrayContains: userId).get();

      final totalProjects = projectsQuery.docs.length;

      // Get tasks count
      final tasksQuery =
          await _firestore.collection('tasks').where('assignedTo', isEqualTo: userId).get();

      final totalTasks = tasksQuery.docs.length;
      final completedTasks = tasksQuery.docs.where((doc) => doc.data()['status'] == 'done').length;
      final pendingTasks =
          tasksQuery.docs
              .where(
                (doc) => doc.data()['status'] == 'todo' || doc.data()['status'] == 'in_progress',
              )
              .length;

      // Calculate overdue tasks
      final now = DateTime.now();
      final overdueTasks =
          tasksQuery.docs.where((doc) {
            final dueDate = (doc.data()['dueDate'] as Timestamp?)?.toDate();
            final status = doc.data()['status'];
            return dueDate != null && dueDate.isBefore(now) && status != 'done';
          }).length;

      // Calculate tasks due today
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final tasksDueToday =
          tasksQuery.docs.where((doc) {
            final dueDate = (doc.data()['dueDate'] as Timestamp?)?.toDate();
            final status = doc.data()['status'];
            return dueDate != null &&
                dueDate.isAfter(today) &&
                dueDate.isBefore(tomorrow) &&
                status != 'done';
          }).length;

      // Get recent activities (placeholder - would need activity collection)
      final recentActivities = <RecentActivity>[];

      return DashboardStats(
        totalProjects: totalProjects,
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        pendingTasks: pendingTasks,
        overdueTasks: overdueTasks,
        tasksDueToday: tasksDueToday,
        recentActivities: recentActivities,
      );
    } catch (e) {
      throw Exception('Failed to get dashboard stats: $e');
    }
  }

  @override
  Stream<List<RecentActivity>> getRecentActivities(String userId) {
    // This would stream from an activities collection
    // For now, return empty stream
    return Stream.value([]);
  }
}
