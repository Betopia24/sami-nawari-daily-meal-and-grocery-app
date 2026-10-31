import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../../../../data/models/seller_earnings_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class EarningsController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final selectedMonth = 'This month'.obs;
  final List<String> months = [
    'This month',
    'Last month',
    'Last 3 months',
    'This year',
  ];

  final earningsData = Rxn<SellerEarningsData>();

  double get totalEarnings => earningsData.value?.totalEarnings ?? 0.0;
  double get earningsPercentage =>
      earningsData.value?.earningsGrowthPercentage ?? 0.0;

  int get completedOrders => earningsData.value?.completedOrders.count ?? 0;
  double get completedOrdersPercentage =>
      earningsData.value?.completedOrders.growthPercentage ?? 0.0;

  double get pendingEarnings =>
      earningsData.value?.pendingEarnings.amount ?? 0.0;
  int get pendingOrdersCount =>
      earningsData.value?.pendingEarnings.ordersCount ?? 0;

  double get availableBalance =>
      earningsData.value?.availableBalance.amount ?? 0.0;
  bool get readyForWithdraw =>
      earningsData.value?.availableBalance.readyForWithdraw ?? false;

  List<FlSpot> get chartData {
    final list = earningsData.value?.chartData;
    if (list == null || list.isEmpty) {
      return const [FlSpot(0, 0)];
    }
    return list.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.cumulativeEarnings);
    }).toList();
  }

  List<String> get bottomTitles {
    final list = earningsData.value?.chartData;
    if (list == null || list.isEmpty) {
      return const [''];
    }
    return list.map((e) => e.label).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchEarningsOverview();
  }

  String _mapPeriod(String periodLabel) {
    switch (periodLabel.toLowerCase()) {
      case 'last month':
        return 'last_month';
      case 'last 3 months':
        return 'last_3_months';
      case 'this year':
        return 'this_year';
      case 'this month':
      default:
        return 'this_month';
    }
  }

  Future<void> onMonthChanged(String? newMonth) async {
    if (newMonth != null && newMonth != selectedMonth.value) {
      selectedMonth.value = newMonth;
      await fetchEarningsOverview();
    }
  }

  Future<void> fetchEarningsOverview() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final period = _mapPeriod(selectedMonth.value);
      final response = await NetworkCaller.getRequest(
        Urls.earningOverview,
        queryParameters: {'period': period},
      );

      if (response.isSuccess && response.responseData != null) {
        if (response.responseData is Map<String, dynamic>) {
          final model = SellerEarningsResponseModel.fromJson(
            response.responseData as Map<String, dynamic>,
          );
          if (model.data != null) {
            earningsData.value = model.data;
          }
        }
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load earnings overview';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
