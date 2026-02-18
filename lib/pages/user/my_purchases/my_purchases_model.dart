import '/flutter_flow/flutter_flow_util.dart';
import '/backend/order_service.dart';
import 'my_purchases_widget.dart' show MyPurchasesWidget;
import 'package:flutter/material.dart';

class MyPurchasesModel extends FlutterFlowModel<MyPurchasesWidget> {
  String selectedCategory = 'Todos'; // Filtro de categorías

  // Estadísticas
  Map<String, int> stats = {
    'total': 0,
    'active': 0,
    'expired': 0,
  };

  bool isLoadingStats = false;

  Future<void> _loadStats() async {
    isLoadingStats = true;
    try {
      final orders = await OrderService.getMyOrders();

      int total = orders.length;
      int active = 0;
      int expired = 0;

      for (final order in orders) {
        final status = order['status'];

        // Simple logic: paid/delivered = active
        if (status == 'paid' || status == 'delivered') {
          active++;
        } else if (status == 'cancelled' || status == 'expired') {
          expired++;
        }
      }

      stats = {
        'total': total,
        'active': active,
        'expired': expired,
      };
    } catch (e) {
      stats = {
        'total': 0,
        'active': 0,
        'expired': 0,
      };
    } finally {
      isLoadingStats = false;
    }
  }

  // Helper wrapper if needed to match widget call
  Future<void> loadPurchaseStats() => _loadStats();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
