import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Script de depuración para verificar Firestore y Firebase Auth
/// Ejecutar esto después del registro para confirmar dónde están los datos
class FirebaseDebugger {
  /// Mostrar información de configuración de Firebase
  static Future<void> printFirebaseConfig() async {
    debugPrint('═══════════════════════════════════════════');
    debugPrint('🔍 FIREBASE CONFIGURATION DEBUG');
    debugPrint('═══════════════════════════════════════════');

    // Firestore info
    try {
      final firestore = FirebaseFirestore.instance;
      debugPrint('📊 Firestore Instance: ${firestore.app.name}');
      debugPrint(
          '📊 Firestore App Options: ${firestore.app.options.projectId}');
    } catch (e) {
      debugPrint('❌ Error accessing Firestore: $e');
    }

    // Auth info
    try {
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      debugPrint('🔐 Auth Instance: ${auth.app.name}');
      debugPrint('🔐 Current User: ${currentUser?.uid ?? "null"}');
      debugPrint('🔐 Email: ${currentUser?.email ?? "null"}');
    } catch (e) {
      debugPrint('❌ Error accessing Auth: $e');
    }

    debugPrint('═══════════════════════════════════════════');
  }

  /// Listar todos los usuarios en Firestore (debe ser llamado por superadmin)
  static Future<void> listAllUsers() async {
    debugPrint('═══════════════════════════════════════════');
    debugPrint('👥 LISTING ALL USERS IN FIRESTORE');
    debugPrint('═══════════════════════════════════════════');

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      debugPrint('📝 Total users found: ${snapshot.docs.length}');

      for (var doc in snapshot.docs) {
        debugPrint('---');
        debugPrint('User ID: ${doc.id}');
        debugPrint('Data: ${doc.data()}');
      }

      if (snapshot.docs.isEmpty) {
        debugPrint('⚠️ NO USERS FOUND IN FIRESTORE!');
        debugPrint('⚠️ This means users are NOT being saved to Firestore');
      }
    } catch (e) {
      debugPrint('❌ Error listing users: $e');
      debugPrint('💡 Possible reasons:');
      debugPrint('   1. Firestore rules are blocking access');
      debugPrint('   2. Collection "users" does not exist');
      debugPrint('   3. No documents have been created yet');
    }

    debugPrint('═══════════════════════════════════════════');
  }

  /// Verificar si un usuario específico existe en Firestore
  static Future<void> checkUserExists(String uid) async {
    debugPrint('═══════════════════════════════════════════');
    debugPrint('🔍 CHECKING USER IN FIRESTORE');
    debugPrint('═══════════════════════════════════════════');
    debugPrint('User UID: $uid');

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        debugPrint('✅ User EXISTS in Firestore!');
        debugPrint('Data: ${doc.data()}');
      } else {
        debugPrint('❌ User DOES NOT EXIST in Firestore!');
        debugPrint('⚠️ User is authenticated but not in Firestore database');
      }
    } catch (e) {
      debugPrint('❌ Error checking user: $e');
    }

    debugPrint('═══════════════════════════════════════════');
  }

  /// Listar todos los usuarios en Firebase Auth (Authentication)
  static Future<void> listAuthUsers() async {
    debugPrint('═══════════════════════════════════════════');
    debugPrint('🔐 FIREBASE AUTH USERS');
    debugPrint('═══════════════════════════════════════════');

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      debugPrint('Current Auth User:');
      debugPrint('  UID: ${currentUser.uid}');
      debugPrint('  Email: ${currentUser.email}');
      debugPrint('  Display Name: ${currentUser.displayName}');
      debugPrint('  Email Verified: ${currentUser.emailVerified}');
    } else {
      debugPrint('⚠️ No user currently authenticated');
    }

    debugPrint('═══════════════════════════════════════════');
  }

  /// Test completo: ejecuta todos los checks
  static Future<void> runFullDiagnostics() async {
    await printFirebaseConfig();
    await listAuthUsers();
    await listAllUsers();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await checkUserExists(currentUser.uid);
    }
  }
}
