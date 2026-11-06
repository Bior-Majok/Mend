import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isStaff => _currentUser?.isStaff ?? false;

  AuthProvider() {
    _currentUser = _authService.currentUser;
    _authService.userStream.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signIn(email: email, password: password);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String department = 'Computer Science',
    String campus = 'Kigali, Rwanda',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        department: department,
        campus: campus,
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Quick toggle between student and staff for testing
  void toggleDemoRole() {
    if (_currentUser == null) return;
    if (_currentUser!.isStaff) {
      _currentUser = UserModel(
        uid: 'user_amina_123',
        email: 'amina.hassan@alustudent.com',
        fullName: 'Amina Hassan',
        role: 'student',
        department: 'Computer Science',
        campus: 'Kigali, Rwanda',
      );
    } else {
      _currentUser = UserModel(
        uid: 'user_admin_999',
        email: 'estate.admin@alueducation.com',
        fullName: 'Campus Facilities Lead',
        role: 'staff',
        department: 'Operations & Facilities',
        campus: 'Kigali, Rwanda',
      );
    }
    _authService.switchUserForDemo(_currentUser!);
    notifyListeners();
  }
}
