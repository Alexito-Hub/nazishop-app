class Order {
  final String id;
  final String userId;
  final String? userName; // Added for User Info
  final String? userEmail; // Added for User Info
  final double totalAmount;
  final String currency;
  final String
      status; // 'pending', 'paid', 'delivered', 'cancelled', 'refunded'
  final List<OrderItem> items;
  final DateTime createdAt;
  final String paymentMethod;

  Order({
    required this.id,
    required this.userId,
    this.userName,
    this.userEmail,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.items,
    required this.createdAt,
    required this.paymentMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final userInfo = json['userInfo'];
    return Order(
      id: json['_id'] ?? '',
      userId: json['userId'] is Map
          ? (json['userId']['_id'] ?? '')
          : (json['userId'] ?? 'Unknown'),
      userName: userInfo?['displayName'],
      userEmail: userInfo?['email'],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? 'pending',
      items: (json['items'] as List?)
              ?.map((i) => OrderItem.fromJson(i))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      paymentMethod: json['paymentMethod'] ?? 'N/A',
    );
  }
}

class OrderItem {
  final String? offerId;
  final double price;
  final String title;
  final Map<String, dynamic>? offerSnapshot;
  final Map<String, dynamic>? offerDetails; // Populated Listing data

  OrderItem({
    this.offerId,
    required this.price,
    required this.title,
    this.offerSnapshot,
    this.offerDetails,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final snapshot = json['offerSnapshot'] ?? {};
    final offerData =
        json['offerId'] is Map ? json['offerId'] as Map<String, dynamic> : null;

    return OrderItem(
      offerId:
          json['offerId'] is Map ? json['offerId']['_id'] : json['offerId'],
      price: (json['price'] ?? 0).toDouble(),
      title: snapshot['title'] ?? 'Product',
      offerSnapshot: snapshot,
      offerDetails: offerData,
    );
  }
}
