import 'package:nazi_shop/backend/api_client.dart';

class WalletService {
  /// Get wallet balance
  static Future<Map<String, dynamic>> getBalance(String userId) async {
    try {
      final response = await ApiClient.post('/api/wallet', body: {
        'action': 'balance',
        'userId': userId,
      });
      return response['data'] ?? {'balance': 0.0, 'currency': 'USD'};
    } catch (e) {
      print('[WalletService] Get balance error: $e');
      return {'balance': 0.0, 'currency': 'USD'};
    }
  }

  /// Add funds to wallet
  static Future<Map<String, dynamic>> deposit(
    String userId,
    double amount, {
    String currency = 'USD',
  }) async {
    try {
      final response = await ApiClient.post('/api/wallet', body: {
        'action': 'deposit',
        'userId': userId,
        'amount': amount,
        'currency': currency,
      });
      return response;
    } catch (e) {
      print('[WalletService] Deposit error: $e');
      rethrow;
    }
  }

  /// Get transaction history
  static Future<List<dynamic>> getTransactions(
    String userId, {
    int limit = 50,
  }) async {
    try {
      final response = await ApiClient.post('/api/wallet', body: {
        'action': 'transactions',
        'userId': userId,
        'limit': limit,
      });
      return response['data'] ?? [];
    } catch (e) {
      print('[WalletService] Get transactions error: $e');
      return [];
    }
  }
}
