import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:daily_meal_and_grocery_app/app/data/network/local_storage.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../../../../routes/app_routes.dart';
import 'package:daily_meal_and_grocery_app/app/data/services/social_auth_service.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Please enter a valid name';
    }
    return null;
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

  String? validatePhone(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (!GetUtils.isPhoneNumber(value.trim())) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> signup() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;

    isLoading.value = true;

    final Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'password': password,
    };
    if (phone.isNotEmpty) {
      requestBody['phone'] = phone;
    }

    try {
      final response = await NetworkCaller.postRequest(
        Urls.register,
        body: requestBody,
        requiresToken: false,
      );

      isLoading.value = false;

      if (response.isSuccess) {
        final data = response.responseData;
        final userData = data is Map ? data['data'] : null;
        final registeredId = userData?['id']?.toString();

        if (registeredId != null && registeredId.isNotEmpty) {
          await LocalStorage.saveId(registeredId);
        }
        if (userData is Map<String, dynamic>) {
          await LocalStorage.saveUser(userData);
        }

        Get.snackbar(
          'Success',
          data?['message']?.toString() ??
              'User registered successfully! Please verify your email.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );

        // Navigate to OTP screen for email verification
        Get.toNamed(
          Routes.otp,
          arguments: {
            'email': email,
            'isFromRegister': true,
          },
        );
      } else {
        Get.snackbar(
          'Registration Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to register. Please try again.',
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

  Future<void> continueWithGoogle() async {
    isLoading.value = true;
    try {
      await SocialAuthService.signInWithGoogle();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> continueWithApple() async {
    isLoading.value = true;
    try {
      await SocialAuthService.signInWithApple();
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignIn() {
    Get.offNamed(Routes.signin);
  }
}
