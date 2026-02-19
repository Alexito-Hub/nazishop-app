import 'package:nazi_shop/backend/api_client.dart';
import 'package:nazi_shop/models/category_model.dart';
import 'package:nazi_shop/models/service_model.dart';
import 'package:nazi_shop/models/offer_model.dart';
import 'package:nazi_shop/models/user_model.dart';
import 'package:nazi_shop/models/admin_models.dart';
import 'package:nazi_shop/models/coupon_model.dart';
import 'package:nazi_shop/models/order.dart';
import 'package:nazi_shop/models/notification_model.dart';
import 'package:nazi_shop/models/domain.dart';

class AdminService {
  // --- DASHBOARD ---
  static Future<DashboardStats> getDashboardStats() async {
    final res = await ApiClient.get('/api/admin/dashboard/stats');
    return DashboardStats.fromJson(res);
  }

  static Future<Map<String, dynamic>> getServerStats() async {
    try {
      return await ApiClient.get('/api/admin/server-status');
    } catch (e) {
      return {};
    }
  }

  // --- CATEGORIES ---

  static Future<Map<String, dynamic>> createCategory(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/category', 'create', data);
  }

  static Future<List<Category>> getCategories() async {
    final res = await ApiClient.adminAction('/api/admin/category', 'list', {});
    return (res['data'] as List?)?.map((e) => Category.fromJson(e)).toList() ??
        [];
  }

  static Future<Map<String, dynamic>> updateCategory(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/category', 'update', data);
  }

  static Future<Map<String, dynamic>> deleteCategory(String id) async {
    return await ApiClient.adminAction(
        '/api/admin/category', 'delete', {'_id': id});
  }

  // --- SERVICES ---

  static Future<Map<String, dynamic>> createService(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/service', 'create', data);
  }

  static Future<List<Service>> getServices({String? categoryId}) async {
    final res = await ApiClient.adminAction('/api/admin/service', 'list',
        {if (categoryId != null) 'categoryId': categoryId});
    return (res['data'] as List?)?.map((e) => Service.fromJson(e)).toList() ??
        [];
  }

  static Future<Map<String, dynamic>> updateService(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/service', 'update', data);
  }

  static Future<Map<String, dynamic>> deleteService(String id) async {
    return await ApiClient.adminAction(
        '/api/admin/service', 'delete', {'_id': id});
  }

  // --- LISTINGS (Ex-Offers) ---

  static Future<Map<String, dynamic>> createListing(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/listing', 'create', data);
  }

  static Future<List<Offer>> getListings(
      {String? serviceId, String? categoryId}) async {
    final res = await ApiClient.adminAction('/api/admin/listing', 'list', {
      if (serviceId != null) 'serviceId': serviceId,
      if (categoryId != null) 'categoryId': categoryId
    });
    return (res['data'] as List?)?.map((e) => Offer.fromJson(e)).toList() ?? [];
  }

  static Future<Map<String, dynamic>> updateListing(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/listing', 'update', data);
  }

  static Future<Map<String, dynamic>> deleteListing(String id) async {
    return await ApiClient.adminAction(
        '/api/admin/listing', 'delete', {'_id': id});
  }

  // --- PROMOTIONS (New Offers) ---

  static Future<Map<String, dynamic>> createPromotion(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/offer', 'create', data);
  }

  static Future<List<Offer>> getPromotions() async {
    final res = await ApiClient.adminAction('/api/admin/offer', 'list', {});
    return (res['data'] as List?)?.map((e) => Offer.fromJson(e)).toList() ?? [];
  }

  static Future<Map<String, dynamic>> updatePromotion(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/offer', 'update', data);
  }

  static Future<Map<String, dynamic>> deletePromotion(String id) async {
    return await ApiClient.adminAction(
        '/api/admin/offer', 'delete', {'_id': id});
  }

  // --- INVENTORY ---

  static Future<int> addInventory(
      {required String listingId, // Renamed param for clarity
      required List<Map<String, dynamic>> items}) async {
    // Backend still expects 'offerId' for now due to DB Schema
    final res = await ApiClient.adminAction('/api/admin/inventory', 'add_bulk',
        {'offerId': listingId, 'items': items});
    return res['count'] ?? 0;
  }

  static Future<List<dynamic>> getInventory({String? listingId}) async {
    final res = await ApiClient.adminAction('/api/admin/inventory', 'list',
        {if (listingId != null) 'offerId': listingId});
    return res['data'] ?? [];
  }

  // --- ORDERS ---

  static Future<Map<String, dynamic>> getAllOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (status != null) params['status'] = status;

    return await ApiClient.get('/api/admin/orders', params: params);
  }

  static Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await ApiClient.patch('/api/admin/orders/$orderId/status',
        body: {'status': status});
  }

  // --- COUPONS ---

  static Future<List<Coupon>> getCoupons() async {
    final res = await ApiClient.adminAction('/api/admin/coupon', 'list', {});
    return (res['data'] as List?)?.map((e) => Coupon.fromJson(e)).toList() ??
        [];
  }

  static Future<Map<String, dynamic>> createCoupon(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/coupon', 'create', data);
  }

  static Future<Map<String, dynamic>> updateCoupon(
      Map<String, dynamic> data) async {
    return await ApiClient.adminAction('/api/admin/coupon', 'update', data);
  }

  static Future<Map<String, dynamic>> deleteCoupon(String id) async {
    return await ApiClient.adminAction(
        '/api/admin/coupon', 'delete', {'_id': id});
  }

  // --- NOTIFICATIONS ---

  static Future<List<NotificationModel>> getNotifications() async {
    try {
      final res =
          await ApiClient.adminAction('/api/admin/notification', 'list', {});
      return (res['data'] as List?)
              ?.map((e) => NotificationModel.fromJson(e))
              .toList() ??
          [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> sendNotification(Map<String, dynamic> data) async {
    try {
      await ApiClient.adminAction('/api/admin/notification', 'create', data);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // --- ORDERS LIST ---

  static Future<List<Order>> getOrders() async {
    try {
      final res = await getAllOrders(limit: 100);
      // The backend returns { status: true, data: { orders: [...], pagination: {...} } }
      // So valid path is res['data']['orders']
      if (res['data'] is Map && res['data'].containsKey('orders')) {
        return (res['data']['orders'] as List?)
                ?.map((e) => Order.fromJson(e))
                .toList() ??
            [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // --- CONFIG ---

  static Future<Map<String, dynamic>> getGlobalConfig() async {
    try {
      final res = await ApiClient.adminAction('/api/admin/config', 'get', {});
      return res['data'] ?? {};
    } catch (e) {
      return {};
    }
  }

  static Future<void> updateConfig(Map<String, dynamic> data) async {
    await ApiClient.adminAction('/api/admin/config', 'update', data);
  }

  // --- USERS ---

  static Future<List<User>> getUsers({String? role}) async {
    try {
      final res = await ApiClient.adminAction('/api/admin/users', 'list', {
        'limit': 100,
        if (role != null) 'role': role,
      });
      return (res['data'] as List?)?.map((e) => User.fromJson(e)).toList() ??
          [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await ApiClient.adminAction('/api/admin/users', 'update', {
        'userId': uid,
        ...data,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addUserBalance(
      String uid, double amount, String? note) async {
    try {
      await ApiClient.adminAction('/api/admin/users', 'add_balance', {
        'userId': uid,
        'amount': amount,
        'description': note ?? 'Carga manual admin',
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> updateUserStatus(String uid, bool isBlocked) async {
    // await ApiClient.adminAction('/api/admin/users', 'update_status', {'uid': uid, 'isBlocked': isBlocked});
    // This is now handled via updateUser with is_active
    await updateUser(uid, {'is_active': !isBlocked});
  }

  // --- SECURITY OTP ---

  static Future<Map<String, dynamic>> sendSecurityOtp() async {
    return await ApiClient.post('/api/admin/security/otp',
        body: {'action': 'send'});
  }

  static Future<bool> verifySecurityOtp(String code) async {
    try {
      final res = await ApiClient.post('/api/admin/security/otp',
          body: {'action': 'verify', 'code': code});
      return res['status'] == true;
    } catch (e) {
      return false;
    }
  }

  // --- DOMAINS ---

  static Future<List<Domain>> getDomains({String? status}) async {
    try {
      final res = await ApiClient.post('/api/admin/domain', body: {
        'action': 'list',
        if (status != null) 'status': status,
        'limit': 100,
      });

      if (res['data'] is Map && res['data'].containsKey('domains')) {
        return (res['data']['domains'] as List?)
                ?.map((e) => Domain.fromJson(e))
                .toList() ??
            [];
      }
      // Handling consistent response structure
      if (res['data'] is List) {
        return (res['data'] as List).map((e) => Domain.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateDomainStatus({
    required String id,
    required String newStatus,
    String? adminNotes,
  }) async {
    try {
      return await ApiClient.post('/api/admin/domain', body: {
        'action': 'update_status',
        'id': id,
        'newStatus': newStatus,
        if (adminNotes != null) 'adminNotes': adminNotes,
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> completeDomainWithInventory({
    required String id,
    required Map<String, dynamic> inventoryData,
    String? adminNotes,
  }) async {
    try {
      return await ApiClient.post('/api/admin/domain', body: {
        'action': 'complete_with_inventory',
        'id': id,
        'inventoryData': inventoryData,
        if (adminNotes != null) 'adminNotes': adminNotes,
      });
    } catch (e) {
      rethrow;
    }
  }
}
