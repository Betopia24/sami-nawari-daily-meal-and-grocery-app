class SellerOrderResponseModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final SellerOrderData? data;

  SellerOrderResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory SellerOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return SellerOrderResponseModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SellerOrderData.fromJson(json['data'])
          : null,
    );
  }
}

class SellerOrderData {
  final SellerOrderMeta? meta;
  final List<SellerOrder> orders;

  SellerOrderData({
    this.meta,
    required this.orders,
  });

  factory SellerOrderData.fromJson(Map<String, dynamic> json) {
    final list = json['data'];
    List<SellerOrder> ordersList = [];
    if (list is List) {
      ordersList = list
          .whereType<Map<String, dynamic>>()
          .map((e) => SellerOrder.fromJson(e))
          .toList();
    }
    return SellerOrderData(
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? SellerOrderMeta.fromJson(json['meta'])
          : null,
      orders: ordersList,
    );
  }
}

class SellerOrderMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  SellerOrderMeta({
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.totalPage = 1,
  });

  factory SellerOrderMeta.fromJson(Map<String, dynamic> json) {
    return SellerOrderMeta(
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

class SellerDeliveryAddress {
  final String streetAddress;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  SellerDeliveryAddress({
    this.streetAddress = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
  });

  factory SellerDeliveryAddress.fromJson(Map<String, dynamic> json) {
    return SellerDeliveryAddress(
      streetAddress: json['streetAddress']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }

  String get fullAddress {
    final parts = [streetAddress, city, state, postalCode, country]
        .where((p) => p.trim().isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}

class SellerOrderItem {
  final String foodId;
  final String foodName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String sellerId;

  SellerOrderItem({
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.sellerId,
  });

  factory SellerOrderItem.fromJson(Map<String, dynamic> json) {
    return SellerOrderItem(
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

class SellerOrder {
  final String id;
  final String orderNumber;
  final String userId;
  final String recipientName;
  final String contactPhone;
  final String? note;
  final double subTotal;
  final double sellerSubTotal;
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
  final SellerDeliveryAddress? deliveryAddress;
  final List<SellerOrderItem> items;

  SellerOrder({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.recipientName,
    required this.contactPhone,
    this.note,
    this.subTotal = 0.0,
    this.sellerSubTotal = 0.0,
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
  });

  SellerOrder copyWith({
    String? id,
    String? orderNumber,
    String? userId,
    String? recipientName,
    String? contactPhone,
    String? note,
    double? subTotal,
    double? sellerSubTotal,
    double? deliveryFee,
    double? tax,
    double? discount,
    double? totalPrice,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    SellerDeliveryAddress? deliveryAddress,
    List<SellerOrderItem>? items,
  }) {
    return SellerOrder(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      userId: userId ?? this.userId,
      recipientName: recipientName ?? this.recipientName,
      contactPhone: contactPhone ?? this.contactPhone,
      note: note ?? this.note,
      subTotal: subTotal ?? this.subTotal,
      sellerSubTotal: sellerSubTotal ?? this.sellerSubTotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      items: items ?? this.items,
    );
  }

  factory SellerOrder.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    List<SellerOrderItem> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems
          .whereType<Map<String, dynamic>>()
          .map((e) => SellerOrderItem.fromJson(e))
          .toList();
    }

    final parsedSubTotal = _parseDouble(json['subTotal'], 0.0);

    return SellerOrder(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      recipientName: json['recipientName']?.toString() ?? 'Customer',
      contactPhone: json['contactPhone']?.toString() ?? '',
      note: json['note']?.toString(),
      subTotal: parsedSubTotal,
      sellerSubTotal: _parseDouble(json['sellerSubTotal'], parsedSubTotal),
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
          ? SellerDeliveryAddress.fromJson(json['deliveryAddress'])
          : null,
      items: parsedItems,
    );
  }

  static double _parseDouble(dynamic val, double fallback) {
    if (val is num) return val.toDouble();
    return double.tryParse(val?.toString() ?? '') ?? fallback;
  }

  // --- UI Helpers ---

  String get displayOrderNumber {
    if (orderNumber.startsWith('#')) return orderNumber;
    return '#$orderNumber';
  }

  String get displayStatus {
    final s = status.toUpperCase().trim();
    if (s == 'CONFIRMED' || s == 'PENDING' || s == 'NEW') {
      return 'New';
    } else if (s == 'PREPARING' || s == 'ACCEPTED') {
      return 'Preparing';
    } else if (s == 'OUT_FOR_DELIVERY' || s == 'ON_THE_WAY') {
      return 'Out for Delivery';
    } else if (s == 'DELIVERED') {
      return 'Delivered';
    } else if (s == 'COMPLETED') {
      return 'Completed';
    } else if (s == 'CANCELLED') {
      return 'Cancelled';
    }
    return s.split('_').map((w) => w.isNotEmpty ? '${w[0]}${w.substring(1).toLowerCase()}' : '').join(' ');
  }

  bool get isNew {
    final s = status.toUpperCase().trim();
    return s == 'CONFIRMED' || s == 'PENDING' || s == 'NEW';
  }

  String get itemsSummary {
    if (items.isEmpty) return 'No items';
    return items.map((i) => '${i.quantity}x ${i.foodName}').join(', ');
  }

  String get formattedDateTime {
    if (createdAt == null) return '';
    final local = createdAt!.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final orderDate = DateTime(local.year, local.month, local.day);

    final hour = local.hour > 12
        ? local.hour - 12
        : (local.hour == 0 ? 12 : local.hour);
    final minute = local.minute.toString().padLeft(2, '0');
    final ampm = local.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $ampm';

    final diffDays = today.difference(orderDate).inDays;
    if (diffDays == 0) {
      return 'Today, $timeStr';
    } else if (diffDays == 1) {
      return 'Yesterday, $timeStr';
    } else {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final monthName = months[local.month - 1];
      return '$monthName ${local.day}, $timeStr';
    }
  }

  String get deliveryType {
    if (deliveryAddress != null && deliveryAddress!.streetAddress.isNotEmpty) {
      return 'Delivery';
    }
    return 'Pickup';
  }

  String get formattedPaymentMethod {
    final m = paymentMethod.toUpperCase().trim();
    if (m == 'CASH_ON_DELIVERY') return 'Cash on Delivery';
    if (m == 'CASH_ON_PICKUP') return 'Cash on Pickup';
    if (m == 'ONLINE_PAYMENT' || m == 'ONLINE') return 'Online Payment';
    if (m == 'CARD') return 'Card';
    return m.split('_').map((w) => w.isNotEmpty ? '${w[0]}${w.substring(1).toLowerCase()}' : '').join(' ');
  }
}
