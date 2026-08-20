import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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

  String email = '';

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments as String? ?? 'us***@gmail.com';
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
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void resetPassword() {
    if (formKey.currentState!.validate()) {
      Get.offAll(
        () => SuccessScreen(
          title: 'Password reset!',
          subtitle:
              'Your password has been updated successfully.\nSign in with your new password.',
          buttonText: 'Sign In Now',
          onButtonPressed: () => Get.offAllNamed(Routes.signin),
        ),
      );
    }
  }

  void goBack() {
    Get.offAllNamed(Routes.forgotpassword);
  }
}
