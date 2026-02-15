import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBp07OQemS-47xiDobw1ChE9_-1Uz14VHE",
            authDomain: "nazishop.firebaseapp.com",
            projectId: "nazishop",
            storageBucket: "nazishop.firebasestorage.app",
            messagingSenderId: "547883132585",
            appId: "1:547883132585:web:ea9366a560e4ffc7d6abb8",
            measurementId: "G-839GB9003W"));
  } else {
    await Firebase.initializeApp();
  }
}
