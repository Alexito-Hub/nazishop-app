class Offer {
  final String id;
  final String title;
  final String? description;
  final double originalPrice;
  final double discountPrice;
  final int discountPercent;
  final String currency;
  final List<String> serviceIds;
  final List<String> services;
  final bool isActive;
  final DateTime? validUntil;
  final int? availableStock; // New: Available stock count
  final bool inStock; // New: Whether item is in stock
  final String? dataDeliveryType; // New: Delivery type field
  final OfferUI? uiData; // New: UI specific data
  final OfferCommercial? commercialData; // New: Commercial/Plan data
  final List<String>? tags; // New: Tags
  final List<UsageRule>? usageRules; // New: Usage Rules
  final RegionAvailability? regionAvailability; // New: Country lock
  final String? warrantyPeriod;
  final String? refundPolicy;
  final String? domainType; // New: sub-type for domain delivery
  final int? domainStock; // New: stock for own_domain

  Offer({
    required this.id,
    required this.title,
    this.description,
    required this.originalPrice,
    required this.discountPrice,
    required this.discountPercent,
    this.currency = 'USD',
    required this.serviceIds,
    required this.services,
    this.isActive = true,
    this.validUntil,
    this.availableStock,
    this.inStock = true,
    this.dataDeliveryType,
    this.uiData,
    this.commercialData,
    this.tags,
    this.usageRules,
    this.regionAvailability,
    this.warrantyPeriod,
    this.refundPolicy,
    this.domainType,
    this.domainStock,
  });

  // Legacy getters for backward compatibility
  OfferCommercial get commercial => commercialData ?? OfferCommercial();
  OfferPricing get pricing =>
      OfferPricing(amount: discountPrice, currency: currency);
  OfferUI get ui =>
      uiData ??
      OfferUI(badge: '$discountPercent% OFF', highlight: discountPercent > 20);
  String get serviceId => serviceIds.isNotEmpty ? serviceIds.first : '';
  String get categoryId => '';
  bool get isFeatured => discountPercent >= 20;

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Untitled Offer',
      description: json['description'],
      // Support 'price' from Listing model, fallback to 'originalPrice'
      originalPrice: (json['price'] as num?)?.toDouble() ??
          (json['originalPrice'] as num?)?.toDouble() ??
          0.0,
      discountPrice: (json['price'] as num?)?.toDouble() ??
          (json['discountPrice'] as num?)?.toDouble() ??
          0.0,
      discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
      currency: json['currency'] ?? 'USD',
      serviceIds: (json['serviceId'] != null) // Support single serviceId
          ? [json['serviceId'].toString()]
          : (json['serviceIds'] is List)
              ? List<String>.from(json['serviceIds'])
              : [],
      services: (json['services']
              is List) // listing doesn't usually populate services names array, but keep checks
          ? List<String>.from(json['services'])
          : [],
      isActive: json['isActive'] ?? true,
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'])
          : null,
      availableStock: json['availableStock'],
      inStock: json['inStock'] ?? true,
      dataDeliveryType: json['dataDeliveryType'],
      uiData: json['ui'] != null ? OfferUI.fromJson(json['ui']) : null,
      commercialData: json['commercial'] != null
          ? OfferCommercial.fromJson(json['commercial'])
          : null,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      usageRules: (json['usageRules'] as List?)
          ?.map((e) => UsageRule.fromJson(e))
          .toList(),
      regionAvailability: json['regionAvailability'] != null
          ? RegionAvailability.fromJson(json['regionAvailability'])
          : null,
      warrantyPeriod:
          json['commercial']?['warrantyPeriod'] ?? json['warrantyPeriod'],
      refundPolicy: json['commercial']?['refundPolicy'] ?? json['refundPolicy'],
      domainType: json['domainType'],
      domainStock: json['domainStock'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'description': description,
        'originalPrice': originalPrice,
        'discountPrice': discountPrice,
        'discountPercent': discountPercent,
        'currency': currency,
        'serviceIds': serviceIds,
        'services': services,
        'isActive': isActive,
        'validUntil': validUntil?.toIso8601String(),
        'availableStock': availableStock,
        'inStock': inStock,
        'dataDeliveryType': dataDeliveryType,
        'domainType': domainType,
        'domainStock': domainStock,
      };
}

class OfferCommercial {
  final String? plan;
  final String? accessType;
  final int? duration;
  final String? timeUnit;
  final String? warrantyPeriod; // New
  final String? refundPolicy; // New
  final bool isRenewable; // New

  OfferCommercial({
    this.plan,
    this.accessType,
    this.duration,
    this.timeUnit,
    this.warrantyPeriod,
    this.refundPolicy,
    this.isRenewable = false,
  });

  factory OfferCommercial.fromJson(Map<String, dynamic> json) {
    return OfferCommercial(
      plan: json['plan'],
      accessType: json['accessType'],
      duration: json['duration'],
      timeUnit: json['timeUnit'],
      warrantyPeriod: json['warrantyPeriod'],
      refundPolicy: json['refundPolicy'],
      isRenewable: json['isRenewable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'plan': plan,
        'accessType': accessType,
        'duration': duration,
        'timeUnit': timeUnit,
        'warrantyPeriod': warrantyPeriod,
        'refundPolicy': refundPolicy,
        'isRenewable': isRenewable,
      };
}

class OfferPricing {
  final double amount;
  final String currency;

  OfferPricing({
    required this.amount,
    required this.currency,
  });

  factory OfferPricing.fromJson(Map<String, dynamic> json) {
    return OfferPricing(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
      };
}

class OfferUI {
  final String? badge;
  final bool highlight;
  final String? badgeColor;
  final List<DisplayTag>? displayTags;

  OfferUI({
    this.badge,
    this.highlight = false,
    this.badgeColor,
    this.displayTags,
  });

  factory OfferUI.fromJson(Map<String, dynamic> json) {
    return OfferUI(
      badge: json['badge'],
      highlight: json['highlight'] ?? false,
      badgeColor: json['badgeColor'],
      displayTags: (json['displayTags'] as List?)
          ?.map((e) => DisplayTag.fromJson(e))
          .toList(),
    );
  }
}

class DisplayTag {
  final String? text;
  final String? icon;
  final String? color;

  DisplayTag({this.text, this.icon, this.color});

  factory DisplayTag.fromJson(Map<String, dynamic> json) {
    return DisplayTag(
      text: json['text'],
      icon: json['icon'],
      color: json['color'],
    );
  }
}

class UsageRule {
  final String title;
  final String? description;
  final String? icon;
  final bool isCritical;

  UsageRule(
      {required this.title,
      this.description,
      this.icon,
      this.isCritical = false});

  factory UsageRule.fromJson(Map<String, dynamic> json) {
    return UsageRule(
      title: json['title'] ?? 'Rule',
      description: json['description'],
      icon: json['icon'],
      isCritical: json['isCritical'] ?? false,
    );
  }
}

class RegionAvailability {
  final bool isGlobal;
  final List<String> allowedCountries;
  final List<String> restrictedCountries;

  RegionAvailability(
      {this.isGlobal = true,
      this.allowedCountries = const [],
      this.restrictedCountries = const []});

  factory RegionAvailability.fromJson(Map<String, dynamic> json) {
    return RegionAvailability(
      isGlobal: json['isGlobal'] ?? true,
      allowedCountries: (json['allowedCountries'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      restrictedCountries: (json['restrictedCountries'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
