import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskflow_pro/data/models/user_model.dart';
import 'package:taskflow_pro/data/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository;

  ProfileController(this._authRepository);

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isUpdating = false.obs;

  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isUpdating => _isUpdating.value;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      // TODO: Get current user from auth controller
      // For now, create a mock user
      _currentUser.value = UserModel(
        id: 'current_user_id',
        email: 'user@example.com',
        displayName: 'John Doe',
        photoUrl: null,
        role: UserRole.employee,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    if (_currentUser.value == null) return;

    try {
      _isUpdating.value = true;
      _errorMessage.value = '';

      final updatedUser = _currentUser.value!.copyWith(
        displayName: displayName ?? _currentUser.value!.displayName,
        photoUrl: photoUrl ?? _currentUser.value!.photoUrl,
        updatedAt: DateTime.now(),
      );

      // TODO: Update user in repository
      // await _authRepository.updateUser(updatedUser);

      _currentUser.value = updatedUser;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isUpdating.value = false;
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      _isUpdating.value = true;
      _errorMessage.value = '';
      // TODO: Implement password change
      // await _authRepository.changePassword(currentPassword, newPassword);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isUpdating.value = false;
    }
  }

  Future<void> pickAndUploadAvatar() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // TODO: Upload image to Firebase Storage and get URL
        // final avatarUrl = await uploadImage(pickedFile.path);
        // await updateProfile(avatarUrl: avatarUrl);
      }
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  Future<void> deleteAccount() async {
    try {
      _isUpdating.value = true;
      _errorMessage.value = '';
      // TODO: Implement account deletion
      // await _authRepository.deleteAccount();
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isUpdating.value = false;
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
