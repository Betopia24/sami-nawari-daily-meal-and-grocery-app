import 'package:get/get.dart';

import '../../../../data/models/seller_earning_history_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class EarninghistoryController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final selectedFilter = 'All'.obs;
  final selectedMonth = 'This month'.obs;

  final List<String> filters = ['All', 'Orders'];
  final List<String> months = [
    'This month',
    'Last month',
    'Last 3 months',
    'This year',
  ];

  final historyData = Rxn<SellerEarningHistoryData>();
  final transactions = <EarningTransactionModel>[].obs;
  final groupedByMonth = <String, List<EarningTransactionModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (!filters.contains(selectedFilter.value)) {
      selectedFilter.value = 'All';
    }
    fetchEarningsHistory();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
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
      await fetchEarningsHistory();
    }
  }

  Future<void> fetchEarningsHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final period = _mapPeriod(selectedMonth.value);
      final response = await NetworkCaller.getRequest(
        Urls.earningHistory,
        queryParameters: {
          'period': period,
          'page': 1,
          'limit': 50,
        },
      );

      if (response.isSuccess && response.responseData != null) {
        if (response.responseData is Map<String, dynamic>) {
          final model = SellerEarningHistoryResponseModel.fromJson(
            response.responseData as Map<String, dynamic>,
          );

          if (model.data != null) {
            historyData.value = model.data;
            transactions.assignAll(model.data!.transactions);
            groupedByMonth.assignAll(model.data!.groupedByMonth);
          }
        }
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load earnings history';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter transactions according to selectedFilter ('All', 'Orders')
  Map<String, List<EarningTransactionModel>> getFilteredGroupedTransactions() {
    if (!filters.contains(selectedFilter.value)) {
      selectedFilter.value = 'All';
    }

    final Map<String, List<EarningTransactionModel>> result = {};

    if (groupedByMonth.isNotEmpty) {
      groupedByMonth.forEach((month, list) {
        final filteredList = _filterList(list);
        if (filteredList.isNotEmpty) {
          result[month] = filteredList;
        }
      });
      return result;
    }

    // Fallback: if groupedByMonth is empty but transactions has items
    final filtered = _filterList(transactions);
    if (filtered.isNotEmpty) {
      for (final tx in filtered) {
        final groupKey = tx.monthGroup.isNotEmpty ? tx.monthGroup : 'Recent';
        result.putIfAbsent(groupKey, () => []).add(tx);
      }
    }

    return result;
  }

  List<EarningTransactionModel> _filterList(List<EarningTransactionModel> list) {
    if (selectedFilter.value == 'Orders') {
      return list.where((t) => t.isPositive).toList();
    }
    return list;
  }
}
