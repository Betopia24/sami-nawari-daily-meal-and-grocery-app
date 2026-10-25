import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../widgets/success_screen.dart';

class ResetpasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _isNewPasswordVisible = false.obs;
  bool get isNewPasswordVisible => _isNewPasswordVisible.value;

  final _isConfirmPasswordVisible = false.obs;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible.value;

  final isLoading = false.obs;

  String email = '';
  String resetToken = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      email = args['email']?.toString() ?? 'us***@gmail.com';
      resetToken = args['resetToken']?.toString() ?? '';
    } else if (args is String) {
      email = args;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible.value = !_isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible.value = !_isConfirmPasswordVisible.value;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> resetPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    final newPassword = newPasswordController.text;

    try {
      final response = await NetworkCaller.postRequest(
        Urls.resetPassword,
        body: {'password': newPassword},
        options: Options(
          headers: resetToken.isNotEmpty ? {'Authorization': resetToken} : null,
        ),
        queryParameters: resetToken.isNotEmpty ? {'token': resetToken} : null,
        requiresToken: false,
      );

      isLoading.value = false;

      if (response.isSuccess) {
        Get.offAll(
          () => SuccessScreen(
            title: 'Password reset!',
            subtitle:
                'Your password has been updated successfully.\nSign in with your new password.',
            buttonText: 'Sign In Now',
            onButtonPressed: () => Get.offAllNamed(Routes.signin),
          ),
        );
      } else {
        Get.snackbar(
          'Reset Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to reset password. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void goBack() {
    Get.offAllNamed(Routes.forgotpassword);
  }
}
