import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Servicio para manejar el wallet directamente desde Firestore
class FirestoreWalletService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtener balance del usuario actual desde Firestore
  static Future<Map<String, dynamic>> getBalance() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        return {
          'balance': 0.0,
          'currency': 'USD',
        };
      }

      final data = userDoc.data()!;
      return {
        'balance': (data['wallet_balance'] ?? 0.0).toDouble(),
        'currency': data['wallet_currency'] ?? 'USD',
      };
    } catch (e) {
      debugPrint('❌ Error getting balance from Firestore: $e');
      rethrow;
    }
  }

  /// Escuchar cambios en el balance en tiempo real
  static Stream<Map<String, dynamic>> balanceStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value({'balance': 0.0, 'currency': 'USD'});
    }

    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) {
        return {'balance': 0.0, 'currency': 'USD'};
      }

      final data = doc.data()!;
      return {
        'balance': (data['wallet_balance'] ?? 0.0).toDouble(),
        'currency': data['wallet_currency'] ?? 'USD',
      };
    });
  }

  /// Agregar fondos (solo para testing - en producción debe ser por backend)
  static Future<void> addFunds(double amount) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final userRef = _firestore.collection('users').doc(user.uid);

      await _firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          throw Exception('User document not found');
        }

        final currentBalance =
            (userDoc.data()!['wallet_balance'] ?? 0.0).toDouble();
        final newBalance = currentBalance + amount;

        transaction.update(userRef, {
          'wallet_balance': newBalance,
          'last_active_time': FieldValue.serverTimestamp(),
        });
      });

      debugPrint(
          '✅ Funds added: +\$$amount. Transaction will sync to backend.');
    } catch (e) {
      debugPrint('❌ Error adding funds: $e');
      rethrow;
    }
  }

  /// Obtener historial de transacciones
  static Future<List<Map<String, dynamic>>> getTransactions(
      {int limit = 50}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final snapshot = await _firestore
          .collection('transactions')
          .where('uid', isEqualTo: user.uid)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
          'created_at': (data['created_at'] as Timestamp?)?.toDate(),
        };
      }).toList();
    } catch (e) {
      debugPrint('❌ Error getting transactions: $e');
      return [];
    }
  }

  /// Stream de transacciones en tiempo real
  static Stream<List<Map<String, dynamic>>> transactionsStream(
      {int limit = 50}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('transactions')
        .where('uid', isEqualTo: user.uid)
        .orderBy('created_at', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
          'created_at': (data['created_at'] as Timestamp?)?.toDate(),
        };
      }).toList();
    });
  }
}
