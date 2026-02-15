class Promotion {
  final String id;
  final String name;
  final String? description;
  final List<String> listingIds;
  final double? originalPrice;
  final double finalPrice;
  final int? discountPercent;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool isActive;
  final bool isFeatured;

  Promotion({
    required this.id,
    required this.name,
    this.description,
    this.listingIds = const [],
    this.originalPrice,
    required this.finalPrice,
    this.discountPercent,
    this.validFrom,
    this.validUntil,
    this.isActive = true,
    this.isFeatured = false,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Untitled Promo',
      description: json['description'],
      listingIds:
          (json['listingIds'] as List?)?.map((e) => e.toString()).toList() ??
              [],
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      discountPercent: (json['discountPercent'] as num?)?.toInt(),
      validFrom: json['validFrom'] != null
          ? DateTime.tryParse(json['validFrom'])
          : null,
      validUntil: json['validUntil'] != null
          ? DateTime.tryParse(json['validUntil'])
          : null,
      isActive: json['isActive'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'listingIds': listingIds,
      'finalPrice':
          finalPrice, // Backend calculates discount/original if only final is sent, or we send all
      'validFrom': validFrom?.toIso8601String(),
      'validUntil': validUntil?.toIso8601String(),
      'isActive': isActive,
      'isFeatured': isFeatured,
    };
  }
}
