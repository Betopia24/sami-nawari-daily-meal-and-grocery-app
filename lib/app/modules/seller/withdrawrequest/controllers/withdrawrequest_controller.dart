import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';

class WithdrawrequestController extends GetxController {
  final currentStep = 1.obs; // 1: Amount, 2: Method, 3: Review
  final amountController = TextEditingController(text: '120');
  final selectedBankIndex = 0.obs;

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    } else {
      Get.toNamed(Routes.REQUESTSENT);
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  void selectBank(int index) {
    selectedBankIndex.value = index;
  }

  void addNewBankAccount() {
    Get.toNamed(Routes.ADDBANKACCOUNT);
  }
}
