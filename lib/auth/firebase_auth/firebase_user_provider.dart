import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../base_auth_user_provider.dart';

export '../base_auth_user_provider.dart';

class NaziShopFirebaseUser extends BaseAuthUser {
  NaziShopFirebaseUser(this.user, [this._role, this._isActive]);
  User? user;
  String? _role;
  bool? _isActive;

  @override
  bool get loggedIn => user != null && (_isActive ?? true);

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.uid,
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoURL,
        phoneNumber: user?.phoneNumber,
      );

  @override
  Future? delete() => user?.delete();

  @override
  Future? updateEmail(String email) async {
    await user?.verifyBeforeUpdateEmail(email);
  }

  @override
  Future? updatePassword(String newPassword) async {
    await user?.updatePassword(newPassword);
  }

  @override
  Future? sendEmailVerification() => user?.sendEmailVerification();

  @override
  bool get emailVerified {
    // Reloads the user when checking in order to get the most up to date
    // email verified status.
    if (loggedIn && !user!.emailVerified) {
      refreshUser();
    }
    return user?.emailVerified ?? false;
  }

  @override
  Future refreshUser() async {
    final current = FirebaseAuth.instance.currentUser;
    if (current != null) {
      await current.reload();
      user = FirebaseAuth.instance.currentUser;
      // Refresh role from Firestore
      await _fetchRoleFromFirestore();
    }
  }

  // ============================================================================
  // ROLE MANAGEMENT - Obtener rol desde Firestore
  // ============================================================================

  /// Obtiene el rol del usuario desde Firestore
  Future<void> _fetchRoleFromFirestore() async {
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        _role = data?['role'] as String?;
        _isActive = data?['isActive'] as bool?;
      }
    } catch (e) {
      print('[FIREBASE_USER] Error fetching role from Firestore: $e');
      _role = 'customer'; // Default fallback
      _isActive = true;
    }
  }

  @override
  String get role => _role ?? 'customer';

  @override
  bool get isSuperAdmin => role.toLowerCase() == 'superadmin' && loggedIn;

  @override
  bool get isAdmin =>
      (role.toLowerCase() == 'admin' || isSuperAdmin) && loggedIn;

  @override
  bool get isCustomer => loggedIn;

  @override
  String get roleDisplayName {
    switch (role.toLowerCase()) {
      case 'superadmin':
        return 'Super Administrador';
      case 'admin':
        return 'Administrador';
      case 'customer':
        return 'Cliente';
      default:
        return 'Usuario';
    }
  }

  static BaseAuthUser fromUserCredential(UserCredential userCredential) =>
      fromFirebaseUser(userCredential.user);
  static BaseAuthUser fromFirebaseUser(User? user) =>
      NaziShopFirebaseUser(user);
}

Stream<BaseAuthUser> naziShopFirebaseUserStream() {
  return FirebaseAuth.instance
      .authStateChanges()
      .debounce((user) => user == null && !loggedIn
          ? TimerStream<void>(null, const Duration(seconds: 1))
          : Stream<void>.value(null))
      .asyncMap<BaseAuthUser>(
    (user) async {
      if (user == null) {
        currentUser = NaziShopFirebaseUser(null);
        return currentUser!;
      }

      // Fetch role from Firestore (works on Web)
      String? role;
      bool? isActive;

      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final data = doc.data();
          role = data?['role'] as String?;
          isActive = data?['isActive'] as bool?;
          print('[FIREBASE_USER] ✅ Role loaded: $role (isActive: $isActive)');
        } else {
          print('[FIREBASE_USER] ⚠️ No Firestore document for ${user.uid}');
          role = 'customer';
          isActive = true;
        }
      } catch (e) {
        print('[FIREBASE_USER] ❌ Error loading role: $e');
        role = 'customer';
        isActive = true;
      }

      final firebaseUser = NaziShopFirebaseUser(user, role, isActive);
      currentUser = firebaseUser;

      // Setup periodic refresh for role updates (every 30 seconds for Web compatibility)
      _startRoleRefreshTimer(user.uid);

      return currentUser!;
    },
  );
}

// Timer for periodic role refresh
Timer? _roleRefreshTimer;

void _startRoleRefreshTimer(String uid) {
  _roleRefreshTimer?.cancel();
  _roleRefreshTimer =
      Timer.periodic(const Duration(seconds: 30), (timer) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists && currentUser != null) {
        final data = doc.data();
        final newRole = data?['role'] as String?;
        final newIsActive = data?['isActive'] as bool?;

        if (newRole != (currentUser as NaziShopFirebaseUser)._role ||
            newIsActive != (currentUser as NaziShopFirebaseUser)._isActive) {
          print(
              '[FIREBASE_USER] 🔄 Role refreshed: $newRole (isActive: $newIsActive)');
          (currentUser as NaziShopFirebaseUser)._role = newRole;
          (currentUser as NaziShopFirebaseUser)._isActive = newIsActive;

          // Notify listeners about the change
          currentUser?.refreshUser();
        }
      }
    } catch (e) {
      print('[FIREBASE_USER] ⚠️ Role refresh failed: $e');
    }
  });
}
