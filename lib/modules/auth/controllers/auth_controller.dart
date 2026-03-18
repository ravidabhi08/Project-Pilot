import 'package:get/get.dart';
import 'package:taskflow_pro/data/models/user_model.dart';
import 'package:taskflow_pro/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  // Reactive variables
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _currentUser.value != null;
  Stream<UserModel?> get authStateChanges => _authRepository.authStateChanges;

  @override
  void onInit() {
    super.onInit();

    _setInitialUser(); // ✅ ADD THIS
    _initializeAuthState();
  }

  void _setInitialUser() async {
    final user = _authRepository.getCurrentUser(); // 👈 you need this
    _currentUser.value = await user;
  }

  void _initializeAuthState() {
    _authRepository.authStateChanges.listen((user) {
      _currentUser.value = user;
      if (user != null) {
        _errorMessage.value = '';
      }
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final user = await _authRepository.signInWithEmailAndPassword(email, password);
      _currentUser.value = user;
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final user = await _authRepository.signUpWithEmailAndPassword(email, password, displayName);
      _currentUser.value = user;
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final user = await _authRepository.signInWithGoogle();
      _currentUser.value = user;
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await _authRepository.signOut();
      _currentUser.value = null;
      _errorMessage.value = '';
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _authRepository.resetPassword(email);
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _authRepository.updateUserProfile(user);
      _currentUser.value = user;
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
