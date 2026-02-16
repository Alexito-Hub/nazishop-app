import 'package:flutter/material.dart';
import 'package:nazi_shop/backend/api_client.dart';
import 'package:nazi_shop/models/category_model.dart';
import 'package:nazi_shop/models/service_model.dart';

class CatalogService {
  /// Fetches the full hierarchical catalog from the backend.
  static Future<List<Category>> getFullCatalog() async {
    try {
      debugPrint('[CatalogService] Fetching catalog from $ApiClient...');
      final response = await ApiClient.get('/api/catalog');
      debugPrint(
          '[CatalogService] Response received: status=${response['status']}');

      if (response['status'] == true && response['data'] != null) {
        final categories = (response['data'] as List).map<Category>((json) {
          return Category.fromJson(json);
        }).toList();
        debugPrint('[CatalogService] ✅ Loaded ${categories.length} categories');
        return categories;
      }
      debugPrint('[CatalogService] ⚠️ No data in response');
      return [];
    } catch (e) {
      debugPrint('[CatalogService] ❌ Error: $e');
      rethrow;
    }
  }

  /// Get simplified list of all services (public)
  static Future<List<Service>> getAllServices(
      {bool isActive = true, int? limit}) async {
    try {
      final response = await ApiClient.get('/api/services', params: {
        'isActive': isActive.toString(),
        if (limit != null) 'limit': limit.toString(),
      });

      if (response['data'] != null) {
        return (response['data'] as List)
            .map((json) => Service.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Get Services Error: $e');
      return [];
    }
  }

  /// Get a single service by ID
  static Future<Service?> getService(String id) async {
    try {
      final response = await ApiClient.get('/api/services/$id');
      return Service.fromJson(response);
    } catch (e) {
      debugPrint('Get Service Error: $e');
      return null;
    }
  }
}
