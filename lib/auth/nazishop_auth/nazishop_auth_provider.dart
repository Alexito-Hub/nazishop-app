import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../backend/auth_service.dart';
import '../../backend/user_service.dart';

class NaziShopUser {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final int totalPurchases;
  final double totalSpent;
  final List<String> favoriteServices;
  final double walletBalance;

  final bool emailVerified;

  NaziShopUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.totalPurchases,
    required this.totalSpent,
    required this.favoriteServices,
    this.walletBalance = 0.0,
    this.emailVerified = false,
  });

  factory NaziShopUser.fromMap(Map<String, dynamic> data) {
    return NaziShopUser(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      role: data['role'] ?? 'customer',
      isActive: data['isActive'] ?? true,
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      totalPurchases: data['totalPurchases'] ?? 0,
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      favoriteServices: List<String>.from(data['favoriteServices'] ?? []),
      walletBalance: (data['wallet_balance'] ?? 0.0).toDouble(),
      emailVerified: data['emailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'totalPurchases': totalPurchases,
      'totalSpent': totalSpent,
      'favoriteServices': favoriteServices,
      'wallet_balance': walletBalance,
      'emailVerified': emailVerified,
    };
  }

  // ============================================================================
  // ROLE HIERARCHY GETTERS - Sistema jerárquico de roles
  // ============================================================================

  /// Verifica si el usuario es SUPERADMIN (acceso total)
  bool get isSuperAdmin => role.toLowerCase() == 'superadmin';

  /// Verifica si el usuario es ADMIN o superior (incluye superadmin)
  bool get isAdmin => role.toLowerCase() == 'admin' || isSuperAdmin;

  /// Verifica si el usuario es CUSTOMER (cualquier usuario autenticado)
  bool get isCustomer => isActive;

  /// Helper para verificar nivel de acceso
  /// @param requireSuperAdmin - Si true, requiere rol de superadmin
  /// @return bool - true si el usuario tiene el nivel de acceso requerido
  bool hasAdminAccess({bool requireSuperAdmin = false}) {
    if (requireSuperAdmin) {
      return isSuperAdmin;
    }
    return isAdmin;
  }

  /// Obtiene el nombre del rol en formato legible
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
}

class NaziShopAuthProvider with ChangeNotifier {
  NaziShopUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<User?>? _authStateSubscription;

  NaziShopAuthProvider() {
    _initializeAuthListener();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  NaziShopUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => AuthService.isAuthenticated;

  /// Inicializa el listener de cambios de estado de autenticación
  void _initializeAuthListener() {
    _authStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        // Usuario cerró sesión
        _currentUser = null;
        notifyListeners();
      } else {
        // Usuario inició sesión (o se restauró sesión)
        // Solo recargar si no tenemos el usuario actual o si cambió el UID
        if (_currentUser?.id != firebaseUser.uid) {
          _isLoading = true;
          notifyListeners();

          try {
            await _loadUserFromFirestore(
                firebaseUser.uid, firebaseUser.email ?? '', firebaseUser);
            // Registrar sesión del dispositivo de forma asíncrona
            UserService.registerCurrentSession();
          } catch (e) {
            _errorMessage = e.toString();
          } finally {
            _isLoading = false;
            notifyListeners();
          }
        }
      }
    });
  }

  /// Helper para cargar usuario desde Firestore
  Future<void> _loadUserFromFirestore(
      String uid, String email, User? firebaseUser) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final firebaseEmailVerified = firebaseUser?.emailVerified ?? false;

      if (userDoc.exists) {
        final data = userDoc.data()!;
        _currentUser = NaziShopUser(
          id: uid,
          email: data['email'] ?? email,
          displayName: data['displayName'] ?? firebaseUser?.displayName,
          role: data['role'] ?? 'customer',
          isActive: data['isActive'] ?? true,
          createdAt: data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
          totalPurchases: data['totalPurchases'] ?? 0,
          totalSpent: (data['totalSpent'] ?? 0).toDouble(),
          favoriteServices: List<String>.from(data['favoriteServices'] ?? []),
          phoneNumber: data['phoneNumber'],
          photoUrl: data['photoURL'],
          walletBalance: (data['wallet_balance'] ?? 0.0).toDouble(),
          emailVerified: firebaseEmailVerified,
        );
      } else {
        // Fallback if no doc
        _currentUser = NaziShopUser(
          id: uid,
          email: email,
          displayName: firebaseUser?.displayName,
          role: 'customer',
          isActive: true,
          createdAt: DateTime.now(),
          totalPurchases: 0,
          totalSpent: 0,
          favoriteServices: [],
          phoneNumber: firebaseUser?.phoneNumber,
          walletBalance: 0.0,
          emailVerified: firebaseEmailVerified,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await AuthService.login(
        email: email,
        password: password,
      );

      if (result['success'] == true && result['user'] != null) {
        final User firebaseUser = result['user']!;
        final uid = firebaseUser.uid;

        // Fetch user data from Firestore
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

          final firebaseEmailVerified = firebaseUser.emailVerified;

          if (userDoc.exists) {
            final data = userDoc.data()!;
            _currentUser = NaziShopUser(
              id: uid,
              email: data['email'] ?? email,
              displayName: data['displayName'] ?? firebaseUser.displayName,
              role: data['role'] ?? 'customer',
              isActive: data['isActive'] ?? true,
              createdAt: data['createdAt'] != null
                  ? (data['createdAt'] as Timestamp).toDate()
                  : DateTime.now(),
              totalPurchases: data['totalPurchases'] ?? 0,
              totalSpent: (data['totalSpent'] ?? 0).toDouble(),
              favoriteServices:
                  List<String>.from(data['favoriteServices'] ?? []),
              phoneNumber: data['phoneNumber'],
              photoUrl: data['photoURL'],
              walletBalance: (data['wallet_balance'] ?? 0.0).toDouble(),
              emailVerified: firebaseEmailVerified,
            );
          } else {
            // Firestore document doesn't exist - create default user

            _currentUser = NaziShopUser(
              id: uid,
              email: email,
              displayName: firebaseUser.displayName,
              role: 'customer',
              isActive: true,
              createdAt: DateTime.now(),
              totalPurchases: 0,
              totalSpent: 0,
              favoriteServices: [],
              phoneNumber: firebaseUser.phoneNumber,
              walletBalance: 0.0,
              emailVerified: firebaseEmailVerified,
            );
          }
        } catch (e) {
          // Fallback to basic user
          _currentUser = NaziShopUser(
            id: uid,
            email: email,
            displayName: firebaseUser.displayName,
            role: 'customer',
            isActive: true,
            createdAt: DateTime.now(),
            totalPurchases: 0,
            totalSpent: 0,
            favoriteServices: [],
            phoneNumber: firebaseUser.phoneNumber,
            walletBalance: 0.0,
            emailVerified: firebaseUser.emailVerified,
          );
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(result['message'] ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await AuthService.signInWithGoogle();

      if (result['success'] == true) {
        bool isNewUser = result['isNewUser'] ?? false;
        try {
          final User user = result['user'];
          await _loadUserFromFirestore(user.uid, user.email ?? '', user);
        } catch (e) {
          // Listener should handle it eventually
        }
        _isLoading = false;
        notifyListeners();
        return {'success': true, 'isNewUser': isNewUser};
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return {'success': false, 'message': _errorMessage};
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': _errorMessage};
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    String? description,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await AuthService.register(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
        description: description,
      );

      if (result['success'] == true) {
        // AuthService.register automatically sends email verification now (will implementation in AuthService next)
        _currentUser = NaziShopUser(
          id: result['user']?.uid ?? 'temp_id',
          email: email,
          displayName: displayName,
          role: 'customer',
          isActive: true,
          createdAt: DateTime.now(),
          totalPurchases: 0,
          totalSpent: 0,
          favoriteServices: [],
          phoneNumber: phoneNumber,
          walletBalance: 0.0,
          emailVerified: false,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(result['message'] ?? 'Error al registrar');
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshUser() async {
    await refreshEmailVerified();
  }

  Future<bool> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AuthService.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );

      if (result['success'] == true) {
        // Update local user state
        final updatedFirebaseUser = AuthService.currentUser;
        if (updatedFirebaseUser != null && _currentUser != null) {
          _currentUser = NaziShopUser(
            id: _currentUser!.id,
            email: _currentUser!.email,
            displayName: updatedFirebaseUser.displayName ?? displayName,
            photoUrl: updatedFirebaseUser.photoURL ?? photoUrl,
            phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
            role: _currentUser!.role,
            isActive: _currentUser!.isActive,
            createdAt: _currentUser!.createdAt,
            totalPurchases: _currentUser!.totalPurchases,
            totalSpent: _currentUser!.totalSpent,
            favoriteServices: _currentUser!.favoriteServices,
            walletBalance: _currentUser!.walletBalance,
            emailVerified: updatedFirebaseUser.emailVerified,
          );
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = result['message'];
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> restoreSession() async {
    try {
      if (AuthService.isAuthenticated) {
        final user = AuthService.currentUser;
        if (user != null) {
          // Load full user data from Firestore
          try {
            await _loadUserFromFirestore(user.uid, user.email ?? '', user);

            notifyListeners();
            return true;
          } catch (e) {
            // Fallback to basic user info
            _currentUser = NaziShopUser(
              id: user.uid,
              email: user.email ?? '',
              displayName: user.displayName,
              phoneNumber: user.phoneNumber,
              role: 'customer',
              isActive: true,
              createdAt: DateTime.now(),
              totalPurchases: 0,
              totalSpent: 0,
              favoriteServices: [],
              walletBalance: 0.0,
              emailVerified: user.emailVerified,
            );
            notifyListeners();
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // New Auth Methods
  Future<void> sendEmailVerification() async {
    try {
      _isLoading = true;
      notifyListeners();
      await AuthService.sendEmailVerification();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> refreshEmailVerified() async {
    try {
      final isVerified = await AuthService.reloadAndCheckEmailVerified();
      if (_currentUser != null) {
        _currentUser = NaziShopUser(
          id: _currentUser!.id,
          email: _currentUser!.email,
          displayName: _currentUser!.displayName,
          photoUrl: _currentUser!.photoUrl,
          phoneNumber: _currentUser!.phoneNumber,
          role: _currentUser!.role,
          isActive: _currentUser!.isActive,
          createdAt: _currentUser!.createdAt,
          totalPurchases: _currentUser!.totalPurchases,
          totalSpent: _currentUser!.totalSpent,
          favoriteServices: _currentUser!.favoriteServices,
          walletBalance: _currentUser!.walletBalance,
          emailVerified: isVerified,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error refreshing email verification: $e');
    }
  }

  Future<void> setPassword(String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await AuthService.setPassword(password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> verifyPhone(
    String phoneNumber, {
    required Function(String, int?) codeSent,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await AuthService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        // Auto-resolution (Android only usually)
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> confirmPhoneCode(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await AuthService.signInWithPhoneCredential(
          verificationId, smsCode, context);

      // Update local state is handled by auth listener if user changes,
      // but for linking/updates we might need manual refresh
      await refreshUser();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
