import '/backend/api_client.dart';

class OrderService {
  /// Create a new order (purchase a listing)
  /// El userId se obtiene automáticamente del token de Firebase
  static Future<Map<String, dynamic>> createOrder(
    String listingId, {
    String paymentMethod = 'wallet',
  }) async {
    try {
      final response = await ApiClient.post('/api/orders', body: {
        'action': 'create',
        'listingId': listingId,
        'paymentMethod': paymentMethod,
      });

      return response;
    } catch (e) {
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
      final response = await ApiClient.post('/api/domain', body: {
        'action': 'create',
        'orderId': orderId,
        'customerEmail': customerEmail,
        'customerPassword': customerPassword,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });

      return response;
    } catch (e) {
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
      return [];
    }
  }
}
