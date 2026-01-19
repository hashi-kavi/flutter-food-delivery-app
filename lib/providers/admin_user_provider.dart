// lib/providers/admin_user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AdminUserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<AppUser> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppUser> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all users from Firestore
  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot =
          await _firestore.collection('users').orderBy('email').get();

      _users = snapshot.docs.map((doc) => AppUser.fromMap(doc.data())).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch users: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle admin status for a user
  Future<bool> toggleUserAdmin(String userId, bool currentAdminStatus) async {
    try {
      final newAdminStatus = !currentAdminStatus;

      await _firestore.collection('users').doc(userId).update({
        'isAdmin': newAdminStatus,
      });

      // Update local list
      final index = _users.indexWhere((u) => u.uid == userId);
      if (index != -1) {
        _users[index] = _users[index].copyWith(isAdmin: newAdminStatus);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update user: $e';
      notifyListeners();
      return false;
    }
  }

  // Get admin users count
  int get adminCount => _users.where((u) => u.isAdmin).length;

  // Get regular users count
  int get regularUsersCount => _users.where((u) => !u.isAdmin).length;

  // Search users by email
  List<AppUser> searchUsers(String query) {
    if (query.isEmpty) return _users;
    return _users
        .where((u) => u.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
