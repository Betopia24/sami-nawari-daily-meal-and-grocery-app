import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FooddetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final RxInt quantity = 1.obs;

  final double basePrice = 18.00;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  String get totalPrice =>
      '\$${(basePrice * quantity.value).toStringAsFixed(2)}';
}
