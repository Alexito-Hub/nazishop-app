import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'config.dart';

/// Modern API Client for CRUD operations with Firebase Auth
/// Replaces deprecated NaziShopHybridService
class ApiClient {
  // Generic Helpers

  /// Obtiene el token de autenticación de Firebase
  static Future<String?> _getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  /// Headers con autenticación
  static Future<Map<String, String>> _getHeaders() async {
    final headers = Map<String, String>.from(BackendConfig.defaultHeaders);

    final token = await _getAuthToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? params}) async {
    final uri = Uri.parse('${BackendConfig.baseUrl}$endpoint')
        .replace(queryParameters: params);
    final headers = await _getHeaders();

    final response = await http.get(uri, headers: headers);

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(String endpoint,
      {required Map<String, dynamic> body}) async {
    final uri = Uri.parse('${BackendConfig.baseUrl}$endpoint');
    final headers = await _getHeaders();

    final response =
        await http.post(uri, headers: headers, body: json.encode(body));

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> patch(String endpoint,
      {required Map<String, dynamic> body}) async {
    final uri = Uri.parse('${BackendConfig.baseUrl}$endpoint');
    final headers = await _getHeaders();
    final response =
        await http.patch(uri, headers: headers, body: json.encode(body));
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final uri = Uri.parse('${BackendConfig.baseUrl}$endpoint');
    final headers = await _getHeaders();
    final response = await http.delete(uri, headers: headers);
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(
            error['msg'] ?? 'Request failed: ${response.statusCode}');
      } catch (_) {
        throw Exception('Request failed: ${response.statusCode}');
      }
    }
  }

  static Future<Map<String, dynamic>> adminAction(
      String endpoint, String action, Map<String, dynamic> data) async {
    return await post(endpoint, body: {'action': action, ...data});
  }

  static Future<Map<String, dynamic>> createPaymentIntent({
    required String orderId,
    String? token,
  }) async {
    final uri = Uri.parse(
        '${BackendConfig.baseUrl}/api/orders/$orderId/payment-intent');
    final headers = {...BackendConfig.defaultHeaders};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.post(uri, headers: headers);
    return _handleResponse(response);
  }
}
