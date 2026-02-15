import 'package:nazi_shop/backend/api_client.dart';

class OrderService {
  /// Create a new order (purchase an offer)
  /// El userId se obtiene automáticamente del token de Firebase
  static Future<Map<String, dynamic>> createOrder(
    String offerId, {
    String paymentMethod = 'wallet',
  }) async {
    try {
      print('[OrderService] Creating order for offer: $offerId');
      final response = await ApiClient.post('/api/orders', body: {
        'action': 'create',
        'offerId': offerId,
        'paymentMethod': paymentMethod,
      });
      print('[OrderService] ✅ Order created successfully');
      return response;
    } catch (e) {
      print('[OrderService] ❌ Create order error: $e');
      rethrow;
    }
  }

  /// Get all user orders (del usuario autenticado)
  static Future<List<dynamic>> getMyOrders() async {
    try {
      final response = await ApiClient.post('/api/orders', body: {
        'action': 'list',
      });
      return response['data'] ?? [];
    } catch (e) {
      print('[OrderService] Get orders error: $e');
      return [];
    }
  }

  /// Get single order by ID
  static Future<Map<String, dynamic>?> getOrder(String orderId) async {
    try {
      final response = await ApiClient.post('/api/orders', body: {
        'action': 'get',
        '_id': orderId,
      });
      return response['data'];
    } catch (e) {
      print('[OrderService] Get order error: $e');
      return null;
    }
  }

  /// Submit customer information for domain product
  static Future<Map<String, dynamic>> domainCreate({
    required String orderId,
    required String customerEmail,
    required String customerPassword,
    String? notes,
  }) async {
    try {
      print(
          '[OrderService] Submitting domain customer info for order: $orderId');
      final response = await ApiClient.post('/api/domain', body: {
        'action': 'create',
        'orderId': orderId,
        'customerEmail': customerEmail,
        'customerPassword': customerPassword,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });
      print('[OrderService] ✅ Domain info submitted successfully');
      return response;
    } catch (e) {
      print('[OrderService] ❌ Domain creation error: $e');
      rethrow;
    }
  }

  /// Get user's domain requests
  static Future<List<dynamic>> getMyDomains() async {
    try {
      final response = await ApiClient.post('/api/domain', body: {
        'action': 'list',
      });
      return response['data'] ?? [];
    } catch (e) {
      print('[OrderService] Get domains error: $e');
      return [];
    }
  }
}
