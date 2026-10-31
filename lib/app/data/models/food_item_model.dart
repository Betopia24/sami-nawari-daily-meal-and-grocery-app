/// Model representing a food item from the backend /foods API
class FoodItemModel {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final String category;
  final String subcategory;
  final double price;
  final String preparationTime;
  final bool pickupAvailable;
  final bool deliveryAvailable;
  final double deliveryFee;
  final String status;
  final String sellerId;
  final String sellerName;
  final String sellerProfilePicture;
  final String sellerBusinessName;
  final String sellerAddress;
  final String rating;
  final String calories;

  FoodItemModel({
    required this.id,
    required this.name,
    this.description = '',
    this.images = const [],
    this.category = '',
    this.subcategory = '',
    this.price = 0.0,
    this.preparationTime = '',
    this.pickupAvailable = false,
    this.deliveryAvailable = false,
    this.deliveryFee = 0.0,
    this.status = '',
    this.sellerId = '',
    this.sellerName = '',
    this.sellerProfilePicture = '',
    this.sellerBusinessName = '',
    this.sellerAddress = '',
    this.rating = '4.8',
    this.calories = '320 kcal',
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    List<String> imgList = [];
    if (json['images'] is List) {
      imgList = (json['images'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final seller = json['seller'] is Map ? json['seller'] as Map<String, dynamic> : null;
    final sellerProfile = seller?['sellerProfile'] is Map
        ? seller!['sellerProfile'] as Map<String, dynamic>
        : null;

    final priceVal = json['price'];
    final double parsedPrice = (priceVal is num)
        ? priceVal.toDouble()
        : double.tryParse(priceVal?.toString() ?? '0') ?? 0.0;

    final feeVal = json['deliveryFee'];
    final double parsedFee = (feeVal is num)
        ? feeVal.toDouble()
        : double.tryParse(feeVal?.toString() ?? '0') ?? 0.0;

    return FoodItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      images: imgList,
      category: json['category']?.toString() ?? '',
      subcategory: json['subcategory']?.toString() ?? '',
      price: parsedPrice,
      preparationTime: json['preparationTime']?.toString() ?? '20m',
      pickupAvailable: json['pickupAvailable'] == true,
      deliveryAvailable: json['deliveryAvailable'] == true,
      deliveryFee: parsedFee,
      status: json['status']?.toString() ?? '',
      sellerId: json['sellerId']?.toString() ?? '',
      sellerName: seller?['name']?.toString() ?? '',
      sellerProfilePicture: seller?['profilePicture']?.toString() ?? '',
      sellerBusinessName: sellerProfile?['businessName']?.toString() ?? '',
      sellerAddress: sellerProfile?['address']?.toString() ?? '',
      rating: json['rating']?.toString() ?? '4.8',
      calories: json['calories']?.toString() ?? '',
    );
  }

  String get firstImage => images.isNotEmpty ? images.first : '';
  String get displaySeller => sellerBusinessName.isNotEmpty ? sellerBusinessName : sellerName;
}
