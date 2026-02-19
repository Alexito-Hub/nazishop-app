class OrderItem {
  final String listingId;
  final String? inventoryId;
  final double price;
  final String currency;
  final double exchangeRate;
  final OrderItemListingSnapshot listingSnapshot;
  final Map<String, dynamic>? offerDetails;

  OrderItem({
    required this.listingId,
    this.inventoryId,
    required this.price,
    required this.currency,
    this.exchangeRate = 1.0,
    required this.listingSnapshot,
    this.offerDetails,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      listingId: json['listingId'] is String
          ? json['listingId']
          : (json['listingId']?['_id'] ??
              json['offerId']?['_id'] ??
              json['offerId'] ??
              ''), // Fallback for old records if any
      inventoryId: json['inventoryId'] is String
          ? json['inventoryId']
          : (json['inventoryId']?['_id'] ?? ''),
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      exchangeRate: (json['exchangeRate'] ?? 1.0).toDouble(),
      listingSnapshot: OrderItemListingSnapshot.fromJson(
          json['listingSnapshot'] ?? json['offerSnapshot'] ?? {}),
      offerDetails: json['offerDetails'],
    );
  }

  Map<String, dynamic> toJson() => {
        'listingId': listingId,
        'inventoryId': inventoryId,
        'price': price,
        'currency': currency,
        'exchangeRate': exchangeRate,
        'listingSnapshot': listingSnapshot.toJson(),
        'offerDetails': offerDetails,
      };
}

class OrderItemListingSnapshot {
  final String title;
  final String? serviceId;
  final String? dataDeliveryType;

  OrderItemListingSnapshot({
    required this.title,
    this.serviceId,
    this.dataDeliveryType,
  });

  factory OrderItemListingSnapshot.fromJson(Map<String, dynamic> json) {
    return OrderItemListingSnapshot(
      title: json['title'] ?? 'Unknown',
      serviceId: json['serviceId']?.toString(),
      dataDeliveryType: json['dataDeliveryType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'serviceId': serviceId,
        'dataDeliveryType': dataDeliveryType,
      };
}

class Order {
  final String id;
  final String userId;
  final String? userName; // Added for Admin/Display
  final String? userEmail; // Added for Admin/Display
  final List<OrderItem> items;
  final double totalAmount;
  final String currency;
  final String status; // pending, paid, delivered, cancelled, refunded
  final String? paymentMethod;
  final String? paymentTransactionId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.userId,
    this.userName,
    this.userEmail,
    required this.items,
    required this.totalAmount,
    this.currency = 'USD',
    required this.status,
    this.paymentMethod,
    this.paymentTransactionId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Parsing User Info if available (populated)
    String? uName;
    String? uEmail;

    if (json['userId'] is Map) {
      final u = json['userId'];
      uName = u['displayName'] ?? u['display_name'];
      uEmail = u['email'];
    } else if (json['userInfo'] is Map) {
      final u = json['userInfo'];
      uName = u['displayName'] ?? u['name'];
      uEmail = u['email'];
    }

    return Order(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] is String
          ? json['userId']
          : (json['userId']?['_id'] ?? ''),
      userName: uName,
      userEmail: uEmail,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'],
      paymentTransactionId: json['paymentTransactionId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount,
        'currency': currency,
        'status': status,
        'paymentMethod': paymentMethod,
        'paymentTransactionId': paymentTransactionId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  // Helper getters
  bool get isPending => status == 'pending';
  bool get isPaid => status == 'paid';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  bool get isRefunded => status == 'refunded';

  // Check if order contains domain products
  bool get hasDomainProducts =>
      items.any((item) => item.listingSnapshot.dataDeliveryType == 'domain');

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'paid':
        return 'Pagado';
      case 'delivered':
        return 'Entregado';
      case 'cancelled':
        return 'Cancelado';
      case 'refunded':
        return 'Reembolsado';
      default:
        return status;
    }
  }

  String get paymentMethodDisplayName {
    switch (paymentMethod) {
      case 'wallet':
        return 'Crédito de cuenta';
      case 'stripe':
        return 'Tarjeta de crédito';
      case 'paypal':
        return 'PayPal';
      default:
        return paymentMethod ?? 'Desconocido';
    }
  }
}
