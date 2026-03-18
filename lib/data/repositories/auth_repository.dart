import 'package:taskflow_pro/data/datasources/auth_datasource.dart';
import 'package:taskflow_pro/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> signUpWithEmailAndPassword(String email, String password, String displayName);
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
  Future<void> updateUserProfile(UserModel user);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) {
    return _authDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserModel?> signUpWithEmailAndPassword(String email, String password, String displayName) {
    return _authDataSource.signUpWithEmailAndPassword(email, password, displayName);
  }

  @override
  Future<UserModel?> signInWithGoogle() {
    return _authDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return _authDataSource.signOut();
  }

  @override
  Future<void> resetPassword(String email) {
    return _authDataSource.resetPassword(email);
  }

  @override
  Future<UserModel?> getCurrentUser() {
    return _authDataSource.getCurrentUser();
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _authDataSource.authStateChanges;
  }

  @override
  Future<void> updateUserProfile(UserModel user) {
    return _authDataSource.updateUserProfile(user);
  }
}
