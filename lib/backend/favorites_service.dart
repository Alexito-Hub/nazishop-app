import 'package:nazi_shop/backend/api_client.dart';
import 'package:nazi_shop/models/service_model.dart';
// For Service parser

class FavoritesService {
  static Future<List<Service>> getFavorites() async {
    try {
      final response = await ApiClient.get('/api/favorites');
      if (response['status'] == true && response['data'] != null) {
        return (response['data'] as List)
            .map((e) => Service.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> toggleFavorite(String serviceId) async {
    try {
      final response = await ApiClient.post('/api/favorites/toggle', body: {
        'serviceId': serviceId,
      });
      return response['status'] == true;
    } catch (e) {
      return false;
    }
  }
}
