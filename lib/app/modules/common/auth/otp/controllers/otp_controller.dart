import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';

class OtpController extends GetxController {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  final _hasError = false.obs;
  bool get hasError => _hasError.value;

  final _timerValue = 59.obs;
  int get timerValue => _timerValue.value;
  Timer? _timer;

  String email = '';

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments as String? ?? '';
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

  void resendCode() {
    if (timerValue == 0) {
      // Implement resend logic here
      print("Resending OTP...");
      startTimer();
    }
  }

  void verifyOtp() {
    if (pinController.text.length == 6) {
      // Implement verification logic
      print("Verifying OTP: ${pinController.text}");
      Get.offAllNamed(Routes.resetpassword, arguments: email);
    } else {
      _hasError.value = true;
    }
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
