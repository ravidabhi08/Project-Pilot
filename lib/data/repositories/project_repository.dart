import 'package:taskflow_pro/data/datasources/project_datasource.dart';
import 'package:taskflow_pro/data/models/project_model.dart';

abstract class ProjectRepository {
  Future<List<ProjectModel>> getProjects(String userId);
  Future<ProjectModel?> getProject(String projectId);
  Future<ProjectModel> createProject(ProjectModel project);
  Future<ProjectModel> updateProject(ProjectModel project);
  Future<void> deleteProject(String projectId);
  Stream<List<ProjectModel>> getProjectsStream(String userId);
}

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDataSource _projectDataSource;

  ProjectRepositoryImpl(this._projectDataSource);

  @override
  Future<List<ProjectModel>> getProjects(String userId) {
    return _projectDataSource.getProjects(userId);
  }

  @override
  Future<ProjectModel?> getProject(String projectId) {
    return _projectDataSource.getProject(projectId);
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) {
    return _projectDataSource.createProject(project);
  }

  @override
  Future<ProjectModel> updateProject(ProjectModel project) {
    return _projectDataSource.updateProject(project);
  }

  @override
  Future<void> deleteProject(String projectId) {
    return _projectDataSource.deleteProject(projectId);
  }

  @override
  Stream<List<ProjectModel>> getProjectsStream(String userId) {
    return _projectDataSource.getProjectsStream(userId);
  }
}
