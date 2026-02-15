class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'welcome', 'offer', 'order', 'security', 'system'
  final bool read;
  final DateTime createdAt;
  final String? icon;
  final String? imageUrl;
  final String? route;
  final String? priority;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
    this.icon,
    this.imageUrl,
    this.route,
    this.priority,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? 'ALL',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'system',
      read: json['read'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      icon: json['icon'],
      imageUrl: json['imageUrl'],
      route: json['route'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'read': read,
      'icon': icon,
      'imageUrl': imageUrl,
      'route': route,
      'priority': priority,
    };
  }
}
