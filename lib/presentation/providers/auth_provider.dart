import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  UserModel? get user => _currentUser;

  String get username => _currentUser?.username ?? "";

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authRepository.login(email, password);
      _isAuthenticated = true;
      return true;
    } catch (e) {
      print("Login error: $e");
      _isAuthenticated = false;
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authRepository.register(name, email, password);
      _isAuthenticated = true;
      return true;
    } catch (e) {
      print("Register error: $e");
      _isAuthenticated = false;
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> updateProfile(String name, String email, String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulasi update profile - ganti dengan API call yang sebenarnya
      await Future.delayed(const Duration(seconds: 2));

      // Update user data
      _currentUser = UserModel(
        name: name,
        email: email,
        username: username,
        id: _currentUser?.id ?? 0,
        password: _currentUser?.password ?? '',
        // tambahkan field lainnya sesuai kebutuhan
      );

      return true;
    } catch (e) {
      print("Update profile error: $e");
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
