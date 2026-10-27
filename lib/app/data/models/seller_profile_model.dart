class SellerProfileResponseModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final SellerProfileData? data;

  SellerProfileResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory SellerProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return SellerProfileResponseModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SellerProfileData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class SellerProfileData {
  final String? id;
  final String? userId;
  final String? businessName;
  final String? ownerName;
  final String? phone;
  final List<String> cuisineTypes;
  final String? description;
  final String? address;
  final double? latitude;
  final double? longitude;
  final SellerLocation? location;
  final num? averageRating;
  final int? reviewCount;
  final SellerWorkingHours? workingHours;
  final bool? pickupAvailable;
  final bool? deliveryAvailable;
  final List<String> kitchenImages;
  final String? governmentId;
  final String? status;
  final String? adminNote;
  final String? createdAt;
  final String? updatedAt;
  final SellerUser? user;
  final SellerStats? stats;
  final int? orders;
  final int? pending;
  final int? completed;

  SellerProfileData({
    this.id,
    this.userId,
    this.businessName,
    this.ownerName,
    this.phone,
    this.cuisineTypes = const [],
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.location,
    this.averageRating,
    this.reviewCount,
    this.workingHours,
    this.pickupAvailable,
    this.deliveryAvailable,
    this.kitchenImages = const [],
    this.governmentId,
    this.status,
    this.adminNote,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.stats,
    this.orders,
    this.pending,
    this.completed,
  });

  factory SellerProfileData.fromJson(Map<String, dynamic> json) {
    List<String> parsedCuisines = [];
    if (json['cuisineTypes'] is List) {
      parsedCuisines = (json['cuisineTypes'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    List<String> parsedImages = [];
    if (json['kitchenImages'] is List) {
      parsedImages = (json['kitchenImages'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return SellerProfileData(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      userId: json['userId']?.toString(),
      businessName: json['businessName']?.toString(),
      ownerName: json['ownerName']?.toString(),
      phone: json['phone']?.toString(),
      cuisineTypes: parsedCuisines,
      description: json['description']?.toString(),
      address: json['address']?.toString(),
      latitude: json['latitude'] is num
          ? (json['latitude'] as num).toDouble()
          : double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : double.tryParse(json['longitude']?.toString() ?? ''),
      location: json['location'] != null && json['location'] is Map<String, dynamic>
          ? SellerLocation.fromJson(json['location'])
          : null,
      averageRating: json['averageRating'] is num
          ? (json['averageRating'] as num)
          : num.tryParse(json['averageRating']?.toString() ?? ''),
      reviewCount: json['reviewCount'] is int
          ? json['reviewCount']
          : int.tryParse(json['reviewCount']?.toString() ?? ''),
      workingHours: json['workingHours'] != null && json['workingHours'] is Map<String, dynamic>
          ? SellerWorkingHours.fromJson(json['workingHours'])
          : null,
      pickupAvailable: json['pickupAvailable'] is bool
          ? json['pickupAvailable']
          : (json['pickupAvailable']?.toString().toLowerCase() == 'true'),
      deliveryAvailable: json['deliveryAvailable'] is bool
          ? json['deliveryAvailable']
          : (json['deliveryAvailable']?.toString().toLowerCase() == 'true'),
      kitchenImages: parsedImages,
      governmentId: json['governmentId']?.toString(),
      status: json['status']?.toString(),
      adminNote: json['adminNote']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? SellerUser.fromJson(json['user'])
          : null,
      stats: json['stats'] != null && json['stats'] is Map<String, dynamic>
          ? SellerStats.fromJson(json['stats'])
          : null,
      orders: json['orders'] is int
          ? json['orders']
          : int.tryParse(json['orders']?.toString() ?? ''),
      pending: json['pending'] is int
          ? json['pending']
          : int.tryParse(json['pending']?.toString() ?? ''),
      completed: json['completed'] is int
          ? json['completed']
          : int.tryParse(json['completed']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessName': businessName,
      'ownerName': ownerName,
      'phone': phone,
      'cuisineTypes': cuisineTypes,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (location != null) 'location': location!.toJson(),
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      if (workingHours != null) 'workingHours': workingHours!.toJson(),
      'pickupAvailable': pickupAvailable,
      'deliveryAvailable': deliveryAvailable,
      'kitchenImages': kitchenImages,
      'governmentId': governmentId,
      'status': status,
      'adminNote': adminNote,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (user != null) 'user': user!.toJson(),
      if (stats != null) 'stats': stats!.toJson(),
      'orders': orders,
      'pending': pending,
      'completed': completed,
    };
  }

  // --- Convenience Getters ---
  int get totalOrders => stats?.orders ?? orders ?? 0;
  int get pendingOrders => stats?.pending ?? pending ?? 0;
  int get completedOrders => stats?.completed ?? completed ?? 0;

  String? get avatarUrl =>
      user?.profilePicture ?? (kitchenImages.isNotEmpty ? kitchenImages.first : null);

  String get displayBusinessName => businessName?.isNotEmpty == true
      ? businessName!
      : (ownerName != null && ownerName!.isNotEmpty
          ? "$ownerName's Kitchen"
          : (user?.name != null && user!.name!.isNotEmpty
              ? "${user!.name}'s Kitchen"
              : "My Kitchen"));

  String get displayOwnerName => ownerName?.isNotEmpty == true
      ? ownerName!
      : (user?.name ?? '');

  bool get isApproved => status?.toUpperCase() == 'APPROVED';
}

class SellerLocation {
  final String? type;
  final List<double> coordinates;

  SellerLocation({
    this.type,
    this.coordinates = const [],
  });

  factory SellerLocation.fromJson(Map<String, dynamic> json) {
    List<double> coords = [];
    if (json['coordinates'] is List) {
      coords = (json['coordinates'] as List)
          .map((e) => e is num ? e.toDouble() : double.tryParse(e?.toString() ?? ''))
          .whereType<double>()
          .toList();
    }
    return SellerLocation(
      type: json['type']?.toString(),
      coordinates: coords,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class SellerWorkingHours {
  final SellerDaySchedule? monFri;
  final SellerDaySchedule? saturday;
  final SellerDaySchedule? sunday;

  SellerWorkingHours({
    this.monFri,
    this.saturday,
    this.sunday,
  });

  factory SellerWorkingHours.fromJson(Map<String, dynamic> json) {
    return SellerWorkingHours(
      monFri: json['mon_fri'] != null && json['mon_fri'] is Map<String, dynamic>
          ? SellerDaySchedule.fromJson(json['mon_fri'])
          : null,
      saturday: json['saturday'] != null && json['saturday'] is Map<String, dynamic>
          ? SellerDaySchedule.fromJson(json['saturday'])
          : null,
      sunday: json['sunday'] != null && json['sunday'] is Map<String, dynamic>
          ? SellerDaySchedule.fromJson(json['sunday'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (monFri != null) 'mon_fri': monFri!.toJson(),
      if (saturday != null) 'saturday': saturday!.toJson(),
      if (sunday != null) 'sunday': sunday!.toJson(),
    };
  }
}

class SellerDaySchedule {
  final String? open;
  final String? close;
  final bool? isOpen;

  SellerDaySchedule({
    this.open,
    this.close,
    this.isOpen,
  });

  factory SellerDaySchedule.fromJson(Map<String, dynamic> json) {
    return SellerDaySchedule(
      open: json['open']?.toString(),
      close: json['close']?.toString(),
      isOpen: json['isOpen'] is bool
          ? json['isOpen']
          : (json['isOpen']?.toString().toLowerCase() == 'true'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'close': close,
      'isOpen': isOpen,
    };
  }
}

class SellerUser {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final bool? isSeller;
  final String? profilePicture;

  SellerUser({
    this.id,
    this.name,
    this.email,
    this.role,
    this.isSeller,
    this.profilePicture,
  });

  factory SellerUser.fromJson(Map<String, dynamic> json) {
    return SellerUser(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      role: json['role']?.toString(),
      isSeller: json['isSeller'] is bool
          ? json['isSeller']
          : (json['isSeller']?.toString().toLowerCase() == 'true'),
      profilePicture: json['profilePicture']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isSeller': isSeller,
      'profilePicture': profilePicture,
    };
  }
}

class SellerStats {
  final int? orders;
  final int? pending;
  final int? completed;

  SellerStats({
    this.orders,
    this.pending,
    this.completed,
  });

  factory SellerStats.fromJson(Map<String, dynamic> json) {
    return SellerStats(
      orders: json['orders'] is int
          ? json['orders']
          : int.tryParse(json['orders']?.toString() ?? ''),
      pending: json['pending'] is int
          ? json['pending']
          : int.tryParse(json['pending']?.toString() ?? ''),
      completed: json['completed'] is int
          ? json['completed']
          : int.tryParse(json['completed']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders,
      'pending': pending,
      'completed': completed,
    };
  }
}
