import '/flutter_flow/flutter_flow_util.dart';
import '/backend/admin_service.dart';
import 'users_management_widget.dart' show UsersManagementWidget;
import 'package:flutter/material.dart';

class UsersManagementModel extends FlutterFlowModel<UsersManagementWidget> {
  List<Map<String, dynamic>> users = [];
  int totalUsers = 0;
  bool isLoading = false;
  String? filterRole;
  bool? filterIsActive;

  Future<void> loadUsers() async {
    // Note: Do not early exit if isLoading is true, as consecutive calls might be valid refreshes
    // Just ensure we track state.
    isLoading = true;

    try {
      // Use the new simplified method that returns List directly
      final usersList = await AdminService.getUsers(
        role: filterRole,
      );

      if (usersList.isNotEmpty) {
        users = List<Map<String, dynamic>>.from(usersList).map((u) {
          return {
            ...u,
            'displayName': u['displayName'] ?? u['display_name'] ?? 'Usuario',
            'email': u['email'] ?? '',
            'photoUrl': u['photoUrl'] ?? u['photoURL'] ?? u['photo_url'],
            'isActive': u['isActive'] ??
                u['is_active'] ??
                true, // Default to true if missing
            'role': u['role'] ?? 'customer',
            'wallet_balance': (u['wallet_balance'] as num?)?.toDouble() ??
                (u['wallet'] is Map
                    ? (u['wallet']['balance'] as num?)?.toDouble()
                    : 0.0),
            'id': u['uid'] ?? u['id'] ?? u['_id'],
          };
        }).toList();
        totalUsers = users.length;
      } else {
        users = [];
        totalUsers = 0;
      }
    } catch (e) {
      users = [];
      totalUsers = 0;
      // Error handling is implicitly managed by empty state in UI
    } finally {
      isLoading = false;
    }
  }

  Future<bool> toggleUserStatus(String userId, bool currentStatus) async {
    try {
      await AdminService.updateUser(
        userId,
        {'isActive': !currentStatus},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeUserRole(String userId, String newRole) async {
    try {
      await AdminService.updateUser(
        userId,
        {'role': newRole},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addBalance(String userId, double amount, String? note) async {
    try {
      await AdminService.addUserBalance(
        userId,
        amount,
        note,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState(BuildContext context) {
    // loadUsers(); // Handled by widget state
  }

  @override
  void dispose() {}
}
