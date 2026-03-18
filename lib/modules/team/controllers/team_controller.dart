import 'package:get/get.dart';
import 'package:taskflow_pro/data/models/team_model.dart';
import 'package:taskflow_pro/data/models/user_model.dart';
import 'package:taskflow_pro/data/repositories/team_repository.dart';

class TeamController extends GetxController {
  final TeamRepository _teamRepository;

  TeamController(this._teamRepository);

  final RxList<TeamModel> _teams = <TeamModel>[].obs;
  final RxList<UserModel> _teamMembers = <UserModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<TeamModel> get teams => _teams;
  List<UserModel> get teamMembers => _teamMembers;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    loadTeams();
  }

  Future<void> loadTeams() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final teams = await _teamRepository.getTeams();
      _teams.assignAll(teams);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadTeamMembers(String teamId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final team = await _teamRepository.getTeam(teamId);
      if (team != null) {
        // TODO: Load user details for member IDs
        // This would require a user repository to get user details
        _teamMembers.clear();
      }
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> createTeam(String name, String description) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final team = TeamModel(
        id: '', // Will be set by Firestore
        name: name,
        description: description,
        memberIds: [],
        createdBy: 'current_user_id', // TODO: Get from auth controller
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _teamRepository.createTeam(team);
      await loadTeams(); // Refresh the list
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateTeam(String teamId, String name, String description) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final updates = {'name': name, 'description': description, 'updatedAt': DateTime.now()};
      await _teamRepository.updateTeam(teamId, updates);
      await loadTeams(); // Refresh the list
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _teamRepository.deleteTeam(teamId);
      await loadTeams(); // Refresh the list
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addMember(String teamId, String userId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _teamRepository.addMember(teamId, userId);
      await loadTeamMembers(teamId); // Refresh members
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> removeMember(String teamId, String userId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _teamRepository.removeMember(teamId, userId);
      await loadTeamMembers(teamId); // Refresh members
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
