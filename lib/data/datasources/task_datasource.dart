import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskflow_pro/data/models/task_model.dart';

abstract class TaskDataSource {
  Future<List<TaskModel>> getTasks(String userId, {String? projectId});
  Future<TaskModel?> getTask(String taskId);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Stream<List<TaskModel>> getTasksStream(String userId, {String? projectId});
  Future<void> addComment(String taskId, TaskComment comment);
  Future<void> updateChecklistItem(String taskId, TaskChecklistItem item);
}

class TaskDataSourceImpl implements TaskDataSource {
  final FirebaseFirestore _firestore;

  TaskDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<TaskModel>> getTasks(String userId, {String? projectId}) async {
    try {
      Query query = _firestore.collection('tasks');

      if (projectId != null) {
        query = query.where('projectId', isEqualTo: projectId);
      } else {
        query = query.where('assignedTo', isEqualTo: userId);
      }

      final querySnapshot = await query.orderBy('createdAt', descending: true).get();

      return querySnapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  @override
  Future<TaskModel?> getTask(String taskId) async {
    try {
      final doc = await _firestore.collection('tasks').doc(taskId).get();
      if (doc.exists) {
        return TaskModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final docRef = await _firestore.collection('tasks').add(task.toFirestore());
      final newTask = task.copyWith(id: docRef.id);
      return newTask;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).update(task.toFirestore());
      return task;
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Stream<List<TaskModel>> getTasksStream(String userId, {String? projectId}) {
    Query query = _firestore.collection('tasks');

    if (projectId != null) {
      query = query.where('projectId', isEqualTo: projectId);
    } else {
      query = query.where('assignedTo', isEqualTo: userId);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }

  @override
  Future<void> addComment(String taskId, TaskComment comment) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'comments': FieldValue.arrayUnion([comment.toMap()]),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  @override
  Future<void> updateChecklistItem(String taskId, TaskChecklistItem item) async {
    try {
      final taskDoc = await _firestore.collection('tasks').doc(taskId).get();
      if (!taskDoc.exists) return;

      final task = TaskModel.fromFirestore(taskDoc);
      final updatedChecklist =
          task.checklist.map((checklistItem) {
            if (checklistItem.id == item.id) {
              return item;
            }
            return checklistItem;
          }).toList();

      await _firestore.collection('tasks').doc(taskId).update({
        'checklist': updatedChecklist.map((item) => item.toMap()).toList(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update checklist item: $e');
    }
  }
}
