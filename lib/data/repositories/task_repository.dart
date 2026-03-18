import 'package:taskflow_pro/data/datasources/task_datasource.dart';
import 'package:taskflow_pro/data/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks(String userId, {String? projectId});
  Future<TaskModel?> getTask(String taskId);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Stream<List<TaskModel>> getTasksStream(String userId, {String? projectId});
  Future<void> addComment(String taskId, TaskComment comment);
  Future<void> updateChecklistItem(String taskId, TaskChecklistItem item);
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource _taskDataSource;

  TaskRepositoryImpl(this._taskDataSource);

  @override
  Future<List<TaskModel>> getTasks(String userId, {String? projectId}) {
    return _taskDataSource.getTasks(userId, projectId: projectId);
  }

  @override
  Future<TaskModel?> getTask(String taskId) {
    return _taskDataSource.getTask(taskId);
  }

  @override
  Future<TaskModel> createTask(TaskModel task) {
    return _taskDataSource.createTask(task);
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) {
    return _taskDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) {
    return _taskDataSource.deleteTask(taskId);
  }

  @override
  Stream<List<TaskModel>> getTasksStream(String userId, {String? projectId}) {
    return _taskDataSource.getTasksStream(userId, projectId: projectId);
  }

  @override
  Future<void> addComment(String taskId, TaskComment comment) {
    return _taskDataSource.addComment(taskId, comment);
  }

  @override
  Future<void> updateChecklistItem(String taskId, TaskChecklistItem item) {
    return _taskDataSource.updateChecklistItem(taskId, item);
  }
}
