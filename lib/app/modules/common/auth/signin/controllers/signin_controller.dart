import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:daily_meal_and_grocery_app/app/data/network/jwt_helper.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/local_storage.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../../../../routes/app_routes.dart';

class SigninController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkExistingSession();
    _loadSavedEmail();
  }

  /// If user has a valid, non-expired access token, navigate straight to navbar
  void _checkExistingSession() async {
    final bool hasValidToken = await LocalStorage.isLoggedIn();
    if (hasValidToken) {
      Get.offAllNamed(Routes.navbar);
    }
  }

  void _loadSavedEmail() async {
    final savedEmail = await LocalStorage.getString('saved_signin_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      emailController.text = savedEmail;
      rememberMe.value = true;
    }
  }

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
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  Future<void> signin() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    isLoading.value = true;

    try {
      final response = await NetworkCaller.postRequest(
        Urls.login,
        body: {
          'email': email,
          'password': password,
        },
        requiresToken: false,
      );

      isLoading.value = false;

      if (response.isSuccess) {
        final data = response.responseData;
        final responseData = data is Map ? data['data'] : null;

        final accessToken = responseData?['accessToken']?.toString();
        final refreshToken = responseData?['refreshToken']?.toString();
        final id = responseData?['id']?.toString() ??
            responseData?['userId']?.toString() ??
            responseData?['user']?['id']?.toString();
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
        if (id != null && id.isNotEmpty) {
          await LocalStorage.saveId(id);
        }

        // Remember me handling
        if (rememberMe.value) {
          await LocalStorage.setString('saved_signin_email', email);
        } else {
          await LocalStorage.remove('saved_signin_email');
        }

        Get.snackbar(
          'Success',
          data?['message']?.toString() ?? 'Logged in successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        );

        Get.offAllNamed(Routes.navbar);
      } else {
        final errorMessage = response.errorMessage;
        final statusCode = response.statusCode;

        if (statusCode == 403 &&
            errorMessage.toLowerCase().contains('verify your email')) {
          Get.snackbar(
            'Verification Required',
            errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFFF59E0B),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
          Get.toNamed(Routes.otp, arguments: email);
          return;
        }

        Get.snackbar(
          'Sign In Failed',
          errorMessage.isNotEmpty ? errorMessage : 'Invalid credentials. Please try again.',
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

  void _extractAndSaveUserFromJwt(String token) {
    try {
      final map = JwtHelper.decodePayload(token);
      if (map != null) {
        LocalStorage.saveUser(map);
        final userId = JwtHelper.getUserId(token);
        if (userId != null) {
          LocalStorage.saveId(userId);
        }
        final role = JwtHelper.getRole(token) ?? map['role']?.toString();
        if (role != null && role.isNotEmpty) {
          LocalStorage.saveRole(role);
        }
      }
    } catch (_) {}
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
