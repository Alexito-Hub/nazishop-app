class ReviewModel {
  final String id;
  final String userId;
  final String serviceId;
  final String orderId;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final ReviewUser? user;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.orderId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      serviceId: json['serviceId'] ?? '',
      orderId: json['orderId'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      user: json['user'] != null ? ReviewUser.fromJson(json['user']) : null,
    );
  }
}

class ReviewUser {
  final String displayName;
  final String? photoURL;

  ReviewUser({
    required this.displayName,
    this.photoURL,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      displayName: json['displayName'] ?? 'Usuario',
      photoURL: json['photoURL'],
    );
  }
}
