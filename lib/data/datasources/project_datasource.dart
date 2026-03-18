import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskflow_pro/data/models/project_model.dart';

abstract class ProjectDataSource {
  Future<List<ProjectModel>> getProjects(String userId);
  Future<ProjectModel?> getProject(String projectId);
  Future<ProjectModel> createProject(ProjectModel project);
  Future<ProjectModel> updateProject(ProjectModel project);
  Future<void> deleteProject(String projectId);
  Stream<List<ProjectModel>> getProjectsStream(String userId);
}

class ProjectDataSourceImpl implements ProjectDataSource {
  final FirebaseFirestore _firestore;

  ProjectDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ProjectModel>> getProjects(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('projects')
              .where('memberIds', arrayContains: userId)
              .orderBy('updatedAt', descending: true)
              .get();

      return querySnapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get projects: $e');
    }
  }

  @override
  Future<ProjectModel?> getProject(String projectId) async {
    try {
      final doc = await _firestore.collection('projects').doc(projectId).get();
      if (doc.exists) {
        return ProjectModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get project: $e');
    }
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    try {
      final docRef = await _firestore.collection('projects').add(project.toFirestore());
      final newProject = project.copyWith(id: docRef.id);
      return newProject;
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  @override
  Future<ProjectModel> updateProject(ProjectModel project) async {
    try {
      await _firestore.collection('projects').doc(project.id).update(project.toFirestore());
      return project;
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  @override
  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }

  @override
  Stream<List<ProjectModel>> getProjectsStream(String userId) {
    return _firestore
        .collection('projects')
        .where('memberIds', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList());
  }
}
