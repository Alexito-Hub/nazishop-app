import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> googleSignInFunc() async {
  try {
    if (kIsWeb) {
      return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    }

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    debugPrint('Google Sign In Error: $e');
    return null;
  }
}

Future<void> signOutWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
}
