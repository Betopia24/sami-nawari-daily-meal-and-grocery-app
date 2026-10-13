import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';

class ForgotpasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void sendResetLink() {
    if (formKey.currentState!.validate()) {
      print('Send Reset Link clicked');
      Get.toNamed(Routes.otp, arguments: emailController.text);
    }
  }

  void goBackToSignIn() {
    Get.back();
  }
}
