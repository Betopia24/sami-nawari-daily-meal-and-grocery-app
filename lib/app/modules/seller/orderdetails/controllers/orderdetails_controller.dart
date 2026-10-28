import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/seller_order_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../orderlist/controllers/orderlist_controller.dart';

class OrderdetailsController extends GetxController {
  final status = 'New'.obs;
  final Rxn<SellerOrder> order = Rxn<SellerOrder>();
  final RxBool isUpdatingStatus = false.obs;

  final List<String> filters = [
    'All',
    'New',
    'Preparing',
    'Out for Delivery',
    'Delivered',
    'Completed'
  ];
  final selectedFilter = 'New'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['order'] is SellerOrder) {
        order.value = args['order'] as SellerOrder;
        if (order.value != null) {
          status.value = order.value!.displayStatus;
        }
      } else if (args['status'] != null) {
        status.value = args['status'].toString();
      }
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Maps incoming UI label or string to backend ENUM
  /// PENDING_PAYMENT ➔ CONFIRMED ➔ ACCEPTED ➔ PREPARING ➔ OUT_FOR_DELIVERY ➔ DELIVERED ➔ COMPLETED
  String mapToBackendStatus(String s) {
    final clean = s.toUpperCase().trim().replaceAll(' ', '_');
    switch (clean) {
      case 'PENDING_PAYMENT':
        return 'PENDING_PAYMENT';
      case 'CONFIRMED':
      case 'NEW':
        return 'CONFIRMED';
      case 'ACCEPTED':
        return 'ACCEPTED';
      case 'PREPARING':
        return 'PREPARING';
      case 'OUT_FOR_DELIVERY':
      case 'ON_THE_WAY':
        return 'OUT_FOR_DELIVERY';
      case 'DELIVERED':
        return 'DELIVERED';
      case 'COMPLETED':
        return 'COMPLETED';
      case 'DECLINED':
      case 'CANCELLED':
        return 'CANCELLED';
      default:
        return clean;
    }
  }

  /// Maps backend ENUM to friendly UI display text
  String mapToDisplayStatus(String s) {
    final clean = s.toUpperCase().trim().replaceAll(' ', '_');
    switch (clean) {
      case 'CONFIRMED':
      case 'NEW':
      case 'PENDING_PAYMENT':
        return 'New';
      case 'ACCEPTED':
        return 'Accepted';
      case 'PREPARING':
        return 'Preparing';
      case 'OUT_FOR_DELIVERY':
      case 'ON_THE_WAY':
        return 'Out for Delivery';
      case 'DELIVERED':
        return 'Delivered';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return s;
    }
  }

  /// PATCH /orders/seller/:order_id/status
  /// Body: { "status": "COMPLETED" }
  Future<bool> updateOrderStatus(String newStatus) async {
    final currentOrder = order.value;
    if (currentOrder == null || currentOrder.id.isEmpty) {
      Get.snackbar(
        'Error',
        'Order details not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return false;
    }

    final backendStatus = mapToBackendStatus(newStatus);
    isUpdatingStatus.value = true;

    try {
      final endpoint = Urls.getOrderStatusUpdateUrl(currentOrder.id);
      final body = {'status': backendStatus};

      final response = await NetworkCaller.patchRequest(
        endpoint,
        body: body,
      );

      if (response.isSuccess) {
        final display = mapToDisplayStatus(backendStatus);
        status.value = display;
        order.value = currentOrder.copyWith(status: backendStatus);

        // Refresh orders list in memory if registered
        if (Get.isRegistered<OrderlistController>()) {
          Get.find<OrderlistController>().fetchSellerOrders(showLoading: false);
        }

        Get.snackbar(
          'Status Updated',
          response.successMessage ?? 'Order status updated to $display',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B5E37),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return true;
      } else {
        Get.snackbar(
          'Update Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update order status',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update order status: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  void acceptOrder() {
    updateOrderStatus('ACCEPTED');
  }

  void declineOrder() {
    Get.defaultDialog(
      title: 'Decline Order',
      middleText: 'Are you sure you want to decline and cancel this order?',
      textConfirm: 'Decline',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back(); // close dialog
        final success = await updateOrderStatus('CANCELLED');
        if (success) {
          Get.back(); // return to orders list
        }
      },
    );
  }
}
