class BookmarkResponseModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final List<BookmarkFoodItem> data;

  BookmarkResponseModel({
    this.statusCode,
    this.success,
    this.message,
    required this.data,
  });

  factory BookmarkResponseModel.fromJson(Map<String, dynamic> json) {
    List<BookmarkFoodItem> items = [];
    final list = json['data'];
    if (list is List) {
      items = list
          .whereType<Map<String, dynamic>>()
          .map((e) => BookmarkFoodItem.fromJson(e))
          .toList();
    }

    return BookmarkResponseModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      message: json['message']?.toString(),
      data: items,
    );
  }
}

class BookmarkIngredient {
  final String name;
  final num quantity;
  final String unit;

  BookmarkIngredient({
    this.name = '',
    this.quantity = 1,
    this.unit = '',
  });

  factory BookmarkIngredient.fromJson(Map<String, dynamic> json) {
    return BookmarkIngredient(
      name: json['name']?.toString() ?? '',
      quantity: _parseNum(json['quantity'], 1),
      unit: json['unit']?.toString() ?? '',
    );
  }

  static num _parseNum(dynamic val, num fallback) {
    if (val is num) return val;
    return num.tryParse(val?.toString() ?? '') ?? fallback;
  }
}

class BookmarkSellerProfile {
  final String businessName;

  BookmarkSellerProfile({
    this.businessName = '',
  });

  factory BookmarkSellerProfile.fromJson(Map<String, dynamic> json) {
    return BookmarkSellerProfile(
      businessName: json['businessName']?.toString() ?? '',
    );
  }
}

class BookmarkSeller {
  final String id;
  final String name;
  final String profilePicture;
  final BookmarkSellerProfile? sellerProfile;

  BookmarkSeller({
    this.id = '',
    this.name = '',
    this.profilePicture = '',
    this.sellerProfile,
  });

  factory BookmarkSeller.fromJson(Map<String, dynamic> json) {
    return BookmarkSeller(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString() ?? '',
      sellerProfile: json['sellerProfile'] != null &&
              json['sellerProfile'] is Map<String, dynamic>
          ? BookmarkSellerProfile.fromJson(json['sellerProfile'])
          : null,
    );
  }
}

class BookmarkFoodItem {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final String category;
  final String subcategory;
  final double price;
  final String preparationTime;
  final List<BookmarkIngredient> ingredients;
  final bool pickupAvailable;
  final bool deliveryAvailable;
  final double deliveryFee;
  final String status;
  final String sellerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BookmarkSeller? seller;
  final double rating;

  BookmarkFoodItem({
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
    this.status = '',
    this.sellerId = '',
    this.createdAt,
    this.updatedAt,
    this.seller,
    this.rating = 4.8,
  });

  factory BookmarkFoodItem.fromJson(Map<String, dynamic> json) {
    List<String> imgList = [];
    if (json['images'] is List) {
      imgList = (json['images'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    List<BookmarkIngredient> ingList = [];
    if (json['ingredients'] is List) {
      ingList = (json['ingredients'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => BookmarkIngredient.fromJson(e))
          .toList();
    }

    final rawRating = json['rating'] ?? json['averageRating'];
    final parsedRating = rawRating is num
        ? rawRating.toDouble()
        : (double.tryParse(rawRating?.toString() ?? '') ?? 4.8);

    return BookmarkFoodItem(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
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
      status: json['status']?.toString() ?? '',
      sellerId: json['sellerId']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      seller: json['seller'] != null && json['seller'] is Map<String, dynamic>
          ? BookmarkSeller.fromJson(json['seller'])
          : null,
      rating: parsedRating > 0 ? parsedRating : 4.8,
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
    if (cat.isEmpty) {
      if (seller?.sellerProfile?.businessName.isNotEmpty == true) {
        return seller!.sellerProfile!.businessName;
      }
      return 'Food';
    }
    return '${cat[0]}${cat.substring(1).toLowerCase()}';
  }

  String get displaySubcategory {
    final sub = subcategory.toUpperCase().trim();
    if (sub.isEmpty) return '';
    return '${sub[0]}${sub.substring(1).toLowerCase()}';
  }

  String get displaySubtitle {
    if (displayCategory.isNotEmpty && displaySubcategory.isNotEmpty) {
      return '$displayCategory • $displaySubcategory';
    } else if (displayCategory.isNotEmpty) {
      return displayCategory;
    }
    return displaySubcategory;
  }

  String get displayTime {
    if (preparationTime.toLowerCase().contains('min')) {
      return preparationTime;
    }
    return '$preparationTime min';
  }
}
