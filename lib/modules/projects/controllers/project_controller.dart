import 'package:get/get.dart';
import 'package:taskflow_pro/data/models/project_model.dart';
import 'package:taskflow_pro/data/repositories/project_repository.dart';

class ProjectController extends GetxController {
  final ProjectRepository _projectRepository;

  ProjectController(this._projectRepository);

  // Reactive variables
  final RxList<ProjectModel> _projects = <ProjectModel>[].obs;
  final Rx<ProjectModel?> _selectedProject = Rx<ProjectModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isCreating = false.obs;
  final RxBool _isUpdating = false.obs;
  final RxBool _isDeleting = false.obs;

  // Getters
  List<ProjectModel> get projects => _projects;
  ProjectModel? get selectedProject => _selectedProject.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isCreating => _isCreating.value;
  bool get isUpdating => _isUpdating.value;
  bool get isDeleting => _isDeleting.value;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Get current user ID (would come from auth controller)
      final userId = 'current_user_id'; // TODO: Get from auth controller

      final projects = await _projectRepository.getProjects(userId);
      _projects.value = projects;

      // Listen to projects stream
      _projectRepository.getProjectsStream(userId).listen((projects) {
        _projects.value = projects;
      });
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> createProject({
    required String name,
    required String description,
    required String ownerId,
    List<String>? memberIds,
    DateTime? startDate,
    DateTime? endDate,
    String? color,
  }) async {
    try {
      _isCreating.value = true;
      _errorMessage.value = '';

      final project = ProjectModel(
        id: '', // Will be set by Firestore
        name: name,
        description: description,
        status: ProjectStatus.active,
        ownerId: ownerId,
        memberIds: memberIds ?? [ownerId],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        startDate: startDate,
        endDate: endDate,
        color: color,
      );

      final createdProject = await _projectRepository.createProject(project);
      _projects.add(createdProject);
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isCreating.value = false;
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    try {
      _isUpdating.value = true;
      _errorMessage.value = '';

      final updatedProject = project.copyWith(updatedAt: DateTime.now());
      final result = await _projectRepository.updateProject(updatedProject);

      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = result;
      }

      if (_selectedProject.value?.id == project.id) {
        _selectedProject.value = result;
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isUpdating.value = false;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      _isDeleting.value = true;
      _errorMessage.value = '';

      await _projectRepository.deleteProject(projectId);
      _projects.removeWhere((p) => p.id == projectId);

      if (_selectedProject.value?.id == projectId) {
        _selectedProject.value = null;
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isDeleting.value = false;
    }
  }

  Future<void> selectProject(String projectId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final project = await _projectRepository.getProject(projectId);
      _selectedProject.value = project;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void clearSelection() {
    _selectedProject.value = null;
  }

  void clearError() {
    _errorMessage.value = '';
  }

  List<ProjectModel> getProjectsByStatus(ProjectStatus status) {
    return _projects.where((project) => project.status == status).toList();
  }

  Future<void> refreshProjects() async {
    await loadProjects();
  }
}
