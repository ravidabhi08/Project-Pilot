import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskflow_pro/data/models/team_model.dart';

abstract class TeamDatasource {
  Future<List<TeamModel>> getTeams();
  Future<TeamModel?> getTeam(String teamId);
  Future<String> createTeam(TeamModel team);
  Future<void> updateTeam(String teamId, Map<String, dynamic> updates);
  Future<void> deleteTeam(String teamId);
  Future<void> addMember(String teamId, String userId);
  Future<void> removeMember(String teamId, String userId);
}

class TeamDatasourceImpl implements TeamDatasource {
  final FirebaseFirestore _firestore;

  TeamDatasourceImpl(this._firestore);

  @override
  Future<List<TeamModel>> getTeams() async {
    try {
      final querySnapshot = await _firestore.collection('teams').get();
      return querySnapshot.docs.map((doc) => TeamModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get teams: $e');
    }
  }

  @override
  Future<TeamModel?> getTeam(String teamId) async {
    try {
      final docSnapshot = await _firestore.collection('teams').doc(teamId).get();
      if (docSnapshot.exists) {
        return TeamModel.fromFirestore(docSnapshot);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get team: $e');
    }
  }

  @override
  Future<String> createTeam(TeamModel team) async {
    try {
      final docRef = await _firestore.collection('teams').add(team.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create team: $e');
    }
  }

  @override
  Future<void> updateTeam(String teamId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('teams').doc(teamId).update(updates);
    } catch (e) {
      throw Exception('Failed to update team: $e');
    }
  }

  @override
  Future<void> deleteTeam(String teamId) async {
    try {
      await _firestore.collection('teams').doc(teamId).delete();
    } catch (e) {
      throw Exception('Failed to delete team: $e');
    }
  }

  @override
  Future<void> addMember(String teamId, String userId) async {
    try {
      final teamDoc = await _firestore.collection('teams').doc(teamId).get();
      if (teamDoc.exists) {
        final team = TeamModel.fromFirestore(teamDoc);
        final updatedMemberIds = [...team.memberIds, userId];
        await updateTeam(teamId, {'memberIds': updatedMemberIds, 'updatedAt': DateTime.now()});
      }
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }

  @override
  Future<void> removeMember(String teamId, String userId) async {
    try {
      final teamDoc = await _firestore.collection('teams').doc(teamId).get();
      if (teamDoc.exists) {
        final team = TeamModel.fromFirestore(teamDoc);
        final updatedMemberIds = team.memberIds.where((id) => id != userId).toList();
        await updateTeam(teamId, {'memberIds': updatedMemberIds, 'updatedAt': DateTime.now()});
      }
    } catch (e) {
      throw Exception('Failed to remove member: $e');
    }
  }
}
