import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewfoodController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final activeTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      activeTab.value = tabController.index;
    });
  }

  final isSubmitted = false.obs;

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void submit() {
    isSubmitted.value = true;
  }
}
