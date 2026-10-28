import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../data/models/seller_order_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class OrderlistController extends GetxController {
  final RxString selectedFilter = 'All'.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<SellerOrder> allOrders = <SellerOrder>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSellerOrders();
  }

  int get newCount => allOrders.where((o) => o.isNew).length;

  List<String> get filters {
    final count = newCount;
    final newLabel = count > 0 ? 'New ($count)' : 'New';
    return [
      'All',
      newLabel,
      'Preparing',
      'Out for Delivery',
      'Delivered',
      'Completed',
    ];
  }

  void setFilter(String filter) {
    if (filter.startsWith('New')) {
      selectedFilter.value = 'New';
    } else {
      selectedFilter.value = filter;
    }
  }

  bool isFilterSelected(String filter) {
    if (selectedFilter.value == filter) return true;
    if (selectedFilter.value.startsWith('New') && filter.startsWith('New')) {
      return true;
    }
    return false;
  }

  List<SellerOrder> get filteredOrders {
    final filter = selectedFilter.value;
    if (filter == 'All') return allOrders;
    final f = filter.toLowerCase();

    if (f.startsWith('new')) {
      return allOrders.where((o) => o.isNew).toList();
    }
    if (f.startsWith('preparing')) {
      return allOrders.where((o) {
        final s = o.status.toUpperCase();
        return s == 'PREPARING' || s == 'ACCEPTED';
      }).toList();
    }
    if (f.startsWith('out for delivery')) {
      return allOrders.where((o) {
        final s = o.status.toUpperCase();
        return s == 'OUT_FOR_DELIVERY' || s == 'ON_THE_WAY';
      }).toList();
    }
    if (f.startsWith('delivered')) {
      return allOrders.where((o) {
        final s = o.status.toUpperCase();
        return s == 'DELIVERED';
      }).toList();
    }
    if (f.startsWith('completed')) {
      return allOrders.where((o) {
        final s = o.status.toUpperCase();
        return s == 'COMPLETED';
      }).toList();
    }
    return allOrders.where((o) => o.displayStatus.toLowerCase() == f).toList();
  }

  Future<void> fetchSellerOrders({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await NetworkCaller.getRequest(Urls.sellerOrderList);

      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData = body is Map ? (body['data'] ?? body) : body;

        List<dynamic>? ordersList;
        if (rawData is Map && rawData['data'] is List) {
          ordersList = rawData['data'] as List;
        } else if (rawData is List) {
          ordersList = rawData;
        } else if (body is List) {
          ordersList = body;
        }

        if (ordersList != null) {
          final List<SellerOrder> loaded = ordersList
              .whereType<Map<String, dynamic>>()
              .map((json) => SellerOrder.fromJson(json))
              .toList();
          allOrders.assignAll(loaded);
        } else {
          allOrders.clear();
        }
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load seller orders';
      }
    } catch (e) {
      debugPrint('Error fetching seller orders: $e');
      errorMessage.value = 'Failed to load seller orders. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}

