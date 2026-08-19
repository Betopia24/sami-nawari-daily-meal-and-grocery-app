import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';

class SigninController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final rememberMe = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    // We might not need the strict 8 char/uppercase rules just to sign in,
    // but we can leave it simple for sign in.
    return null;
  }

  void signin() {
    if (formKey.currentState!.validate()) {
      // Implement sign in logic here
      Get.offAllNamed(Routes.home); // Navigate to home on success
    }
  }

  void goToSignUp() {
    Get.offNamed(Routes.signup);
  }

  void goToForgotPassword() {
    Get.toNamed(Routes.forgotpassword);
  }

  void continueWithGoogle() {
    // Implement Google sign in
  }

  void continueWithApple() {
    // Implement Apple sign in
  }
}
