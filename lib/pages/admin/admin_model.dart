import '/flutter_flow/flutter_flow_util.dart';
import '/backend/admin_service.dart';
import 'admin_widget.dart' show AdminWidget;
import 'package:flutter/material.dart';

import '/models/admin_models.dart';

class AdminModel extends FlutterFlowModel<AdminWidget> {
  DashboardStats? dashboardStats;
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
      'totalOrders': dashboardStats!.totalOrders,
      'pendingOrders': dashboardStats!.pendingOrders,
      // 'completedOrders': dashboardStats!.completedOrders, // Not present in model yet
      // 'canceledOrders': dashboardStats!.canceledOrders, // Not present in model yet
      'totalRevenue': dashboardStats!.totalRevenue,
      'totalUsers': dashboardStats!.totalUsers,
      // 'activeUsers': dashboardStats!.activeUsers, // Not present in model yet
      'activeServices': dashboardStats!.activeServices,
      // 'totalServices': dashboardStats!.totalServices, // Not present in model yet
      // 'totalPurchases': dashboardStats!.totalPurchases, // Not present in model yet
      // 'avgPurchasesPerUser': dashboardStats!.avgPurchasesPerUser, // Not present
      // 'avgSpentPerUser': dashboardStats!.avgSpentPerUser, // Not present
      'monthlyRevenue': dashboardStats!.monthlyRevenue,
      // 'recentRevenue': dashboardStats!.recentRevenue, // Not present
      // 'topServices': dashboardStats!.topServices, // Not present
      // 'topUsers': dashboardStats!.topUsers, // Not present
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
