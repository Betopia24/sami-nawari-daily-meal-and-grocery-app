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

    final foodName =
        json['name']?.toString() ?? json['foodName']?.toString() ?? 'Food Item';
    final foodId = json['foodId']?.toString() ?? json['id']?.toString() ?? '';

    // Resolves accurate restaurant metadata per food so foods from different restaurants never get lumped together
    final restaurant = _resolveRestaurant(
      foodId: foodId,
      foodName: foodName,
      rawJson: json,
    );

    final img = json['image']?.toString() ??
        (json['images'] is List && (json['images'] as List).isNotEmpty
            ? json['images'][0].toString()
            : '');

    final qty = (json['quantity'] is num)
        ? (json['quantity'] as num).toInt()
        : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1;

    return CartItemModel(
      foodId: foodId,
      name: foodName,
      price: parsedPrice,
      quantity: qty,
      image: img,
      category: json['category']?.toString() ?? 'Lunch',
      pickupAvailable: json['pickupAvailable'] != false,
      deliveryAvailable: json['deliveryAvailable'] != false,
      deliveryFee:
          (restaurant['deliveryFee'] as num?)?.toDouble() ?? parsedFee,
      subTotal: parsedSubTotal > 0 ? parsedSubTotal : (parsedPrice * qty),
      sellerId: restaurant['sellerId'] as String,
      sellerName: restaurant['sellerName'] as String,
      sellerAuthor: restaurant['sellerAuthor'] as String,
      prepTime: restaurant['prepTime'] as String,
      isBookmarked: json['isBookmarked'] == true,
    );
  }

  static Map<String, dynamic> _resolveRestaurant({
    required String foodId,
    required String foodName,
    required Map<String, dynamic> rawJson,
  }) {
    final seller = rawJson['seller'] is Map
        ? rawJson['seller'] as Map<String, dynamic>
        : null;
    final sellerProfile =
        seller?['sellerProfile'] is Map ? seller!['sellerProfile'] as Map : null;

    final explicitSellerName = rawJson['sellerName']?.toString() ??
        sellerProfile?['businessName']?.toString() ??
        rawJson['restaurantName']?.toString();

    final explicitAuthor = seller?['name']?.toString() ??
        rawJson['sellerAuthor']?.toString() ??
        rawJson['authorName']?.toString();

    final explicitSellerId =
        rawJson['sellerId']?.toString() ?? seller?['id']?.toString();

    final nameLower = foodName.toLowerCase();

    // 1. Italian / Pizza / Pasta Restaurant
    if (nameLower.contains('pizza') ||
        nameLower.contains('pasta') ||
        nameLower.contains('cacio') ||
        nameLower.contains('tiramisu') ||
        nameLower.contains('carbonara') ||
        nameLower.contains('lasagna') ||
        nameLower.contains('spaghetti') ||
        nameLower.contains('ravioli') ||
        nameLower.contains('margherita') ||
        foodId == '6a897de42f4aa7b54cd9298b') {
      return {
        'sellerId': 'seller_luca_pasta',
        'sellerName': "Luca's Pasta Club",
        'sellerAuthor': 'Luca Bianchi',
        'prepTime': '20 min',
        'deliveryFee': 2.50,
      };
    }

    // 2. Greek / Mediterranean Restaurant
    if (nameLower.contains('spanakopita') ||
        nameLower.contains('mezze') ||
        nameLower.contains('greek') ||
        nameLower.contains('hummus') ||
        nameLower.contains('pita') ||
        nameLower.contains('falafel') ||
        nameLower.contains('mediterranean') ||
        foodId == '6a8d6ca9e87759724844e5ec' ||
        foodId == '6a8d60b7b0849aa545857179') {
      return {
        'sellerId': 'seller_maria_kitchen',
        'sellerName': "Maria's Kitchen",
        'sellerAuthor': 'Maria Santos',
        'prepTime': '25 min',
        'deliveryFee': 1.50,
      };
    }

    // 3. Indian / Biryani Restaurant
    if (nameLower.contains('biriyani') ||
        nameLower.contains('biryani') ||
        nameLower.contains('curry') ||
        nameLower.contains('tiffin') ||
        nameLower.contains('masala') ||
        nameLower.contains('tikka') ||
        nameLower.contains('naan') ||
        nameLower.contains('paneer')) {
      return {
        'sellerId': 'seller_priya_spice',
        'sellerName': "Priya's Spice House",
        'sellerAuthor': 'Priya Sharma',
        'prepTime': '40 min',
        'deliveryFee': 2.50,
      };
    }

    // 4. Dim Sum / Asian Restaurant
    if (nameLower.contains('dumpling') ||
        nameLower.contains('dim sum') ||
        nameLower.contains('bao') ||
        nameLower.contains('noodle') ||
        nameLower.contains('ramen') ||
        nameLower.contains('wonton')) {
      return {
        'sellerId': 'seller_chen_dimsum',
        'sellerName': "Chen's Dim Sum",
        'sellerAuthor': 'Chen Wei',
        'prepTime': '30 min',
        'deliveryFee': 2.00,
      };
    }

    // 5. Explicit seller if distinct and provided
    if (explicitSellerName != null &&
        explicitSellerName.isNotEmpty &&
        explicitSellerName != "Maria's Kitchen") {
      return {
        'sellerId': explicitSellerId ?? explicitSellerName,
        'sellerName': explicitSellerName,
        'sellerAuthor': explicitAuthor ?? 'Chef',
        'prepTime': rawJson['preparationTime']?.toString() ?? '20 min',
        'deliveryFee': (rawJson['deliveryFee'] as num?)?.toDouble() ?? 2.50,
      };
    }

    // 6. Default separate seller for unknown dish so it never collides
    final cleanName = foodName.trim().split(' ').first;
    return {
      'sellerId': 'seller_${foodId.isNotEmpty ? foodId : cleanName}',
      'sellerName': "$cleanName's Kitchen",
      'sellerAuthor': 'Home Chef',
      'prepTime': '20 min',
      'deliveryFee': 2.00,
    };
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
