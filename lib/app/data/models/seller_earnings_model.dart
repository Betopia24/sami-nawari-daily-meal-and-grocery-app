class SellerEarningsResponseModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final SellerEarningsData? data;

  SellerEarningsResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory SellerEarningsResponseModel.fromJson(Map<String, dynamic> json) {
    return SellerEarningsResponseModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SellerEarningsData.fromJson(json['data'])
          : null,
    );
  }
}

class SellerEarningsData {
  final String? period;
  final double totalEarnings;
  final double earningsGrowthPercentage;
  final CompletedOrdersModel completedOrders;
  final PendingEarningsModel pendingEarnings;
  final AvailableBalanceModel availableBalance;
  final List<ChartDataItem> chartData;

  SellerEarningsData({
    this.period,
    required this.totalEarnings,
    required this.earningsGrowthPercentage,
    required this.completedOrders,
    required this.pendingEarnings,
    required this.availableBalance,
    required this.chartData,
  });

  factory SellerEarningsData.fromJson(Map<String, dynamic> json) {
    final chartList = json['chartData'];
    List<ChartDataItem> parsedChartData = [];
    if (chartList is List) {
      parsedChartData = chartList
          .whereType<Map<String, dynamic>>()
          .map((e) => ChartDataItem.fromJson(e))
          .toList();
    }

    return SellerEarningsData(
      period: json['period']?.toString(),
      totalEarnings: _toDouble(json['totalEarnings']),
      earningsGrowthPercentage: _toDouble(json['earningsGrowthPercentage']),
      completedOrders: json['completedOrders'] is Map<String, dynamic>
          ? CompletedOrdersModel.fromJson(json['completedOrders'])
          : CompletedOrdersModel.empty(),
      pendingEarnings: json['pendingEarnings'] is Map<String, dynamic>
          ? PendingEarningsModel.fromJson(json['pendingEarnings'])
          : PendingEarningsModel.empty(),
      availableBalance: json['availableBalance'] is Map<String, dynamic>
          ? AvailableBalanceModel.fromJson(json['availableBalance'])
          : AvailableBalanceModel.empty(),
      chartData: parsedChartData,
    );
  }

  static double _toDouble(dynamic val) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }
}

class CompletedOrdersModel {
  final int count;
  final double growthPercentage;

  CompletedOrdersModel({
    required this.count,
    required this.growthPercentage,
  });

  factory CompletedOrdersModel.fromJson(Map<String, dynamic> json) {
    return CompletedOrdersModel(
      count: json['count'] is int
          ? json['count']
          : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      growthPercentage: (json['growthPercentage'] is num)
          ? (json['growthPercentage'] as num).toDouble()
          : double.tryParse(json['growthPercentage']?.toString() ?? '0') ?? 0.0,
    );
  }

  factory CompletedOrdersModel.empty() {
    return CompletedOrdersModel(count: 0, growthPercentage: 0.0);
  }
}

class PendingEarningsModel {
  final double amount;
  final int ordersCount;
  final double stripePendingBalance;

  PendingEarningsModel({
    required this.amount,
    required this.ordersCount,
    required this.stripePendingBalance,
  });

  factory PendingEarningsModel.fromJson(Map<String, dynamic> json) {
    return PendingEarningsModel(
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      ordersCount: json['ordersCount'] is int
          ? json['ordersCount']
          : int.tryParse(json['ordersCount']?.toString() ?? '0') ?? 0,
      stripePendingBalance: (json['stripePendingBalance'] is num)
          ? (json['stripePendingBalance'] as num).toDouble()
          : double.tryParse(json['stripePendingBalance']?.toString() ?? '0') ??
              0.0,
    );
  }

  factory PendingEarningsModel.empty() {
    return PendingEarningsModel(
      amount: 0.0,
      ordersCount: 0,
      stripePendingBalance: 0.0,
    );
  }
}

class AvailableBalanceModel {
  final double amount;
  final bool readyForWithdraw;

  AvailableBalanceModel({
    required this.amount,
    required this.readyForWithdraw,
  });

  factory AvailableBalanceModel.fromJson(Map<String, dynamic> json) {
    return AvailableBalanceModel(
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      readyForWithdraw: json['readyForWithdraw'] is bool
          ? json['readyForWithdraw']
          : (json['readyForWithdraw']?.toString().toLowerCase() == 'true'),
    );
  }

  factory AvailableBalanceModel.empty() {
    return AvailableBalanceModel(amount: 0.0, readyForWithdraw: false);
  }
}

class ChartDataItem {
  final String label;
  final String date;
  final double earnings;
  final double cumulativeEarnings;

  ChartDataItem({
    required this.label,
    required this.date,
    required this.earnings,
    required this.cumulativeEarnings,
  });

  factory ChartDataItem.fromJson(Map<String, dynamic> json) {
    return ChartDataItem(
      label: json['label']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      earnings: (json['earnings'] is num)
          ? (json['earnings'] as num).toDouble()
          : double.tryParse(json['earnings']?.toString() ?? '0') ?? 0.0,
      cumulativeEarnings: (json['cumulativeEarnings'] is num)
          ? (json['cumulativeEarnings'] as num).toDouble()
          : double.tryParse(json['cumulativeEarnings']?.toString() ?? '0') ??
              0.0,
    );
  }
}
