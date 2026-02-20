import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nazishop_auth_provider.dart';
import '../../backend/auth_service.dart';

NaziShopUser? get currentUser => _currentUser;
NaziShopUser? _currentUser;

bool get loggedIn => _currentUser != null;

String get currentUserUid => _currentUser?.id ?? '';
String get currentUserEmail => _currentUser?.email ?? '';
String get currentUserDisplayName => _currentUser?.displayName ?? '';
String get currentUserPhoto => _currentUser?.photoUrl ?? '';
String get currentUserPhoneNumber => _currentUser?.phoneNumber ?? '';

void setCurrentUser(NaziShopUser? user) {
  _currentUser = user;
}

void updateCurrentUser(BuildContext context) {
  final authProvider =
      Provider.of<NaziShopAuthProvider>(context, listen: false);
  _currentUser = authProvider.currentUser;
}

class NaziShopAuthManager {
  BuildContext _context;

  NaziShopAuthManager(BuildContext context) : _context = context;

  void updateContext(BuildContext context) {
    _context = context;
  }

  NaziShopAuthProvider get _provider =>
      Provider.of<NaziShopAuthProvider>(_context, listen: false);

  Future<NaziShopUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password, {
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    String? description,
  }) async {
    await _provider.register(
      email: email,
      password: password,
      displayName: displayName,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl,
      description: description,
    );
    if (_provider.isLoggedIn) {
      setCurrentUser(_provider.currentUser);
      return _provider.currentUser;
    }
    return null;
  }

  Future<NaziShopUser?> signInWithEmail(
      BuildContext context, String email, String password) async {
    await _provider.login(email: email, password: password);
    if (_provider.isLoggedIn) {
      setCurrentUser(_provider.currentUser);
      return _provider.currentUser;
    }
    return null;
  }

  Future signOut() async {
    await _provider.logout();
    setCurrentUser(null);
  }

  Future resetPassword({required String email}) async {
    return AuthService.sendPasswordResetEmail(email);
  }

  Future<Map<String, dynamic>> signInWithGoogle(BuildContext context) async {
    final provider = _provider;
    final result = await provider.loginWithGoogle();
    if (result['success'] == true && provider.isLoggedIn) {
      setCurrentUser(provider.currentUser);
      return {
        'user': provider.currentUser,
        'isNewUser': result['isNewUser'] ?? false,
      };
    }
    return {'user': null, 'isNewUser': false};
  }

  Future<NaziShopUser?> signInWithApple(BuildContext context) async {
    return null;
  }
}

NaziShopAuthManager? _authManagerInstance;

NaziShopAuthManager getAuthManager(BuildContext context) {
  if (_authManagerInstance == null) {
    _authManagerInstance = NaziShopAuthManager(context);
  } else {
    _authManagerInstance!.updateContext(context);
  }
  return _authManagerInstance!;
}

NaziShopAuthManager get authManager {
  if (_authManagerInstance == null) {
    throw Exception(
        'AuthManager not initialized. Call getAuthManager(context) first.');
  }
  return _authManagerInstance!;
}
