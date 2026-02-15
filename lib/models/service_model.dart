import 'offer_model.dart';

class Service {
  final String id;
  final String code;
  final String name;
  final String description;
  final String categoryId;
  final String? categoryName; // Added for UI display
  final ServiceBranding branding;
  final bool isActive;
  final List<Offer>? offers; // Legacy compatibility
  final List<Offer>? individualOffers; // New: Individual plans (0% discount)
  final List<Offer>? packageOffers; // New: Package deals with discounts
  final bool? hasStock; // New: Has any stock available
  final double? lowestPrice; // New: Lowest price available
  final List<String>? features; // New: Detailed features
  final String? duration; // New: Validity period
  final int? rawStock; // New: Physical stock count from DB
  final String? image; // New: Service image URL
  final ServiceTechnicalInfo? technicalInfo; // New: Technical details

  Service({
    required this.id,
    required this.code,
    required this.name,
    this.description = '',
    required this.categoryId,
    this.categoryName,
    required this.branding,
    this.isActive = true,
    this.offers,
    this.individualOffers,
    this.packageOffers,
    this.hasStock,
    this.lowestPrice,
    this.features,
    this.duration,
    this.rawStock,
    this.image,
    this.technicalInfo,
  });

  String get category => categoryName ?? 'Otros';

  // Getters to calculate price from offers (prioritize individual offers)
  String get currency {
    if (individualOffers != null && individualOffers!.isNotEmpty) {
      return individualOffers!.first.currency;
    }
    if (offers != null && offers!.isNotEmpty) {
      return offers!.first.currency;
    }
    return 'USD'; // Default currency
  }

  double get price {
    // First try individual offers (these are the base prices)
    if (individualOffers != null && individualOffers!.isNotEmpty) {
      final prices = individualOffers!
          .where((offer) => offer.discountPrice > 0 && offer.inStock)
          .map((offer) => offer.discountPrice)
          .toList();
      if (prices.isNotEmpty) {
        prices.sort();
        return prices.first; // Return lowest individual price
      }
    }

    // Fallback to legacy offers
    if (offers != null && offers!.isNotEmpty) {
      // First try to find individual offer (0% discount)
      final individualOffer = offers!.firstWhere(
        (offer) => offer.discountPercent == 0,
        orElse: () => offers!.first,
      );

      if (individualOffer.discountPrice > 0) {
        return individualOffer.discountPrice;
      }

      // Fallback to lowest price from any offer
      final prices = offers!
          .where((offer) => offer.discountPrice > 0)
          .map((offer) => offer.discountPrice)
          .toList();
      if (prices.isNotEmpty) {
        prices.sort();
        return prices.first;
      }
    }
    return 0.0; // Default price
  }

  // Check if service has available stock
  bool get isInStock {
    if (hasStock != null) {
      return hasStock!;
    }

    // Legacy compatibility: check offers
    if (offers != null && offers!.isNotEmpty) {
      return offers!.any((offer) => offer.inStock);
    }

    return false;
  }

  // Get stock count - simplified version for UI display
  int get stock {
    if (rawStock != null) return rawStock!;
    if (offers != null && offers!.isNotEmpty) {
      // Sum up stock from all offers (simplified)
      return offers!.fold(0, (sum, offer) => sum + (offer.inStock ? 5 : 0));
    }
    return isInStock ? 5 : 0; // Default stock display
  }

  // Get image URL for display
  String? get imageUrl {
    return image ??
        branding.logoUrl; // Using image or branding.logoUrl as imageUrl
  }

  // Base price for compatibility
  double get basePrice => price;

  factory Service.fromJson(Map<String, dynamic> json) {
    List<Offer>? offersList;
    if (json['offers'] != null) {
      offersList =
          (json['offers'] as List).map((i) => Offer.fromJson(i)).toList();
    }

    List<Offer>? individualOffersList;
    if (json['individualOffers'] != null) {
      individualOffersList = (json['individualOffers'] as List)
          .map((i) => Offer.fromJson(i))
          .toList();
    }

    List<Offer>? packageOffersList;
    if (json['packageOffers'] != null) {
      packageOffersList = (json['packageOffers'] as List)
          .map((i) => Offer.fromJson(i))
          .toList();
    }

    String catId = '';
    String? catName;

    if (json['categoryId'] is String) {
      catId = json['categoryId'];
    } else if (json['categoryId'] != null) {
      catId = json['categoryId']['_id'] ?? '';
      catName = json['categoryId']['name'];
    }

    return Service(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      categoryId: catId,
      categoryName: catName,
      branding: ServiceBranding.fromJson(json['branding'] ?? {}),
      isActive: json['isActive'] ?? true,
      offers: offersList,
      individualOffers: individualOffersList,
      packageOffers: packageOffersList,
      hasStock: json['hasStock'],
      lowestPrice: json['lowestPrice']?.toDouble(),
      features:
          json['features'] != null ? List<String>.from(json['features']) : null,
      duration: json['duration'],
      rawStock: json['stock'],
      image: json['image'],
      technicalInfo: json['technicalInfo'] != null
          ? ServiceTechnicalInfo.fromJson(json['technicalInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'code': code,
        'name': name,
        'description': description,
        'categoryId': categoryId,
        'branding': branding.toJson(),
        'isActive': isActive,
        if (offers != null) 'offers': offers!.map((o) => o.toJson()).toList(),
        if (individualOffers != null)
          'individualOffers': individualOffers!.map((o) => o.toJson()).toList(),
        if (packageOffers != null)
          'packageOffers': packageOffers!.map((o) => o.toJson()).toList(),
        if (hasStock != null) 'hasStock': hasStock,
        if (lowestPrice != null) 'lowestPrice': lowestPrice,
      };
}

class ServiceBranding {
  final String? primaryColor;
  final String? secondaryColor;
  final String? logoUrl;
  final String? bannerUrl;

  ServiceBranding({
    this.primaryColor,
    this.secondaryColor,
    this.logoUrl,
    this.bannerUrl,
  });

  factory ServiceBranding.fromJson(Map<String, dynamic> json) {
    return ServiceBranding(
      primaryColor: json['primaryColor'],
      secondaryColor: json['secondaryColor'],
      logoUrl: json['logoUrl'],
      bannerUrl: json['bannerUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'logoUrl': logoUrl,
        'bannerUrl': bannerUrl,
      };
}

class ServiceTechnicalInfo {
  final String? platform;
  final String? website;
  final String region;
  final List<String> requirements;
  final int? deviceLimit;

  ServiceTechnicalInfo({
    this.platform,
    this.website,
    this.region = 'GLOBAL',
    this.requirements = const [],
    this.deviceLimit,
  });

  factory ServiceTechnicalInfo.fromJson(Map<String, dynamic> json) {
    return ServiceTechnicalInfo(
      platform: json['platform'],
      website: json['website'],
      region: json['region'] ?? 'GLOBAL',
      requirements:
          (json['requirements'] as List?)?.map((e) => e.toString()).toList() ??
              [],
      deviceLimit: json['deviceLimit'],
    );
  }
}
