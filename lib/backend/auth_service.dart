import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// Servicio que maneja la autenticación de Firebase
/// (La sincronización con backend REST se hace automáticamente vía API headers)
class AuthService {
  static bool _initialized = false;

  /// Inicializa el servicio de autenticación
  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
  }

  /// Login con Google
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      } else {
        // Explicitly typed to avoid confusion if any conflict existed
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          return {
            'success': false,
            'message': 'Inicio de sesión con Google cancelado',
          };
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final User? user = userCredential.user;

      if (user != null) {
        // Check if user exists in Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        bool isNewUser = false;
        if (!userDoc.exists) {
          isNewUser = true;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'email': user.email,
            'role': 'customer', // Default role
            'displayName': user.displayName ?? user.email?.split('@')[0],
            'photoURL': user.photoURL,
            'phoneNumber': user.phoneNumber,
            'description': null,
            'createdAt': FieldValue.serverTimestamp(),
            'isActive': true,
            'totalPurchases': 0,
            'totalSpent': 0.0,
            'favoriteServices': [],
            'wallet_balance': 0.0,
          });
        }

        return {
          'success': true,
          'message': 'Google login successful',
          'user': user,
          'isNewUser': isNewUser,
        };
      }

      return {
        'success': true,
        'message': 'Google login successful',
        'user': user,
        'isNewUser': false,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Login con email y password
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'success': true,
        'message': 'Login exitoso',
        'user': userCredential.user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Register con email y password
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
    String? description,
  }) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (displayName != null) {
        await userCredential.user?.updateDisplayName(displayName);
      }

      // Auto-send verification email
      await userCredential.user?.sendEmailVerification();

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'email': email.trim(),
          'role': 'customer', // Default role
          'displayName': displayName ?? email.split('@')[0],
          'photoURL': userCredential.user!.photoURL,
          'phoneNumber': phoneNumber,
          'description': description,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      }

      return {
        'success': true,
        'message': 'Registro exitoso',
        'user': userCredential.user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static bool get isAuthenticated {
    return FirebaseAuth.instance.currentUser != null;
  }

  static User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No hay usuario autenticado'};
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      return {
        'success': true,
        'message': 'Perfil actualizado',
        'user': updatedUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<void> refreshToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.getIdToken(true);
      await user.reload();
    }
  }

  // ============================================================================
  // New Auth Features
  // ============================================================================

  static Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
  }

  static Future<bool> reloadAndCheckEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    }
    return false;
  }

  static Future<void> setPassword(String password) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.providerData.any((p) => p.providerId == 'password')) {
        // User already has a password, just update it
        await user.updatePassword(password);
      } else {
        // User (e.g. Google) doesn't have a password credential -> Link it
        final credential = EmailAuthProvider.credential(
            email: user.email!, password: password);
        await user.linkWithCredential(credential);
      }
    }
  }

  static Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  static Future<UserCredential> signInWithPhoneCredential(
      String verificationId, String smsCode, dynamic context) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Link phone to existing user
      return await user.linkWithCredential(credential);
    }
    // Or sign in (not main use case here but supported)
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
