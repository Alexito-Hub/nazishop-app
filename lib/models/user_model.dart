class User {
  final String id;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final String role; // 'user', 'admin', 'superadmin'
  final double balance;
  final String currency;
  final bool isProvider;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isBlocked;
  final bool isActive;
  final double totalSpent;
  final int totalPurchases;

  User({
    required this.id,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.role,
    required this.balance,
    required this.currency,
    required this.isProvider,
    required this.createdAt,
    this.lastLogin,
    this.isBlocked = false,
    this.isActive = true,
    this.totalSpent = 0.0,
    this.totalPurchases = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle both nested wallet object and flat Firestore fields
    final wallet = json['wallet'] is Map ? json['wallet'] : {};
    final profile =
        json['providerProfile'] is Map ? json['providerProfile'] : {};

    // Balance can be in wallet.balance or wallet_balance (flat)
    double bal = 0.0;
    if (json['wallet_balance'] != null) {
      bal = (json['wallet_balance'] as num).toDouble();
    } else if (wallet['balance'] != null) {
      bal = (wallet['balance'] as num).toDouble();
    }

    return User(
      id: json['uid'] ?? json['id'] ?? json['_id'] ?? '',
      displayName: json['displayName'] ?? json['display_name'] ?? 'Usuario',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone_number'] ?? '',
      photoUrl: json['photoURL'] ?? json['photo_url'] ?? '',
      role: json['role'] ?? 'user',
      balance: bal,
      currency: wallet['currency'] ?? 'USD',
      isProvider: profile['isProvider'] ?? false,
      createdAt: json['created_time'] != null
          ? DateTime.tryParse(json['created_time'].toString()) ?? DateTime.now()
          : (json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now()),
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      isBlocked: json['isBlocked'] ?? json['is_blocked'] ?? false,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      totalSpent: (json['totalSpent'] ?? json['total_spent'] ?? 0).toDouble(),
      totalPurchases:
          (json['totalPurchases'] ?? json['total_purchases'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoUrl,
      'role': role,
      'wallet': {
        'balance': balance,
        'currency': currency,
      },
      'providerProfile': {
        'isProvider': isProvider,
      },
      'createdAt': createdAt.toIso8601String(),
      'isBlocked': isBlocked,
    };
  }
}
