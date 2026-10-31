import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_assets.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import 'package:daily_meal_and_grocery_app/app/modules/cart/mycarts/controllers/mycarts_controller.dart' as import_mycarts;
import 'package:daily_meal_and_grocery_app/app/modules/cart/views/stripe_payment_view.dart';
import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';

class OrderplacedController extends GetxController {
  final RxString restaurantName = "Seller's Kitchen".obs;
  final RxString restaurantImage = AppAssets.homeRecipeCardImage1.obs;
  final RxString itemsCountText = "1 item".obs;
  final RxString priceText = "\$0.00".obs;
  final RxString paymentMethodTitle = "Payment Method".obs;
  final RxString paymentMethodSubtitle = "Cash on Delivery".obs;
  final RxString orderNumber = "".obs;
  final RxString orderId = "".obs;
  final RxString checkoutUrl = "".obs;
  final RxBool isOnline = false.obs;
  final RxBool isSuccess = true.obs;
  final RxString paymentStatus = "PENDING".obs;
  final RxBool isRetrying = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      if (args['restaurantName'] != null) {
        restaurantName.value = args['restaurantName'].toString();
      }
      if (args['restaurantImage'] != null) {
        restaurantImage.value = args['restaurantImage'].toString();
      }
      if (args['itemsCountText'] != null) {
        itemsCountText.value = args['itemsCountText'].toString();
      }
      if (args['priceText'] != null) {
        priceText.value = args['priceText'].toString();
      }
      if (args['paymentMethodTitle'] != null) {
        paymentMethodTitle.value = args['paymentMethodTitle'].toString();
      }
      if (args['paymentMethodSubtitle'] != null) {
        paymentMethodSubtitle.value = args['paymentMethodSubtitle'].toString();
      }
      if (args['orderNumber'] != null) {
        orderNumber.value = args['orderNumber'].toString();
      }
      if (args['orderId'] != null) {
        orderId.value = args['orderId'].toString();
      }
      if (args['checkoutUrl'] != null) {
        checkoutUrl.value = args['checkoutUrl'].toString();
      }
      if (args['isOnline'] is bool) {
        isOnline.value = args['isOnline'] as bool;
      }
      if (args['isSuccess'] is bool) {
        isSuccess.value = args['isSuccess'] as bool;
      }
      if (args['paymentStatus'] != null) {
        paymentStatus.value = args['paymentStatus'].toString();
      }
    }
  }

  /// Retries payment for this order by generating a new Stripe Checkout URL via POST /payments/retry-payment/:orderId
  Future<void> retryPayment() async {
    final targetOrderId = orderId.value;
    if (targetOrderId.isEmpty) {
      Get.snackbar(
        'Error',
        'Order ID not found for payment retry.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isRetrying.value = true;
      debugPrint('➡️ [OrderplacedController] Calling POST ${Urls.retryPayment(targetOrderId)}');
      final response = await NetworkCaller.postRequest(
        Urls.retryPayment(targetOrderId),
        body: {},
      );

      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final d = body is Map ? (body['data'] ?? body) : null;
        final newUrl = d is Map ? (d['url']?.toString() ?? '') : '';

        if (newUrl.isNotEmpty) {
          checkoutUrl.value = newUrl;
          // Open in-app Stripe WebView
          Get.to(
            () => StripePaymentView(
              checkoutUrl: newUrl,
              orderId: targetOrderId,
              orderNumber: orderNumber.value,
              restaurantName: restaurantName.value,
              restaurantImage: restaurantImage.value,
              itemsCountText: itemsCountText.value,
              priceText: priceText.value,
            ),
          );
        } else {
          Get.snackbar(
            'Payment Error',
            'Could not retrieve a new payment session URL.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Retry Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to generate retry payment session.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error retrying payment: $e');
    } finally {
      isRetrying.value = false;
    }
  }

  Future<void> openStripeCheckout() async {
    final urlStr = checkoutUrl.value;
    if (urlStr.isNotEmpty) {
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void onTrackMyOrder() {
    if (Get.isRegistered<import_mycarts.MycartsController>()) {
      final cartController = Get.find<import_mycarts.MycartsController>();
      if (cartController.tabController.length > 1) {
        cartController.tabController.animateTo(1);
      }
      cartController.currentTabIndex.value = 1;
      cartController.fetchOrders();
    }
    
    Get.toNamed(
      Routes.mycarts,
      arguments: {'mycarts_tab': 1},
    );
  }

  void onBackToCart() {
    if (Get.isRegistered<import_mycarts.MycartsController>()) {
      final mc = Get.find<import_mycarts.MycartsController>();
      if (mc.tabController.length > 0) {
        mc.tabController.animateTo(0);
      }
      mc.currentTabIndex.value = 0;
      mc.fetchCart();
    }
    Get.offNamed(
      Routes.mycarts,
      arguments: {'mycarts_tab': 0},
    );
  }
}
