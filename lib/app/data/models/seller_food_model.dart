class SellerFoodResponseModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final SellerFoodData? data;

  SellerFoodResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory SellerFoodResponseModel.fromJson(Map<String, dynamic> json) {
    return SellerFoodResponseModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SellerFoodData.fromJson(json['data'])
          : null,
    );
  }
}

class SellerFoodData {
  final SellerFoodMeta? meta;
  final List<SellerFoodItem> foods;

  SellerFoodData({
    this.meta,
    required this.foods,
  });

  factory SellerFoodData.fromJson(Map<String, dynamic> json) {
    final list = json['data'];
    List<SellerFoodItem> items = [];
    if (list is List) {
      items = list
          .whereType<Map<String, dynamic>>()
          .map((e) => SellerFoodItem.fromJson(e))
          .toList();
    }
    return SellerFoodData(
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? SellerFoodMeta.fromJson(json['meta'])
          : null,
      foods: items,
    );
  }
}

class SellerFoodMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  SellerFoodMeta({
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.totalPage = 1,
  });

  factory SellerFoodMeta.fromJson(Map<String, dynamic> json) {
    return SellerFoodMeta(
      page: _parseInt(json['page'], 1),
      limit: _parseInt(json['limit'], 10),
      total: _parseInt(json['total'], 0),
      totalPage: _parseInt(json['totalPage'], 1),
    );
  }

  static int _parseInt(dynamic val, int fallback) {
    if (val is int) return val;
    return int.tryParse(val?.toString() ?? '') ?? fallback;
  }
}

class SellerFoodIngredient {
  final String name;
  final num quantity;
  final String unit;

  SellerFoodIngredient({
    this.name = '',
    this.quantity = 1,
    this.unit = '',
  });

  factory SellerFoodIngredient.fromJson(Map<String, dynamic> json) {
    return SellerFoodIngredient(
      name: json['name']?.toString() ?? '',
      quantity: _parseQuantity(json['quantity']),
      unit: json['unit']?.toString() ?? '',
    );
  }

  static num _parseQuantity(dynamic val) {
    if (val is num) return val;
    if (val != null) {
      final parsed = num.tryParse(val.toString());
      if (parsed != null) return parsed;
    }
    return 1;
  }

  String get displayQuantity {
    final qStr = quantity % 1 == 0 ? quantity.toInt().toString() : quantity.toString();
    if (qStr.isEmpty || qStr == '0') return unit;
    if (unit.isEmpty) return qStr;
    return '$qStr $unit';
  }
}

class SellerFoodItem {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final String category;
  final String subcategory;
  final double price;
  final String preparationTime;
  final List<SellerFoodIngredient> ingredients;
  final bool pickupAvailable;
  final bool deliveryAvailable;
  final double deliveryFee;
  final String status;
  final String sellerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SellerFoodItem({
    required this.id,
    required this.name,
    this.description = '',
    this.images = const [],
    this.category = '',
    this.subcategory = '',
    this.price = 0.0,
    this.preparationTime = '',
    this.ingredients = const [],
    this.pickupAvailable = false,
    this.deliveryAvailable = false,
    this.deliveryFee = 0.0,
    this.status = 'PENDING',
    this.sellerId = '',
    this.createdAt,
    this.updatedAt,
  });

  factory SellerFoodItem.fromJson(Map<String, dynamic> json) {
    List<String> imgList = [];
    if (json['images'] is List) {
      imgList = (json['images'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    List<SellerFoodIngredient> ingList = [];
    if (json['ingredients'] is List) {
      ingList = (json['ingredients'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => SellerFoodIngredient.fromJson(e))
          .toList();
    }

    return SellerFoodItem(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Food Item',
      description: json['description']?.toString() ?? '',
      images: imgList,
      category: json['category']?.toString() ?? '',
      subcategory: json['subcategory']?.toString() ?? '',
      price: _parseDouble(json['price'], 0.0),
      preparationTime: json['preparationTime']?.toString() ?? '20 mins',
      ingredients: ingList,
      pickupAvailable: json['pickupAvailable'] == true,
      deliveryAvailable: json['deliveryAvailable'] == true,
      deliveryFee: _parseDouble(json['deliveryFee'], 0.0),
      status: json['status']?.toString() ?? 'PENDING',
      sellerId: json['sellerId']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  static double _parseDouble(dynamic val, double fallback) {
    if (val is num) return val.toDouble();
    return double.tryParse(val?.toString() ?? '') ?? fallback;
  }

  String get firstImage => images.isNotEmpty ? images.first : '';

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  String get displayCategory {
    final cat = category.toUpperCase().trim();
    if (cat.isEmpty) return '';
    return '${cat[0]}${cat.substring(1).toLowerCase()}';
  }

  String get displaySubcategory {
    final sub = subcategory.toUpperCase().trim();
    if (sub.isEmpty) return '';
    return '${sub[0]}${sub.substring(1).toLowerCase()}';
  }

  String get categorySubtitle {
    if (displayCategory.isNotEmpty && displaySubcategory.isNotEmpty) {
      return '$displayCategory • $displaySubcategory';
    } else if (displayCategory.isNotEmpty) {
      return displayCategory;
    }
    return displaySubcategory;
  }

  String get deliveryText {
    if (deliveryAvailable && pickupAvailable) {
      return 'Delivery & Pickup';
    } else if (deliveryAvailable) {
      return 'Delivery only';
    } else if (pickupAvailable) {
      return 'Pickup only';
    }
    return 'Dine-in / Pickup';
  }

  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isApproved =>
      status.toUpperCase() == 'APPROVED' || status.toUpperCase() == 'ACTIVE';
  bool get isRejected => status.toUpperCase() == 'REJECTED';
}
