class Domain {
  final String id;
  final String orderId;
  final String userId;
  final String listingId;

  // Credenciales que el cliente desea usar para su servicio
  final DesiredCredentials desiredCredentials;

  final ProductSnapshot? productSnapshot;
  final String status;
  final String? adminNotes;
  final String? completedBy;
  final DateTime? completedAt;
  final String? inventoryId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Domain({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.listingId,
    required this.desiredCredentials,
    this.productSnapshot,
    required this.status,
    this.adminNotes,
    this.completedBy,
    this.completedAt,
    this.inventoryId,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Domain.fromJson(Map<String, dynamic> json) {
    return Domain(
      id: json['_id'] ?? json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      userId: json['userId'] ?? '',
      listingId: json['listingId'] is String
          ? json['listingId']
          : (json['listingId']?['_id'] ??
              json['offerId']?['_id'] ??
              json['offerId'] ??
              ''),
      desiredCredentials:
          DesiredCredentials.fromJson(json['desiredCredentials'] ?? {}),
      productSnapshot: json['productSnapshot'] != null
          ? ProductSnapshot.fromJson(json['productSnapshot'])
          : null,
      status: json['status'] ?? 'pending',
      adminNotes: json['adminNotes'],
      completedBy: json['completedBy'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      inventoryId: json['inventoryId'],
      isActive: json['isActive'] ?? true,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderId': orderId,
      'userId': userId,
      'listingId': listingId,
      'desiredCredentials': desiredCredentials.toJson(),
      'productSnapshot': productSnapshot?.toJson(),
      'status': status,
      'adminNotes': adminNotes,
      'completedBy': completedBy,
      'completedAt': completedAt?.toIso8601String(),
      'inventoryId': inventoryId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper getters
  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En Proceso';
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }
}

class DesiredCredentials {
  final String email;
  final String password;
  final String notes;

  DesiredCredentials({
    required this.email,
    this.password = '',
    this.notes = '',
  });

  factory DesiredCredentials.fromJson(Map<String, dynamic> json) {
    return DesiredCredentials(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'notes': notes,
    };
  }
}

class ProductSnapshot {
  final String title;
  final String? serviceId;
  final String? dataDeliveryType;

  ProductSnapshot({
    required this.title,
    this.serviceId,
    this.dataDeliveryType,
  });

  factory ProductSnapshot.fromJson(Map<String, dynamic> json) {
    return ProductSnapshot(
      title: json['title'] ?? 'Unknown Product',
      serviceId: json['serviceId']?.toString(),
      dataDeliveryType: json['dataDeliveryType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'serviceId': serviceId,
        'dataDeliveryType': dataDeliveryType,
      };
}
