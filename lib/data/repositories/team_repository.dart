import 'package:taskflow_pro/data/datasources/team_datasource.dart';
import 'package:taskflow_pro/data/models/team_model.dart';

abstract class TeamRepository {
  Future<List<TeamModel>> getTeams();
  Future<TeamModel?> getTeam(String teamId);
  Future<String> createTeam(TeamModel team);
  Future<void> updateTeam(String teamId, Map<String, dynamic> updates);
  Future<void> deleteTeam(String teamId);
  Future<void> addMember(String teamId, String userId);
  Future<void> removeMember(String teamId, String userId);
}

class TeamRepositoryImpl implements TeamRepository {
  final TeamDatasource _teamDatasource;

  TeamRepositoryImpl(this._teamDatasource);

  @override
  Future<List<TeamModel>> getTeams() => _teamDatasource.getTeams();

  @override
  Future<TeamModel?> getTeam(String teamId) => _teamDatasource.getTeam(teamId);

  @override
  Future<String> createTeam(TeamModel team) => _teamDatasource.createTeam(team);

  @override
  Future<void> updateTeam(String teamId, Map<String, dynamic> updates) =>
      _teamDatasource.updateTeam(teamId, updates);

  @override
  Future<void> deleteTeam(String teamId) => _teamDatasource.deleteTeam(teamId);

  @override
  Future<void> addMember(String teamId, String userId) => _teamDatasource.addMember(teamId, userId);

  @override
  Future<void> removeMember(String teamId, String userId) =>
      _teamDatasource.removeMember(teamId, userId);
}
