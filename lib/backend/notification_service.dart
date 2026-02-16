import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nazi_shop/backend/api_client.dart';
import 'package:nazi_shop/auth/firebase_auth/auth_util.dart'; // Ensure we have access to current user

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Inicializar notificaciones (permisos y listener)
  static Future<void> init() async {
    try {
      // 1. Request Permission
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint(
          '[NotificationService] User granted permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // 2. Get Token
        String? token = await _fcm.getToken();
        if (token != null) {
          await registerToken(token);
        }

        // 3. Listener (Foreground)
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint(
              '[NotificationService] Foreground Message: ${message.notification?.title}');
          // Optional: Show local notification or update provider
        });

        // 4. Token Refresh Listener
        _fcm.onTokenRefresh.listen((newToken) {
          registerToken(newToken);
        });
      }
    } catch (e) {
      debugPrint('[NotificationService] Error initializing: $e');
    }
  }

  /// Registrar Token en Backend
  static Future<void> registerToken(String token) async {
    try {
      if (currentUserUid.isEmpty) return; // Only if logged in

      await ApiClient.post('/api/notifications', body: {
        'action': 'registerToken',
        'token': token,
      });
      debugPrint('[NotificationService] Token registered in backend');
    } catch (e) {
      debugPrint('[NotificationService] Error registering token: $e');
    }
  }

  /// Obtener notificaciones del usuario (Real API)
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await ApiClient.post('/api/notifications', body: {
        'action': 'list',
        'limit': '50',
      });

      if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']).map((n) {
          // Ensure color/icon parsing locally if backend sends string
          return {
            ...n,
            'color': _getColorForType(n['type']),
            'icon': n['icon'] ?? 'notifications',
          };
        }).toList();
      }

      return [];
    } catch (e) {
      debugPrint('[NotificationService] Error fetching notifications: $e');
      return [];
    }
  }

  /// Marcar notificación como leída
  static Future<bool> markAsRead(String notificationId) async {
    try {
      await ApiClient.post('/api/notifications',
          body: {'action': 'markRead', 'id': notificationId});
      return true;
    } catch (e) {
      debugPrint('[NotificationService] Error marking as read: $e');
      return false;
    }
  }

  /// Eliminar notificación
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      await ApiClient.post('/api/notifications',
          body: {'action': 'delete', 'id': notificationId});
      return true;
    } catch (e) {
      debugPrint('[NotificationService] Error deleting notification: $e');
      return false;
    }
  }

  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'stars_rounded':
        return Icons.stars_rounded;
      case 'local_offer_rounded':
        return Icons.local_offer_rounded;
      case 'check_circle_rounded':
        return Icons.check_circle_rounded;
      case 'security_rounded':
        return Icons.security_rounded;
      case 'notifications':
        return Icons.notifications;
      case 'warning':
        return Icons.warning_rounded;
      case 'info':
        return Icons.info_rounded;
      default:
        return Icons.notifications;
    }
  }

  static int _getColorForType(String? type) {
    switch (type) {
      case 'welcome':
        return 0xFFE50914; // Red
      case 'offer':
        return 0xFFE50914;
      case 'order':
        return 0xFF4CAF50; // Green
      case 'security':
        return 0xFF2196F3; // Blue
      case 'system':
        return 0xFF9E9E9E; // Grey
      default:
        return 0xFFE50914;
    }
  }
}
