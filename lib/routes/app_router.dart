import 'package:go_router/go_router.dart';
import 'package:taskflow_pro/modules/auth/screens/forgot_password_screen.dart';
import 'package:taskflow_pro/modules/auth/screens/login_screen.dart';
import 'package:taskflow_pro/modules/auth/screens/onboarding_screen.dart';
import 'package:taskflow_pro/modules/auth/screens/register_screen.dart';
import 'package:taskflow_pro/modules/auth/screens/splash_screen.dart';
import 'package:taskflow_pro/modules/dashboard/screens/dashboard_screen.dart';
import 'package:taskflow_pro/modules/notifications/screens/notifications_screen.dart';
import 'package:taskflow_pro/modules/profile/screens/profile_screen.dart';
import 'package:taskflow_pro/modules/projects/screens/project_list_screen.dart';
import 'package:taskflow_pro/modules/settings/screens/settings_screen.dart';
import 'package:taskflow_pro/modules/tasks/screens/task_list_screen.dart';
import 'package:taskflow_pro/modules/team/screens/team_members_screen.dart';

// Define route names as constants
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String projectList = '/projects';
  static const String taskList = '/tasks';
  static const String teamMembers = '/team';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
    GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
    GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(path: AppRoutes.dashboard, builder: (context, state) => const DashboardScreen()),
    GoRoute(path: AppRoutes.projectList, builder: (context, state) => const ProjectListScreen()),
    GoRoute(path: AppRoutes.taskList, builder: (context, state) => const TaskListScreen()),
    GoRoute(path: AppRoutes.teamMembers, builder: (context, state) => const TeamMembersScreen()),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
    GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
  ],
);
