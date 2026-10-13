import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class UpdatepasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
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

  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void saveChanges() {
    if (formKey.currentState?.validate() ?? false) {
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
}
