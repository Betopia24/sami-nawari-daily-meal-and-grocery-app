class CartItemModel {
  final String foodId;
  final String name;
  final double price;
  final int quantity;
  final String image;
  final String category;
  final bool pickupAvailable;
  final bool deliveryAvailable;
  final double deliveryFee;
  final double subTotal;
  final String sellerId;
  final String sellerName;
  final String sellerAuthor;
  final String prepTime;
  final bool isBookmarked;

  CartItemModel({
    required this.foodId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.image = '',
    this.category = 'Lunch',
    this.pickupAvailable = true,
    this.deliveryAvailable = true,
    this.deliveryFee = 2.50,
    this.subTotal = 0.0,
    this.sellerId = 'seller_1',
    this.sellerName = "Maria's Kitchen",
    this.sellerAuthor = "Maria Santos",
    this.prepTime = "25 min",
    this.isBookmarked = false,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final priceVal = json['price'] ?? json['unitPrice'];
    final double parsedPrice = (priceVal is num)
        ? priceVal.toDouble()
        : double.tryParse(priceVal?.toString() ?? '0') ?? 0.0;

    final subVal = json['subTotal'] ?? json['subtotal'];
    final double parsedSubTotal = (subVal is num)
        ? subVal.toDouble()
        : double.tryParse(subVal?.toString() ?? '0') ?? 0.0;

    final feeVal = json['deliveryFee'];
    final double parsedFee = (feeVal is num)
        ? feeVal.toDouble()
        : double.tryParse(feeVal?.toString() ?? '2.50') ?? 2.50;

    final seller = json['seller'] is Map
        ? json['seller'] as Map<String, dynamic>
        : null;
    final sellerProfile =
        seller?['sellerProfile'] is Map ? seller!['sellerProfile'] as Map : null;

    final sName = json['sellerName']?.toString() ??
        sellerProfile?['businessName']?.toString() ??
        seller?['name']?.toString() ??
        "Maria's Kitchen";

    final sAuthor = seller?['name']?.toString() ??
        json['sellerAuthor']?.toString() ??
        "Maria Santos";

    final img = json['image']?.toString() ??
        (json['images'] is List && (json['images'] as List).isNotEmpty
            ? json['images'][0].toString()
            : '');

    final qty = (json['quantity'] is num)
        ? (json['quantity'] as num).toInt()
        : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1;

    return CartItemModel(
      foodId: json['foodId']?.toString() ?? json['id']?.toString() ?? '',
      name:
          json['name']?.toString() ?? json['foodName']?.toString() ?? 'Food Item',
      price: parsedPrice,
      quantity: qty,
      image: img,
      category: json['category']?.toString() ?? 'Lunch',
      pickupAvailable: json['pickupAvailable'] != false,
      deliveryAvailable: json['deliveryAvailable'] != false,
      deliveryFee: parsedFee,
      subTotal: parsedSubTotal > 0 ? parsedSubTotal : (parsedPrice * qty),
      sellerId:
          json['sellerId']?.toString() ?? seller?['id']?.toString() ?? sName,
      sellerName: sName,
      sellerAuthor: sAuthor,
      prepTime: json['preparationTime']?.toString() ?? '20 min',
      isBookmarked: json['isBookmarked'] == true,
    );
  }

  CartItemModel copyWith({
    int? quantity,
    double? subTotal,
    bool? isBookmarked,
  }) {
    return CartItemModel(
      foodId: foodId,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
      image: image,
      category: category,
      pickupAvailable: pickupAvailable,
      deliveryAvailable: deliveryAvailable,
      deliveryFee: deliveryFee,
      subTotal: subTotal ?? this.subTotal,
      sellerId: sellerId,
      sellerName: sellerName,
      sellerAuthor: sellerAuthor,
      prepTime: prepTime,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

class CartGroupModel {
  final String sellerId;
  final String sellerName;
  final String authorName;
  final String restaurantImage;
  final String prepTime;
  final bool hasPickup;
  final double deliveryFee;
  final List<CartItemModel> items;

  CartGroupModel({
    required this.sellerId,
    required this.sellerName,
    required this.authorName,
    required this.restaurantImage,
    required this.prepTime,
    required this.hasPickup,
    required this.deliveryFee,
    required this.items,
  });

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}
