import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:taskflow_pro/core/theme/app_theme.dart';
import 'package:taskflow_pro/data/datasources/auth_datasource.dart';
import 'package:taskflow_pro/data/datasources/dashboard_datasource.dart';
import 'package:taskflow_pro/data/datasources/notification_datasource.dart';
import 'package:taskflow_pro/data/datasources/project_datasource.dart';
import 'package:taskflow_pro/data/datasources/task_datasource.dart';
import 'package:taskflow_pro/data/datasources/team_datasource.dart';
import 'package:taskflow_pro/data/repositories/auth_repository.dart';
import 'package:taskflow_pro/data/repositories/dashboard_repository.dart';
import 'package:taskflow_pro/data/repositories/notification_repository.dart';
import 'package:taskflow_pro/data/repositories/project_repository.dart';
import 'package:taskflow_pro/data/repositories/task_repository.dart';
import 'package:taskflow_pro/data/repositories/team_repository.dart';
import 'package:taskflow_pro/modules/auth/controllers/auth_controller.dart';
import 'package:taskflow_pro/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:taskflow_pro/modules/notifications/controllers/notification_controller.dart';
import 'package:taskflow_pro/modules/profile/controllers/profile_controller.dart';
import 'package:taskflow_pro/modules/projects/controllers/project_controller.dart';
import 'package:taskflow_pro/modules/settings/controllers/settings_controller.dart';
import 'package:taskflow_pro/modules/tasks/controllers/task_controller.dart';
import 'package:taskflow_pro/modules/team/controllers/team_controller.dart';
import 'package:taskflow_pro/routes/app_router.dart';

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'TaskFlow Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      routeInformationProvider: appRouter.routeInformationProvider,
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
    );
  }
}

Future<void> initializeApp() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize GetX dependencies
  Get.put<AuthDataSource>(AuthDataSourceImpl());
  Get.put<AuthRepository>(AuthRepositoryImpl(Get.find<AuthDataSource>()));
  Get.put<AuthController>(AuthController(Get.find<AuthRepository>()));

  Get.put<DashboardDataSource>(DashboardDataSourceImpl());
  Get.put<DashboardRepository>(DashboardRepositoryImpl(Get.find<DashboardDataSource>()));
  Get.put<DashboardController>(DashboardController(Get.find<DashboardRepository>()));

  Get.put<ProjectDataSource>(ProjectDataSourceImpl());
  Get.put<ProjectRepository>(ProjectRepositoryImpl(Get.find<ProjectDataSource>()));
  Get.put<ProjectController>(ProjectController(Get.find<ProjectRepository>()));

  Get.put<TaskDataSource>(TaskDataSourceImpl());
  Get.put<TaskRepository>(TaskRepositoryImpl(Get.find<TaskDataSource>()));
  Get.put<TaskController>(TaskController(Get.find<TaskRepository>()));

  Get.put<TeamDatasource>(TeamDatasourceImpl(FirebaseFirestore.instance));
  Get.put<TeamRepository>(TeamRepositoryImpl(Get.find<TeamDatasource>()));
  Get.put<TeamController>(TeamController(Get.find<TeamRepository>()));

  Get.put<NotificationDatasource>(NotificationDatasourceImpl(FirebaseFirestore.instance));
  Get.put<NotificationRepository>(NotificationRepositoryImpl(Get.find<NotificationDatasource>()));
  Get.put<NotificationController>(NotificationController(Get.find<NotificationRepository>()));

  Get.put<ProfileController>(ProfileController(Get.find<AuthRepository>()));

  Get.put<SettingsController>(SettingsController());
}
