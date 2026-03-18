import 'package:get/get.dart';
import 'package:taskflow_pro/data/models/task_model.dart';
import 'package:taskflow_pro/data/repositories/task_repository.dart';

class TaskController extends GetxController {
  final TaskRepository _taskRepository;

  TaskController(this._taskRepository);

  // Reactive variables
  final RxList<TaskModel> _tasks = <TaskModel>[].obs;
  final Rx<TaskModel?> _selectedTask = Rx<TaskModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isCreating = false.obs;
  final RxBool _isUpdating = false.obs;
  final RxBool _isDeleting = false.obs;

  // Getters
  List<TaskModel> get tasks => _tasks;
  TaskModel? get selectedTask => _selectedTask.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isCreating => _isCreating.value;
  bool get isUpdating => _isUpdating.value;
  bool get isDeleting => _isDeleting.value;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks({String? projectId}) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Get current user ID (would come from auth controller)
      final userId = 'current_user_id'; // TODO: Get from auth controller

      final tasks = await _taskRepository.getTasks(userId, projectId: projectId);
      _tasks.value = tasks;

      // Listen to tasks stream
      _taskRepository.getTasksStream(userId, projectId: projectId).listen((tasks) {
        _tasks.value = tasks;
      });
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> createTask({
    required String title,
    required String description,
    required String projectId,
    required String assignedTo,
    required String createdBy,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    int estimatedHours = 0,
    List<String> labels = const [],
  }) async {
    try {
      _isCreating.value = true;
      _errorMessage.value = '';

      final task = TaskModel(
        id: '', // Will be set by Firestore
        title: title,
        description: description,
        status: TaskStatus.todo,
        priority: priority,
        projectId: projectId,
        assignedTo: assignedTo,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dueDate: dueDate,
        estimatedHours: estimatedHours,
        labels: labels,
      );

      final createdTask = await _taskRepository.createTask(task);
      _tasks.add(createdTask);
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isCreating.value = false;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      _isUpdating.value = true;
      _errorMessage.value = '';

      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      final result = await _taskRepository.updateTask(updatedTask);

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = result;
      }

      if (_selectedTask.value?.id == task.id) {
        _selectedTask.value = result;
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isUpdating.value = false;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      _isDeleting.value = true;
      _errorMessage.value = '';

      await _taskRepository.deleteTask(taskId);
      _tasks.removeWhere((t) => t.id == taskId);

      if (_selectedTask.value?.id == taskId) {
        _selectedTask.value = null;
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isDeleting.value = false;
    }
  }

  Future<void> selectTask(String taskId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final task = await _taskRepository.getTask(taskId);
      _selectedTask.value = task;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addComment(String taskId, TaskComment comment) async {
    try {
      await _taskRepository.addComment(taskId, comment);

      // Update local task
      final task = _tasks.firstWhereOrNull((t) => t.id == taskId);
      if (task != null) {
        final updatedComments = [...task.comments, comment];
        final updatedTask = task.copyWith(comments: updatedComments);
        final index = _tasks.indexWhere((t) => t.id == taskId);
        if (index != -1) {
          _tasks[index] = updatedTask;
        }
        if (_selectedTask.value?.id == taskId) {
          _selectedTask.value = updatedTask;
        }
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    }
  }

  Future<void> updateChecklistItem(String taskId, TaskChecklistItem item) async {
    try {
      await _taskRepository.updateChecklistItem(taskId, item);

      // Update local task
      final task = _tasks.firstWhereOrNull((t) => t.id == taskId);
      if (task != null) {
        final updatedChecklist =
            task.checklist.map((checklistItem) {
              if (checklistItem.id == item.id) {
                return item;
              }
              return checklistItem;
            }).toList();
        final updatedTask = task.copyWith(checklist: updatedChecklist);
        final index = _tasks.indexWhere((t) => t.id == taskId);
        if (index != -1) {
          _tasks[index] = updatedTask;
        }
        if (_selectedTask.value?.id == taskId) {
          _selectedTask.value = updatedTask;
        }
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    }
  }

  void clearSelection() {
    _selectedTask.value = null;
  }

  void clearError() {
    _errorMessage.value = '';
  }

  List<TaskModel> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  List<TaskModel> getTasksByProject(String projectId) {
    return _tasks.where((task) => task.projectId == projectId).toList();
  }

  Future<void> refreshTasks({String? projectId}) async {
    await loadTasks(projectId: projectId);
  }
}
