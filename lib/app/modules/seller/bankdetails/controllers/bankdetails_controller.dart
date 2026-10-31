import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../../core/utils/app_colors.dart';
import '../views/stripe_webview_screen.dart';

class BankdetailsController extends GetxController {
  final isLoading = false.obs;
  final stripeUrl = ''.obs;
  final stripeAccountId = ''.obs;
  final isCompleted = false.obs;

  /// Call Stripe Connect POST API and open in-app onboarding flow
  Future<void> connectWithStripe() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final response = await NetworkCaller.postRequest(Urls.stripeConnect);

      if (response.isSuccess && response.responseData != null) {
        String? url;
        String? accountId;

        if (response.responseData is Map) {
          final resMap = response.responseData as Map;
          if (resMap['data'] is Map) {
            url = resMap['data']['url']?.toString();
            accountId = resMap['data']['stripeAccountId']?.toString();
          } else if (resMap['url'] != null) {
            url = resMap['url']?.toString();
          }
        }

        if (url != null && url.isNotEmpty) {
          stripeUrl.value = url;
          if (accountId != null && accountId.isNotEmpty) {
            stripeAccountId.value = accountId;
          }

          // Open In-App Browser / WebView safely
          await openStripeOnboarding(url);
        } else {
          Get.snackbar(
            'Error',
            'Could not find onboarding link in response',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to generate Stripe onboarding link',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Launch Stripe Onboarding safely in In-App Browser (Chrome Custom Tab / Safari View Controller)
  /// with automatic fallback to embedded webview.
  Future<void> openStripeOnboarding(String url) async {
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );

      if (!launched) {
        // Fallback to internal webview screen
        _openFallbackWebView(url);
      }
    } catch (e) {
      debugPrint('Launch inAppBrowserView failed: $e, falling back to internal webview');
      try {
        _openFallbackWebView(url);
      } catch (innerError) {
        // Final fallback to external browser
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    }
  }

  void _openFallbackWebView(String url) {
    Get.to(
      () => StripeWebViewScreen(
        url: url,
        onComplete: () {
          isCompleted.value = true;
          Get.back();
          Get.snackbar(
            'Connected',
            'Stripe onboarding processed successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.primary,
            colorText: Colors.white,
          );
        },
      ),
    );
  }

  /// Re-open WebView / In-App browser if link was already generated
  void openExistingStripeUrl() {
    if (stripeUrl.value.isNotEmpty) {
      openStripeOnboarding(stripeUrl.value);
    }
  }
}
