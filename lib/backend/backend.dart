import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:nazi_shop/backend/api_client.dart';

/// Backend service wrapper for the app
/// Now strictly aligned with new architecture.
class NaziShopBackend {
  // ==================== AUTH METHODS ====================

  /// Get authentication token from current user
  static Future<String?> _getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        return await user.getIdToken();
      } catch (e) {
        debugPrint('Error getting auth token: $e');
      }
    }
    return null;
  }

  // ==================== PAYMENT / ORDER METHODS ====================
  // (To be refactored to use OfferID instead of ProductID)

  static Future<Map<String, dynamic>> createPaymentIntent({
    required String orderId,
  }) async {
    final token = await _getAuthToken();
    return await ApiClient.createPaymentIntent(
      orderId: orderId,
      token: token,
    );
  }
}
