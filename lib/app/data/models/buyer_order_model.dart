class BuyerOrderResponseModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final BuyerOrderData? data;

  BuyerOrderResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory BuyerOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return BuyerOrderResponseModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? BuyerOrderData.fromJson(json['data'])
          : null,
    );
  }
}

class BuyerOrderData {
  final BuyerOrderMeta? meta;
  final List<BuyerOrder> orders;

  BuyerOrderData({
    this.meta,
    required this.orders,
  });

  factory BuyerOrderData.fromJson(Map<String, dynamic> json) {
    final list = json['data'];
    List<BuyerOrder> ordersList = [];
    if (list is List) {
      ordersList = list
          .whereType<Map<String, dynamic>>()
          .map((e) => BuyerOrder.fromJson(e))
          .toList();
    }
    return BuyerOrderData(
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? BuyerOrderMeta.fromJson(json['meta'])
          : null,
      orders: ordersList,
    );
  }
}

class BuyerOrderMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  BuyerOrderMeta({
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.totalPage = 1,
  });

  factory BuyerOrderMeta.fromJson(Map<String, dynamic> json) {
    return BuyerOrderMeta(
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

class BuyerDeliveryAddress {
  final String streetAddress;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  BuyerDeliveryAddress({
    this.streetAddress = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
  });

  factory BuyerDeliveryAddress.fromJson(Map<String, dynamic> json) {
    return BuyerDeliveryAddress(
      streetAddress: json['streetAddress']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }

  String get formattedAddress {
    final parts = [streetAddress, city, state, postalCode]
        .where((e) => e.isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}

class BuyerOrderFoodItem {
  final String foodId;
  final String foodName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String sellerId;

  BuyerOrderFoodItem({
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.sellerId,
  });

  factory BuyerOrderFoodItem.fromJson(Map<String, dynamic> json) {
    return BuyerOrderFoodItem(
      foodId: json['foodId']?.toString() ?? '',
      foodName: json['foodName']?.toString() ?? 'Food Item',
      quantity: _parseInt(json['quantity'], 1),
      unitPrice: _parseDouble(json['unitPrice'], 0.0),
      subtotal: _parseDouble(json['subtotal'], 0.0),
      sellerId: json['sellerId']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic val, int fallback) {
    if (val is int) return val;
    return int.tryParse(val?.toString() ?? '') ?? fallback;
  }

  static double _parseDouble(dynamic val, double fallback) {
    if (val is num) return val.toDouble();
    return double.tryParse(val?.toString() ?? '') ?? fallback;
  }
}

class BuyerOrder {
  final String id;
  final String orderNumber;
  final String userId;
  final String recipientName;
  final String contactPhone;
  final String? note;
  final double subTotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double totalPrice;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String? parentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BuyerDeliveryAddress? deliveryAddress;
  final List<BuyerOrderFoodItem> items;
  final List<BuyerOrder> childOrders;

  BuyerOrder({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.recipientName,
    required this.contactPhone,
    this.note,
    this.subTotal = 0.0,
    this.deliveryFee = 0.0,
    this.tax = 0.0,
    this.discount = 0.0,
    this.totalPrice = 0.0,
    this.status = 'CONFIRMED',
    this.paymentStatus = 'UNPAID',
    this.paymentMethod = 'CASH_ON_DELIVERY',
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.deliveryAddress,
    required this.items,
    this.childOrders = const [],
  });

  factory BuyerOrder.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    List<BuyerOrderFoodItem> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems
          .whereType<Map<String, dynamic>>()
          .map((e) => BuyerOrderFoodItem.fromJson(e))
          .toList();
    }

    final rawChildOrders = json['childOrders'];
    List<BuyerOrder> parsedChildOrders = [];
    if (rawChildOrders is List) {
      parsedChildOrders = rawChildOrders
          .whereType<Map<String, dynamic>>()
          .map((e) => BuyerOrder.fromJson(e))
          .toList();
    }

    return BuyerOrder(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      recipientName: json['recipientName']?.toString() ?? 'Customer',
      contactPhone: json['contactPhone']?.toString() ?? '',
      note: json['note']?.toString(),
      subTotal: _parseDouble(json['subTotal'], 0.0),
      deliveryFee: _parseDouble(json['deliveryFee'], 0.0),
      tax: _parseDouble(json['tax'], 0.0),
      discount: _parseDouble(json['discount'], 0.0),
      totalPrice: _parseDouble(json['totalPrice'], 0.0),
      status: json['status']?.toString() ?? 'CONFIRMED',
      paymentStatus: json['paymentStatus']?.toString() ?? 'UNPAID',
      paymentMethod: json['paymentMethod']?.toString() ?? 'CASH_ON_DELIVERY',
      parentId: json['parentId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      deliveryAddress: json['deliveryAddress'] != null &&
              json['deliveryAddress'] is Map<String, dynamic>
          ? BuyerDeliveryAddress.fromJson(json['deliveryAddress'])
          : null,
      items: parsedItems,
      childOrders: parsedChildOrders,
    );
  }

  static double _parseDouble(dynamic val, double fallback) {
    if (val is num) return val.toDouble();
    return double.tryParse(val?.toString() ?? '') ?? fallback;
  }

  // --- Display & Logic Getters ---

  String get displayTitle {
    if (items.isNotEmpty) {
      if (items.length == 1) {
        return items.first.foodName;
      } else {
        return '${items.first.foodName} + ${items.length - 1} more';
      }
    }
    return orderNumber.isNotEmpty ? '#$orderNumber' : 'Order';
  }

  String get displayRestaurantName {
    if (childOrders.isNotEmpty && childOrders.first.items.isNotEmpty) {
      return 'Kitchen Order (${childOrders.length} ${childOrders.length == 1 ? 'kitchen' : 'kitchens'})';
    }
    return 'Home Kitchen';
  }

  String get timeAgo {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);

    if (diff.inDays > 365) {
      final years = (diff.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
    if (diff.inDays > 30) {
      final months = (diff.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
    if (diff.inDays >= 7) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }
    if (diff.inDays > 0) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
    }
    if (diff.inMinutes > 0) {
      return '${diff.inMinutes} min ago';
    }
    return 'Just now';
  }

  bool get isDelivery => deliveryFee > 0 || deliveryAddress != null;

  bool get isActive {
    final s = status.toUpperCase();
    return s == 'CONFIRMED' ||
        s == 'ACCEPTED' ||
        s == 'PREPARING' ||
        s == 'OUT_FOR_DELIVERY' ||
        s == 'PENDING' ||
        s == 'PENDING_PAYMENT';
  }

  bool get isCompleted {
    final s = status.toUpperCase();
    return s == 'DELIVERED' || s == 'COMPLETED' || s == 'PICKED_UP';
  }

  bool get isCancelled {
    final s = status.toUpperCase();
    return s == 'CANCELLED' || s == 'REJECTED';
  }

  String get formattedStatus {
    switch (status.toUpperCase()) {
      case 'PENDING_PAYMENT':
        return 'Pending Payment';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'ACCEPTED':
        return 'Accepted';
      case 'PREPARING':
        return 'Preparing';
      case 'OUT_FOR_DELIVERY':
        return 'Out for Delivery';
      case 'DELIVERED':
        return 'Delivered';
      case 'PICKED_UP':
        return 'Picked Up';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }
}
