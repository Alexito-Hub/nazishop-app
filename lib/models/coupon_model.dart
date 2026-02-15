class Coupon {
  final String id;
  final String code;
  final String discountType; // 'percentage' or 'fixed'
  final double value;
  final DateTime? validUntil;
  final int usageLimit;
  final int usedCount;
  final bool isActive;

  Coupon({
    required this.id,
    required this.code,
    required this.discountType,
    required this.value,
    this.validUntil,
    required this.usageLimit,
    required this.usedCount,
    required this.isActive,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      discountType: json['discountType'] ?? 'percentage',
      value: (json['value'] ?? 0).toDouble(),
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'])
          : null,
      usageLimit: json['usageLimit'] ?? 0,
      usedCount: json['usedCount'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'discountType': discountType,
      'value': value,
      'validUntil': validUntil?.toIso8601String(),
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
    };
  }
}
