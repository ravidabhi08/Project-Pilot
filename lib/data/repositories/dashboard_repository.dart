import 'package:taskflow_pro/data/datasources/dashboard_datasource.dart';
import 'package:taskflow_pro/data/models/dashboard_stats_model.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getDashboardStats(String userId);
  Stream<List<RecentActivity>> getRecentActivities(String userId);
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource _dashboardDataSource;

  DashboardRepositoryImpl(this._dashboardDataSource);

  @override
  Future<DashboardStats> getDashboardStats(String userId) {
    return _dashboardDataSource.getDashboardStats(userId);
  }

  @override
  Stream<List<RecentActivity>> getRecentActivities(String userId) {
    return _dashboardDataSource.getRecentActivities(userId);
  }
}
