import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../backend/auth_service.dart';

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
          debugPrint(
              '[AUTH_PROVIDER] 🔄 Auth state changed: User logged in, loading data...');
          _isLoading = true;
          notifyListeners();

          try {
            await _loadUserFromFirestore(
                firebaseUser.uid, firebaseUser.email ?? '', firebaseUser);
          } catch (e) {
            debugPrint(
                '[AUTH_PROVIDER] ❌ Error loading user data on auth change: $e');
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
        );
        debugPrint(
            '[AUTH_PROVIDER] ✅ Session restored for role: ${_currentUser?.role}');
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
        );
      }
    } catch (e) {
      debugPrint('[AUTH_PROVIDER] ❌ Error loading from Firestore: $e');
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
        final uid = result['user']!.uid;

        // Fetch user data from Firestore
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

          if (userDoc.exists) {
            final data = userDoc.data()!;
            _currentUser = NaziShopUser(
              id: uid,
              email: data['email'] ?? email,
              displayName: data['displayName'] ?? result['user']?.displayName,
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
            );
            debugPrint(
                '[AUTH_PROVIDER] ✅ User loaded with role: ${_currentUser?.role}');
          } else {
            // Firestore document doesn't exist - create default user
            debugPrint('[AUTH_PROVIDER] ⚠️ No Firestore doc, using defaults');
            _currentUser = NaziShopUser(
              id: uid,
              email: email,
              displayName: result['user']?.displayName,
              role: 'customer',
              isActive: true,
              createdAt: DateTime.now(),
              totalPurchases: 0,
              totalSpent: 0,
              favoriteServices: [],
              phoneNumber: result['user']?.phoneNumber,
              walletBalance: 0.0,
            );
          }
        } catch (e) {
          debugPrint('[AUTH_PROVIDER] ❌ Error loading Firestore data: $e');
          // Fallback to basic user
          _currentUser = NaziShopUser(
            id: uid,
            email: email,
            displayName: result['user']?.displayName,
            role: 'customer',
            isActive: true,
            createdAt: DateTime.now(),
            totalPurchases: 0,
            totalSpent: 0,
            favoriteServices: [],
            phoneNumber: result['user']?.phoneNumber,
            walletBalance: 0.0,
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

  Future<bool> loginWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await AuthService.signInWithGoogle();

      if (result['success'] == true) {
        try {
          final User user = result['user'];
          // Explicitly load user to ensure state is ready before returning
          await _loadUserFromFirestore(user.uid, user.email ?? '', user);
        } catch (e) {
          debugPrint('[AUTH_PROVIDER] Warning: Could not manual load user: $e');
          // Listener should handle it eventually
        }
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
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
        _currentUser = NaziShopUser(
            id: result['user']?.uid ?? 'temp_id',
            email: email,
            displayName: displayName,
            role: 'USER',
            isActive: true,
            createdAt: DateTime.now(),
            totalPurchases: 0,
            totalSpent: 0,
            favoriteServices: [],
            phoneNumber: phoneNumber,
            walletBalance: 0.0);
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
    // No-op for now
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
            phoneNumber: phoneNumber ??
                _currentUser!
                    .phoneNumber, // Phone update not yet in AuthService
            role: _currentUser!.role,
            isActive: _currentUser!.isActive,
            createdAt: _currentUser!.createdAt,
            totalPurchases: _currentUser!.totalPurchases,
            totalSpent: _currentUser!.totalSpent,
            favoriteServices: _currentUser!.favoriteServices,
            walletBalance: _currentUser!.walletBalance,
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
          debugPrint('[AUTH_PROVIDER] Restoring session for: ${user.email}');

          // Load full user data from Firestore
          try {
            await _loadUserFromFirestore(user.uid, user.email ?? '', user);
            debugPrint('[AUTH_PROVIDER] ✅ Session restored successfully');
            notifyListeners();
            return true;
          } catch (e) {
            debugPrint(
                '[AUTH_PROVIDER] ⚠️ Error loading Firestore, using basic data: $e');
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
            );
            notifyListeners();
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      debugPrint('[AUTH_PROVIDER] ❌ Error restoring session: $e');
      return false;
    }
  }
}
