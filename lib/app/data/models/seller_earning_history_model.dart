class SellerEarningHistoryResponseModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final SellerEarningHistoryData? data;

  SellerEarningHistoryResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory SellerEarningHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return SellerEarningHistoryResponseModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SellerEarningHistoryData.fromJson(json['data'])
          : null,
    );
  }
}

class SellerEarningHistoryData {
  final SellerEarningHistoryMeta? meta;
  final List<EarningTransactionModel> transactions;
  final Map<String, List<EarningTransactionModel>> groupedByMonth;

  SellerEarningHistoryData({
    this.meta,
    required this.transactions,
    required this.groupedByMonth,
  });

  factory SellerEarningHistoryData.fromJson(Map<String, dynamic> json) {
    // Parse transactions list
    final txList = json['transactions'];
    List<EarningTransactionModel> parsedTx = [];
    if (txList is List) {
      parsedTx = txList
          .whereType<Map<String, dynamic>>()
          .map((e) => EarningTransactionModel.fromJson(e))
          .toList();
    }

    // Parse groupedByMonth map
    final groupedMap = json['groupedByMonth'];
    Map<String, List<EarningTransactionModel>> parsedGrouped = {};
    if (groupedMap is Map) {
      groupedMap.forEach((key, value) {
        if (value is List) {
          parsedGrouped[key.toString()] = value
              .whereType<Map<String, dynamic>>()
              .map((e) => EarningTransactionModel.fromJson(e))
              .toList();
        }
      });
    }

    return SellerEarningHistoryData(
      meta: json['meta'] is Map<String, dynamic>
          ? SellerEarningHistoryMeta.fromJson(json['meta'])
          : null,
      transactions: parsedTx,
      groupedByMonth: parsedGrouped,
    );
  }
}

class SellerEarningHistoryMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  SellerEarningHistoryMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory SellerEarningHistoryMeta.fromJson(Map<String, dynamic> json) {
    return SellerEarningHistoryMeta(
      page: json['page'] is int
          ? json['page']
          : int.tryParse(json['page']?.toString() ?? '1') ?? 1,
      limit: json['limit'] is int
          ? json['limit']
          : int.tryParse(json['limit']?.toString() ?? '20') ?? 20,
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      totalPage: json['totalPage'] is int
          ? json['totalPage']
          : int.tryParse(json['totalPage']?.toString() ?? '1') ?? 1,
    );
  }
}

class EarningTransactionModel {
  final String id;
  final String orderNumber;
  final String rawOrderNumber;
  final double amount;
  final String formattedAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String paymentLabel;
  final String status;
  final String monthGroup;
  final String createdAt;

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  EarningTransactionModel({
    required this.id,
    required this.orderNumber,
    required this.rawOrderNumber,
    required this.amount,
    required this.formattedAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentLabel,
    required this.status,
    required this.monthGroup,
    required this.createdAt,
  });

  factory EarningTransactionModel.fromJson(Map<String, dynamic> json) {
    return EarningTransactionModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      rawOrderNumber: json['rawOrderNumber']?.toString() ?? '',
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      formattedAmount: json['formattedAmount']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      paymentLabel: json['paymentLabel']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      monthGroup: json['monthGroup']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  bool get isPositive => !formattedAmount.contains('-');

  String get displayDate {
    if (createdAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      final monthStr = _monthNames[dt.month - 1];
      return '$monthStr ${dt.day}';
    } catch (_) {
      return createdAt;
    }
  }

  String get displayTime {
    if (createdAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final hourStr = hour.toString().padLeft(2, '0');
      return '$hourStr:$minute $period';
    } catch (_) {
      return '';
    }
  }
}
