import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../../../../routes/app_routes.dart';

class ForgotpasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> sendResetLink() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final email = emailController.text.trim();
    isLoading.value = true;

    try {
      final response = await NetworkCaller.postRequest(
        Urls.forgotPassword,
        body: {'email': email},
        requiresToken: false,
      );

      isLoading.value = false;

      if (response.isSuccess) {
        final data = response.responseData;
        final message = data is Map ? data['message']?.toString() : null;

        Get.snackbar(
          'Code Sent',
          message ?? 'Check your email for the reset password code!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );

        // Navigate to OTP screen for password reset
        Get.toNamed(
          Routes.otp,
          arguments: {
            'email': email,
            'isFromRegister': false,
          },
        );
      } else {
        Get.snackbar(
          'Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to send reset link. Please try again.',
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
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void goBackToSignIn() {
    Get.back();
  }
}
