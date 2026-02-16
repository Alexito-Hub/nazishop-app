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
  final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email.trim(),
    password: password,
  );

  if (userCredential.user != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'uid': userCredential.user!.uid,
      'email': email.trim(),
      'role': 'customer',
      'displayName': userCredential.user!.displayName ?? email.split('@')[0],
      'photoURL': userCredential.user!.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': true,
    });
  }

  return userCredential;
}
