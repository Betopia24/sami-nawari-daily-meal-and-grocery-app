import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class UpdatepasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void saveChanges() {
    // Logic to update password would go here
    Get.back();
    Get.snackbar(
      'Success',
      'Password updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
