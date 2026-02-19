class Listing {
  final String id;
  final dynamic service; // Internal for populated service data
  final String serviceId;
  final String? categoryId;
  final String? description;
  final double price;
  final String currency;
  final ListingCommercial? commercial;
  final List<ListingUsageRule>? usageRules;
  final ListingRegionAvailability? regionAvailability;
  final String providerId;
  final ListingDelivery? delivery;
  final int? domainStock;
  final List<String>? tags;
  final ListingUI? ui;
  final bool isActive;
  final bool isFeatured;

  String get title {
    final serviceName = (service is Map ? service['name'] : null) ?? 'Service';
    final plan = commercial?.plan ?? 'Standard';
    final duration = commercial?.duration != null
        ? '${commercial!.duration} ${commercial!.timeUnit ?? 'Days'}'
        : '';
    return '$serviceName - $plan $duration'.trim();
  }

  Listing({
    required this.id,
    required this.serviceId,
    this.service,
    this.categoryId,
    this.description,
    required this.price,
    this.currency = 'USD',
    this.commercial,
    this.usageRules,
    this.regionAvailability,
    required this.providerId,
    this.delivery,
    this.domainStock,
    this.tags,
    this.ui,
    this.isActive = true,
    this.isFeatured = false,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['_id'] ?? '',
      serviceId: json['serviceId'] is String
          ? json['serviceId']
          : (json['serviceId']?['_id'] ?? ''),
      service: json['serviceId'] is Map ? json['serviceId'] : null,
      categoryId: json['categoryId'] is String
          ? json['categoryId']
          : (json['categoryId']?['_id'] ?? ''),
      description: json['description'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      commercial: json['commercial'] != null
          ? ListingCommercial.fromJson(json['commercial'])
          : null,
      usageRules: (json['usageRules'] as List?)
          ?.map((e) => ListingUsageRule.fromJson(e))
          .toList(),
      regionAvailability: json['regionAvailability'] != null
          ? ListingRegionAvailability.fromJson(json['regionAvailability'])
          : null,
      providerId: json['providerId'] is String
          ? json['providerId']
          : (json['providerId']?['_id'] ?? ''),
      delivery: json['delivery'] != null
          ? ListingDelivery.fromJson(json['delivery'])
          : null,
      domainStock: json['domainStock'],
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      ui: json['ui'] != null ? ListingUI.fromJson(json['ui']) : null,
      isActive: json['isActive'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'serviceId': serviceId,
        'categoryId': categoryId,
        'description': description,
        'price': price,
        'currency': currency,
        'commercial': commercial?.toJson(),
        'usageRules': usageRules?.map((e) => e.toJson()).toList(),
        'regionAvailability': regionAvailability?.toJson(),
        'providerId': providerId,
        'delivery': delivery?.toJson(),
        'domainStock': domainStock,
        'tags': tags,
        'ui': ui?.toJson(),
        'isActive': isActive,
        'isFeatured': isFeatured,
      };
}

class ListingDelivery {
  final String type;
  final String? domainType;

  ListingDelivery({
    required this.type,
    this.domainType,
  });

  factory ListingDelivery.fromJson(Map<String, dynamic> json) {
    return ListingDelivery(
      type: json['type'] ?? 'unknown',
      domainType: json['domainType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'domainType': domainType,
      };
}

class ListingCommercial {
  final String? plan;
  final int? duration;
  final String? timeUnit;
  final String? warrantyPeriod;
  final String? refundPolicy;
  final String? deliverySpeed;
  final bool isRenewable;

  ListingCommercial({
    this.plan,
    this.duration,
    this.timeUnit,
    this.warrantyPeriod,
    this.refundPolicy,
    this.deliverySpeed,
    this.isRenewable = false,
  });

  factory ListingCommercial.fromJson(Map<String, dynamic> json) {
    return ListingCommercial(
      plan: json['plan'],
      duration: json['duration'],
      timeUnit: json['timeUnit'],
      warrantyPeriod: json['warrantyPeriod'],
      refundPolicy: json['refundPolicy'],
      deliverySpeed: json['deliverySpeed'],
      isRenewable: json['isRenewable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'plan': plan,
        'duration': duration,
        'timeUnit': timeUnit,
        'warrantyPeriod': warrantyPeriod,
        'refundPolicy': refundPolicy,
        'deliverySpeed': deliverySpeed,
        'isRenewable': isRenewable,
      };
}

class ListingUsageRule {
  final String title;
  final String? description;
  final String? icon;
  final bool isCritical;

  ListingUsageRule({
    required this.title,
    this.description,
    this.icon,
    this.isCritical = false,
  });

  factory ListingUsageRule.fromJson(Map<String, dynamic> json) {
    return ListingUsageRule(
      title: json['title'] ?? '',
      description: json['description'],
      icon: json['icon'],
      isCritical: json['isCritical'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'icon': icon,
        'isCritical': isCritical,
      };
}

class ListingRegionAvailability {
  final bool isGlobal;
  final List<String> allowedCountries;
  final List<String> restrictedCountries;

  ListingRegionAvailability({
    this.isGlobal = true,
    this.allowedCountries = const [],
    this.restrictedCountries = const [],
  });

  factory ListingRegionAvailability.fromJson(Map<String, dynamic> json) {
    return ListingRegionAvailability(
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

  Map<String, dynamic> toJson() => {
        'isGlobal': isGlobal,
        'allowedCountries': allowedCountries,
        'restrictedCountries': restrictedCountries,
      };
}

class ListingUI {
  final String? badge;
  final String? badgeColor;
  final bool highlight;
  final List<ListingUITag>? displayTags;

  ListingUI({
    this.badge,
    this.badgeColor,
    this.highlight = false,
    this.displayTags,
  });

  factory ListingUI.fromJson(Map<String, dynamic> json) {
    return ListingUI(
      badge: json['badge'],
      badgeColor: json['badgeColor'],
      highlight: json['highlight'] ?? false,
      displayTags: (json['displayTags'] as List?)
          ?.map((e) => ListingUITag.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'badge': badge,
        'badgeColor': badgeColor,
        'highlight': highlight,
        'displayTags': displayTags?.map((e) => e.toJson()).toList(),
      };
}

class ListingUITag {
  final String? text;
  final String? icon;
  final String? color;

  ListingUITag({this.text, this.icon, this.color});

  factory ListingUITag.fromJson(Map<String, dynamic> json) {
    return ListingUITag(
      text: json['text'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'icon': icon,
        'color': color,
      };
}
