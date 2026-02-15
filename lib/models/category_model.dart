class Category {
  final String id;
  final String code;
  final String name;
  final String description;
  final CategoryUI ui;
  final bool isActive;
  final List<dynamic>?
      services; // Lista de servicios (puede venir del /api/catalog)

  Category({
    required this.id,
    required this.code,
    required this.name,
    this.description = '',
    required this.ui,
    this.isActive = true,
    this.services,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ui: CategoryUI.fromJson(json['ui'] ?? {}),
      isActive: json['isActive'] ?? true,
      services: json['services'], // Capturar servicios si vienen del backend
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'code': code,
        'name': name,
        'description': description,
        'ui': ui.toJson(),
        'isActive': isActive,
        if (services != null) 'services': services,
      };
}

class CategoryUI {
  final String? color;
  final String? icon;
  final String? imageUrl;

  CategoryUI({this.color, this.icon, this.imageUrl});

  factory CategoryUI.fromJson(Map<String, dynamic> json) {
    return CategoryUI(
      color: json['color'],
      icon: json['icon'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'color': color,
        'icon': icon,
        'imageUrl': imageUrl,
      };
}
