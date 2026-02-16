import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<UserCredential?> emailSignInFunc(
  String email,
  String password,
) =>
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.trim(), password: password);

Future<UserCredential?> emailCreateAccountFunc(
  String email,
  String password,
) async {
  debugPrint('═══════════════════════════════════════════════════');
  debugPrint('[EMAIL_AUTH] 🔵 STARTING REGISTRATION');
  debugPrint('[EMAIL_AUTH] Email: $email');
  debugPrint('═══════════════════════════════════════════════════');

  try {
    debugPrint('[EMAIL_AUTH] Creating Firebase Auth user...');
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    debugPrint('[EMAIL_AUTH] ✅ Firebase Auth user created!');
    debugPrint('[EMAIL_AUTH] UID: ${userCredential.user?.uid}');

    if (userCredential.user != null) {
      debugPrint('[EMAIL_AUTH] Creating Firestore document...');

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'email': email.trim(),
          'role': 'customer',
          'displayName':
              userCredential.user!.displayName ?? email.split('@')[0],
          'photoURL': userCredential.user!.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });

        debugPrint('[EMAIL_AUTH] ✅ Firestore document created');

        // Verify
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (doc.exists) {
          debugPrint('[EMAIL_AUTH] ✅✅ VERIFIED: Document exists!');
          debugPrint('[EMAIL_AUTH] Data: ${doc.data()}');
        } else {
          debugPrint('[EMAIL_AUTH] ❌❌ FAILED: Document NOT saved!');
          debugPrint('[EMAIL_AUTH] Firestore rules blocking writes');
        }
      } catch (firestoreError) {
        debugPrint('[EMAIL_AUTH] ❌ Firestore error: $firestoreError');
      }
    }

    debugPrint('[EMAIL_AUTH] Registration complete!');
    debugPrint('═══════════════════════════════════════════════════');
    return userCredential;
  } catch (e) {
    debugPrint('[EMAIL_AUTH] ❌❌ ERROR: $e');
    debugPrint('═══════════════════════════════════════════════════');
    rethrow;
  }
}
