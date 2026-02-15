import '/flutter_flow/flutter_flow_util.dart';
import '/backend/admin_service.dart';
import 'admin_widget.dart' show AdminWidget;
import 'package:flutter/material.dart';

class AdminModel extends FlutterFlowModel<AdminWidget> {
  Map<String, dynamic>? dashboardStats;
  bool isLoadingStats = false;
  String? errorMessage;
  VoidCallback? onDataChanged;

  Future<void> loadDashboardStats() async {
    isLoadingStats = true;
    errorMessage = null;
    onDataChanged?.call();

    try {
      dashboardStats = await AdminService.getDashboardStats();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Error loading dashboard stats: $e');
    } finally {
      isLoadingStats = false;
      onDataChanged?.call();
    }
  }

  Map<String, dynamic> getStatsMap() {
    if (dashboardStats == null) {
      return _getPlaceholderStats();
    }

    return {
      'totalOrders': dashboardStats!['totalOrders'] ?? 0,
      'pendingOrders': dashboardStats!['pendingOrders'] ?? 0,
      'completedOrders': dashboardStats!['completedOrders'] ?? 0,
      'canceledOrders': dashboardStats!['canceledOrders'] ?? 0,
      'totalRevenue': (dashboardStats!['totalRevenue'] ?? 0.0).toDouble(),
      'totalUsers': dashboardStats!['totalUsers'] ?? 0,
      'activeUsers': dashboardStats!['activeUsers'] ?? 0,
      'activeServices': dashboardStats!['activeServices'] ?? 0,
      'totalServices': dashboardStats!['totalServices'] ?? 0,
      'totalPurchases': dashboardStats!['totalPurchases'] ?? 0,
      'avgPurchasesPerUser':
          (dashboardStats!['avgPurchasesPerUser'] ?? 0.0).toDouble(),
      'avgSpentPerUser': (dashboardStats!['avgSpentPerUser'] ?? 0.0).toDouble(),
      'recentRevenue': dashboardStats!['recentRevenue'] ?? [],
      'topServices': dashboardStats!['topServices'] ?? [],
      'topUsers': dashboardStats!['topUsers'] ?? [],
    };
  }

  Map<String, dynamic> _getPlaceholderStats() {
    return {
      'totalOrders': 0,
      'pendingOrders': 0,
      'completedOrders': 0,
      'canceledOrders': 0,
      'totalRevenue': 0.0,
      'totalUsers': 0,
      'activeUsers': 0,
      'activeServices': 0,
      'totalServices': 0,
      'totalPurchases': 0,
      'avgPurchasesPerUser': 0.0,
      'avgSpentPerUser': 0.0,
      'recentRevenue': [],
      'topServices': [],
      'topUsers': [],
    };
  }

  void refreshStats() {
    dashboardStats = null;
    loadDashboardStats();
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
