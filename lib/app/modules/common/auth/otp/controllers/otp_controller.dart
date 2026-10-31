import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:daily_meal_and_grocery_app/app/data/network/local_storage.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../../../../routes/app_routes.dart';

class OtpController extends GetxController {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  final _hasError = false.obs;
  bool get hasError => _hasError.value;

  final _timerValue = 59.obs;
  int get timerValue => _timerValue.value;
  Timer? _timer;

  final isLoading = false.obs;
  final isResending = false.obs;

  String email = '';
  bool isFromRegister = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      email = args['email']?.toString() ?? '';
      isFromRegister = args['isFromRegister'] == true;
    } else if (args is String) {
      email = args;
    }
    startTimer();
  }

  String get maskedEmail {
    if (email.isEmpty) return 'us***@gmail.com';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final local = parts[0];
    final domain = parts[1];
    if (local.length <= 2) return '$local***@$domain';
    return '${local.substring(0, 2)}***@$domain';
  }

  @override
  void onClose() {
    pinController.dispose();
    focusNode.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    _timerValue.value = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerValue.value > 0) {
        _timerValue.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendCode() async {
    if (timerValue != 0 || isResending.value) return;

    isResending.value = true;

    try {
      final response = await NetworkCaller.postRequest(
        Urls.resendOtp,
        body: {
          'email': email,
          'type': isFromRegister ? 'REGISTER_VERIFY' : 'PASSWORD_RESET',
        },
        requiresToken: false,
      );

      isResending.value = false;

      if (response.isSuccess) {
        Get.snackbar(
          'Code Sent',
          response.message.isNotEmpty
              ? response.message
              : 'Verification code resent successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        startTimer();
      } else {
        Get.snackbar(
          'Failed to Resend',
          response.errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      isResending.value = false;
      Get.snackbar(
        'Error',
        'Could not resend code: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> verifyOtp() async {
    final code = pinController.text.trim();
    if (code.length != 6) {
      _hasError.value = true;
      return;
    }

    isLoading.value = true;

    if (isFromRegister) {
      // Registration email verification
      try {
        final response = await NetworkCaller.postRequest(
          Urls.verifyEmail,
          body: {
            'email': email,
            'code': code,
          },
          requiresToken: false,
        );

        isLoading.value = false;

        if (response.isSuccess) {
          final data = response.responseData;
          final responseData = data is Map ? data['data'] : null;

          final accessToken = responseData?['accessToken']?.toString();
          final refreshToken = responseData?['refreshToken']?.toString();
          final role = responseData?['user']?['role']?.toString() ??
              responseData?['role']?.toString();

          if (role != null && role.isNotEmpty) {
            await LocalStorage.saveRole(role);
          }

          if (accessToken != null && accessToken.isNotEmpty) {
            await LocalStorage.saveAccessToken(accessToken);
            _extractAndSaveUserFromJwt(accessToken);
          }
          if (refreshToken != null && refreshToken.isNotEmpty) {
            await LocalStorage.saveRefreshToken(refreshToken);
          }

          Get.snackbar(
            'Verified',
            data?['message']?.toString() ?? 'Email verified successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );

          Get.offAllNamed(Routes.navbar);
        } else {
          _hasError.value = true;
          Get.snackbar(
            'Verification Failed',
            response.errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        }
      } catch (e) {
        isLoading.value = false;
        _hasError.value = true;
        Get.snackbar(
          'Error',
          'Verification error: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } else {
      // Password reset OTP verification
      try {
        final response = await NetworkCaller.postRequest(
          Urls.verifyOtp,
          body: {
            'email': email,
            'code': code,
            'otp': code,
          },
          requiresToken: false,
        );

        isLoading.value = false;

        if (response.isSuccess) {
          final data = response.responseData;
          final responseData = data is Map ? data['data'] : null;
          final resetToken = responseData?['resetToken']?.toString();

          Get.offAllNamed(
            Routes.resetpassword,
            arguments: {
              'email': email,
              'resetToken': resetToken,
            },
          );
        } else {
          _hasError.value = true;
          Get.snackbar(
            'Verification Failed',
            response.errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        }
      } catch (e) {
        isLoading.value = false;
        _hasError.value = true;
        Get.snackbar(
          'Error',
          'Verification error: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  void _extractAndSaveUserFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = utf8.decode(
          base64Url.decode(base64Url.normalize(parts[1])),
        );
        final map = jsonDecode(payload) as Map<String, dynamic>;
        LocalStorage.saveUser(map);
        final userId = map['userId'] ?? map['id'] ?? map['_id'];
        if (userId != null) {
          LocalStorage.saveId(userId.toString());
        }
        if (map['role'] != null) {
          LocalStorage.saveRole(map['role'].toString());
        }
      }
    } catch (_) {}
  }

  void onPinChanged(String value) {
    if (_hasError.value) {
      _hasError.value = false;
    }
  }

  void goBack() {
    Get.back();
  }
}
