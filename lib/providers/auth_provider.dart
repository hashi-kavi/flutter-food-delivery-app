// lib/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/firebase_auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  AppUser? _user;
  bool _isLoading = true;
  String? _errorMessage;

  AppUser? get currentUser => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      // Listen to auth state changes
      _authService.authStateChanges.listen((firebaseUser) async {
        if (firebaseUser != null) {
          _user = await _authService.getUserData(firebaseUser.uid);
        } else {
          _user = null;
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      print('Firebase error: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Sign in
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.signIn(email: email, password: password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
  }) async {
    if (_user == null) return false;

    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.updateUserProfile(
        userId: _user!.uid,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
      );

      // Refresh user data
      _user = await _authService.getUserData(_user!.uid);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _user = null;
      _setLoading(false);
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
