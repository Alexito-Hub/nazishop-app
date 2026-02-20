import '/backend/admin_service.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'orders_management_widget.dart' show OrdersManagementWidget;
import 'package:flutter/material.dart';
import '/models/order.dart';

class OrdersManagementModel extends FlutterFlowModel<OrdersManagementWidget> {
  Map<String, dynamic>? ordersData;
  List<Order> orders = [];
  bool isLoadingOrders = false;
  String? errorMessage;
  String? selectedStatus;
  int currentPage = 0;
  int pageSize = 20;
  bool hasMore = true;

  VoidCallback? onDataChanged;

  String? get filterStatus => selectedStatus;
  set filterStatus(String? value) {
    selectedStatus = value;
    filterByStatus(value);
  }

  Future<void> loadOrders({bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      orders = [];
      hasMore = true;
    }

    isLoadingOrders = true;
    errorMessage = null;
    onDataChanged?.call();

    try {
      ordersData = await AdminService.getAllOrders(
        status: selectedStatus,
        limit: pageSize,
        page: currentPage + 1,
      );

      if (ordersData != null) {
        final newOrdersRaw = ordersData!['orders'] as List<dynamic>? ?? [];
        final newOrders = newOrdersRaw.map((e) => Order.fromJson(e)).toList();
        final total = ordersData!['total'] as int? ?? 0;

        if (refresh) {
          orders = newOrders;
        } else {
          orders.addAll(newOrders);
        }

        hasMore = orders.length < total;
        errorMessage = null;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingOrders = false;
      onDataChanged?.call();
    }
  }

  Future<void> loadNextPage() async {
    if (!hasMore || isLoadingOrders) return;
    currentPage++;
    await loadOrders();
  }

  void filterByStatus(String? status) {
    selectedStatus = status;
    loadOrders(refresh: true);
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      await AdminService.updateOrderStatus(
        orderId: orderId,
        status: status,
      );
      await loadOrders(refresh: true);
    } catch (e) {
      errorMessage = e.toString();

      onDataChanged?.call();
      rethrow;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
