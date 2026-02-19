import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  /// Obtiene un ID único para la sesión actual
  static Future<String> getCurrentSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('current_session_id');

    if (sessionId == null) {
      // Generar uno nuevo basado en el tiempo y un random
      final now = DateTime.now().millisecondsSinceEpoch.toString();
      sessionId = sha256
          .convert(utf8.encode(now + (DateTime.now().microsecond.toString())))
          .toString()
          .substring(0, 16);
      await prefs.setString('current_session_id', sessionId);
    }

    return sessionId;
  }

  /// Registra la sesión actual en el backend
  static Future<bool> registerCurrentSession() async {
    try {
      final sessionId = await getCurrentSessionId();
      final deviceInfo = DeviceInfoPlugin();

      String deviceName = 'Unknown';
      String deviceType = 'web';
      String os = 'Unknown';

      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        deviceName = '${webInfo.browserName.name} on ${webInfo.platform}';
        deviceType = 'web';
        os = webInfo.userAgent ?? 'Web';
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceName = '${androidInfo.brand} ${androidInfo.model}';
        deviceType = 'mobile';
        os = 'Android ${androidInfo.version.release}';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
        deviceType = 'mobile';
        os = 'iOS ${iosInfo.systemVersion}';
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        final winInfo = await deviceInfo.windowsInfo;
        deviceName = winInfo.computerName;
        deviceType = 'desktop';
        os = 'Windows';
      }

      final response = await ApiClient.post('/api/user/sessions', body: {
        'action': 'register',
        'sessionId': sessionId,
        'deviceName': deviceName,
        'deviceType': deviceType,
        'os': os,
      });

      return response['status'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Lista todas las sesiones del usuario
  static Future<List<dynamic>> getSessions() async {
    try {
      final response = await ApiClient.post('/api/user/sessions', body: {
        'action': 'list',
      });
      return response['data'] ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Revoca una sesión específica
  static Future<bool> revokeSession(String sessionId) async {
    try {
      final response = await ApiClient.post('/api/user/sessions', body: {
        'action': 'revoke',
        'sessionIdToRevoke': sessionId,
      });
      return response['status'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Revoca todas las sesiones excepto la actual
  static Future<bool> revokeAllOtherSessions() async {
    try {
      final sessionId = await getCurrentSessionId();
      final response = await ApiClient.post('/api/user/sessions', body: {
        'action': 'revoke_all_others',
        'currentSessionId': sessionId,
      });
      return response['status'] == true;
    } catch (e) {
      return false;
    }
  }
}
