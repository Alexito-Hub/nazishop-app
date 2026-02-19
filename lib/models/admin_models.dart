class DashboardStats {
  final int totalUsers;
  final int totalOrders;
  final double totalRevenue;
  final int activeServices;
  final int pendingOrders;
  final double monthlyRevenue;

  final List<dynamic> recentTransactions;

  DashboardStats({
    required this.totalUsers,
    required this.totalOrders,
    required this.totalRevenue,
    required this.activeServices,
    required this.pendingOrders,
    required this.monthlyRevenue,
    this.recentTransactions = const [],
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    // Helper to safely get nested values
    dynamic getNested(Map data, String path) {
      final keys = path.split('.');
      dynamic current = data;
      for (final key in keys) {
        if (current is Map && current[key] != null) {
          current = current[key];
        } else {
          return null;
        }
      }
      return current;
    }

    // Support both flat and nested structures for flexibility
    return DashboardStats(
      totalUsers: json['totalUsers'] ?? getNested(json, 'users.total') ?? 0,
      totalOrders: json['totalOrders'] ?? getNested(json, 'orders.total') ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ??
          (getNested(json, 'revenue.total') as num?)?.toDouble() ??
          0.0,
      activeServices:
          json['activeServices'] ?? getNested(json, 'inventory.total') ?? 0,
      pendingOrders:
          json['pendingOrders'] ?? getNested(json, 'orders.pending') ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ??
          (getNested(json, 'revenue.monthly') as num?)?.toDouble() ??
          0.0,
      recentTransactions: json['recentTransactions'] as List? ?? [],
    );
  }
}

class ServerStatus {
  final bool isOnline;
  final String version;
  final double uptime;
  final Map<String, dynamic>? memory;

  ServerStatus({
    required this.isOnline,
    required this.version,
    required this.uptime,
    this.memory,
  });

  factory ServerStatus.fromJson(Map<String, dynamic> json) {
    return ServerStatus(
      isOnline: json['status'] == 'ok' || json['online'] == true,
      version: json['version'] ?? 'Unknown',
      uptime: (json['uptime'] as num?)?.toDouble() ?? 0.0,
      memory: json['memory'],
    );
  }
}
