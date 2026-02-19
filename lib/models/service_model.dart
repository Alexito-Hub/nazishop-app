import 'listing_model.dart';

class Service {
  final String id;
  final String code;
  final String name;
  final String description;
  final String categoryId;
  final String? categoryName; // Added for UI display
  final ServiceBranding branding;
  final bool isActive;
  final List<Listing>? listings;
  final bool? hasStock;
  final double? lowestPrice;
  final List<String>? features;
  final String? duration;
  final int? rawStock;
  final String? image;
  final ServiceTechnicalInfo? technicalInfo;
  final ServiceStats stats;
  bool isFavorite;

  Service({
    required this.id,
    required this.code,
    required this.name,
    this.description = '',
    required this.categoryId,
    this.categoryName,
    required this.branding,
    this.isActive = true,
    this.listings,
    this.hasStock,
    this.lowestPrice,
    this.features,
    this.duration,
    this.rawStock,
    this.image,
    this.technicalInfo,
    this.stats = const ServiceStats(),
    this.isFavorite = false,
  });

  String get category => categoryName ?? 'Otros';
// ... (keep existing getters)
  // Get image URL for display
  String? get imageUrl {
    return image ?? branding.logoUrl;
  }

  // Check if service has available stock
  bool get isInStock {
    if (hasStock != null) {
      return hasStock!;
    }
    // Check if any listing has stock (domainStock or assumption)
    // For now, if listing exists and is active, we assume stock unless specified otherwise
    if (listings != null && listings!.isNotEmpty) {
      return listings!.any((l) => l.isActive);
    }
    return false;
  }

  // Get stock count - simplified version for UI display
  int get stock {
    if (rawStock != null) return rawStock!;
    return isInStock ? 5 : 0; // Default stock display
  }

  // Base price for compatibility
  double get price {
    if (lowestPrice != null && lowestPrice! > 0) return lowestPrice!;

    if (listings != null && listings!.isNotEmpty) {
      final prices = listings!
          .where((l) => l.price > 0 && l.isActive)
          .map((l) => l.price)
          .toList();
      if (prices.isNotEmpty) {
        prices.sort();
        return prices.first; // Return lowest price
      }
    }
    return 0.0; // Default price
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    List<Listing>? listingsList;
    if (json['listings'] != null) {
      listingsList =
          (json['listings'] as List).map((i) => Listing.fromJson(i)).toList();
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
      listings: listingsList,
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
      stats: json['stats'] != null
          ? ServiceStats.fromJson(json['stats'])
          : const ServiceStats(),
      isFavorite: json['isFavorite'] ?? false,
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
        if (listings != null)
          'listings': listings!.map((l) => l.toJson()).toList(),
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

class ServiceStats {
  final double averageRating;
  final int totalReviews;
  final int totalFavorites;

  const ServiceStats({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.totalFavorites = 0,
  });

  factory ServiceStats.fromJson(Map<String, dynamic> json) {
    return ServiceStats(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
      totalFavorites: json['totalFavorites'] ?? 0,
    );
  }
}
