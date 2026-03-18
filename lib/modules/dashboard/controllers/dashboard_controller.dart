import 'package:get/get.dart';
import 'package:taskflow_pro/data/models/dashboard_stats_model.dart';
import 'package:taskflow_pro/data/repositories/dashboard_repository.dart';
import 'package:taskflow_pro/modules/auth/controllers/auth_controller.dart';

class DashboardController extends GetxController {
  final DashboardRepository _dashboardRepository;
  final AuthController _authController = Get.find<AuthController>();

  DashboardController(this._dashboardRepository);

  // Reactive variables
  final Rx<DashboardStats> _dashboardStats = DashboardStats.empty().obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxList<RecentActivity> _recentActivities = <RecentActivity>[].obs;

  // Getters
  DashboardStats get dashboardStats => _dashboardStats.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  List<RecentActivity> get recentActivities => _recentActivities;

  double get completionRate {
    if (dashboardStats.totalTasks == 0) return 0;
    return dashboardStats.completedTasks / dashboardStats.totalTasks;
  }

  bool get hasData {
    return dashboardStats.totalProjects > 0 ||
        dashboardStats.totalTasks > 0 ||
        recentActivities.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final userId = _authController.currentUser?.id;
      if (userId == null || userId.isEmpty) {
        _errorMessage.value = 'Unable to determine current user.';
        return;
      }

      final stats = await _dashboardRepository.getDashboardStats(userId);
      _dashboardStats.value = stats;

      // Listen to recent activities
      _dashboardRepository.getRecentActivities(userId).listen((activities) {
        _recentActivities.value = activities;
      });
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }
}
