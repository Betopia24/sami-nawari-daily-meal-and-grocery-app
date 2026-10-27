import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class UpdatepasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Current password is required';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
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
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> updatePassword() async {
    if (isLoading.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final body = {
        'oldPassword': currentPasswordController.text.trim(),
        'newPassword': newPasswordController.text.trim(),
      };

      final response = await NetworkCaller.patchRequest(
        Urls.updatePassword,
        body: body,
      );

      if (response.isSuccess) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        Get.back();
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Success',
          response.message.isNotEmpty
              ? response.message
              : 'Password updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      debugPrint('Error updating password: $e');
      Get.closeCurrentSnackbar();
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void saveChanges() => updatePassword();
}
