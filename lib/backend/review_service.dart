import 'api_client.dart';
import '../models/review_model.dart';

class ReviewService {
  static Future<List<ReviewModel>> getReviews(String serviceId) async {
    try {
      final response = await ApiClient.get('/api/reviews/$serviceId');

      if (response['status'] == true && response['data'] != null) {
        return (response['data'] as List)
            .map((e) => ReviewModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> createReview({
    required String serviceId,
    required String orderId,
    required double rating,
    String comment = '',
  }) async {
    try {
      final response = await ApiClient.post('/api/reviews', body: {
        'serviceId': serviceId,
        'orderId': orderId,
        'rating': rating,
        'comment': comment,
      });

      return response;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
