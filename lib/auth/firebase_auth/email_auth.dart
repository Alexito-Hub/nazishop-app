import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  print('═══════════════════════════════════════════════════');
  print('[EMAIL_AUTH] 🔵 STARTING REGISTRATION');
  print('[EMAIL_AUTH] Email: $email');
  print('═══════════════════════════════════════════════════');

  try {
    print('[EMAIL_AUTH] Creating Firebase Auth user...');
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    print('[EMAIL_AUTH] ✅ Firebase Auth user created!');
    print('[EMAIL_AUTH] UID: ${userCredential.user?.uid}');

    if (userCredential.user != null) {
      print('[EMAIL_AUTH] Creating Firestore document...');

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

        print('[EMAIL_AUTH] ✅ Firestore document created');

        // Verify
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (doc.exists) {
          print('[EMAIL_AUTH] ✅✅ VERIFIED: Document exists!');
          print('[EMAIL_AUTH] Data: ${doc.data()}');
        } else {
          print('[EMAIL_AUTH] ❌❌ FAILED: Document NOT saved!');
          print('[EMAIL_AUTH] Firestore rules blocking writes');
        }
      } catch (firestoreError) {
        print('[EMAIL_AUTH] ❌ Firestore error: $firestoreError');
      }
    }

    print('[EMAIL_AUTH] Registration complete!');
    print('═══════════════════════════════════════════════════');
    return userCredential;
  } catch (e) {
    print('[EMAIL_AUTH] ❌❌ ERROR: $e');
    print('═══════════════════════════════════════════════════');
    rethrow;
  }
}
