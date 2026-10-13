import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MycartsController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final totalItems = 4.obs;
  final totalSellers = 3.obs;
  final totalPrice = 77.0.obs;

  final List<RxInt> itemQuantities = [1.obs, 1.obs, 2.obs, 2.obs];
  final List<double> itemPrices = [18.0, 13.0, 7.0, 16.0];

  final currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    int initialIndex = 0;
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['mycarts_tab'] != null) {
      initialIndex = Get.arguments['mycarts_tab'];
    }
    tabController = TabController(length: 3, vsync: this, initialIndex: initialIndex);
    currentTabIndex.value = initialIndex;
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void _recalculateTotal() {
    double total = 0;
    int itemsCount = 0;
    for (int i = 0; i < itemQuantities.length; i++) {
      total += itemQuantities[i].value * itemPrices[i];
      itemsCount += itemQuantities[i].value;
    }
    // Also include delivery fees: $2.50 * 3 sellers = 7.50? Wait, the initial total was 77.
    // Let's re-add the fixed delivery fees for the sellers.
    // Luca's delivery is 2.50, Maria's is 2.50, Priya's is 2.50. Wait, initial logic:
    // Maria: 18 * 1 = 18. Luca: 13*1 + 7*2 = 27. Priya: 16*2 = 32. Total = 77. Delivery isn't included in that 77? 18+27+32 = 77. Correct.
    totalPrice.value = total;
    totalItems.value = itemsCount;
  }

  void incrementItem(int index) {
    itemQuantities[index].value++;
    _recalculateTotal();
  }

  void decrementItem(int index) {
    if (itemQuantities[index].value > 1) {
      itemQuantities[index].value--;
      _recalculateTotal();
    }
  }

  void deleteItem(int index) {
    // For now just set quantity to 0
    if (itemQuantities[index].value > 0) {
      itemQuantities[index].value = 0;
      _recalculateTotal();
    }
  }

  void bookmarkItem(int index) {
    // Mock functionality
  }

  void checkout() {
    Get.toNamed('/revieworder');
  }

  // Active Orders (Tracking & Review) State and Methods
  final selectedRating = 0.obs;

  void setRating(int rating) {
    selectedRating.value = rating;
  }

  void onRefreshStatus() {
    Get.snackbar(
      'Status Refreshed',
      'The order status is up to date.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onCancelOrder() {
    Get.defaultDialog(
      title: 'Cancel Order',
      middleText: 'Are you sure you want to cancel this order?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'Order Cancelled',
          'Your order has been cancelled successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void onContactSeller() {
    Get.snackbar(
      'Contacting Seller',
      'Opening chat with Maria\'s Kitchen...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onSubmitReview() {
    if (selectedRating.value == 0) {
      Get.snackbar(
        'Error',
        'Please select a rating before submitting.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.snackbar(
      'Review Submitted',
      'Thank you for your feedback!',
      snackPosition: SnackPosition.BOTTOM,
    );
    selectedRating.value = 0; // Reset
  }
}
