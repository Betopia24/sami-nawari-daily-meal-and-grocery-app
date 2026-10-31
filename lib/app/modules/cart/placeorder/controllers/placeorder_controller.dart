import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../core/utils/app_assets.dart';
import '../../../../data/models/cart_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../deliveryaddress/controllers/deliveryaddress_controller.dart';
import '../../deliveryselection/controllers/deliveryselection_controller.dart';
import '../../mycarts/controllers/mycarts_controller.dart';
import '../../revieworder/controllers/revieworder_controller.dart';
import '../../views/stripe_payment_view.dart';

class PlaceorderController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;

  // Dynamic cart groups and delivery selections
  final RxList<CartGroupModel> cartGroups = <CartGroupModel>[].obs;
  // Selected delivery method for each restaurant index: 0 for Pickup, 1 for Delivery
  final RxMap<int, int> selectedDeliveryMethods = <int, int>{}.obs;

  // 0: Pay Online, 1: Cash on Delivery / Cash on Pickup
  final RxInt selectedPaymentMethod = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() {
    // 1. Take from DeliveryselectionController (has user's chosen pickup/delivery selections)
    if (Get.isRegistered<DeliveryselectionController>()) {
      final deliveryCtrl = Get.find<DeliveryselectionController>();
      if (deliveryCtrl.cartGroups.isNotEmpty) {
        cartGroups.assignAll(deliveryCtrl.cartGroups);
        selectedDeliveryMethods.assignAll(deliveryCtrl.selectedMethods);

        for (int i = 0; i < cartGroups.length; i++) {
          selectedDeliveryMethods.putIfAbsent(
            i,
            () => cartGroups[i].hasPickup ? 0 : 1,
          );
        }

        isLoading.value = false;
        return;
      }
    }

    // 2. Fallback to RevieworderController
    if (Get.isRegistered<RevieworderController>()) {
      final reviewCtrl = Get.find<RevieworderController>();
      if (reviewCtrl.cartGroups.isNotEmpty) {
        cartGroups.assignAll(reviewCtrl.cartGroups);
        for (int i = 0; i < cartGroups.length; i++) {
          selectedDeliveryMethods[i] = cartGroups[i].hasPickup ? 0 : 1;
        }
        isLoading.value = false;
        return;
      }
    }

    // 3. Fallback to MycartsController
    if (Get.isRegistered<MycartsController>()) {
      final mycartsCtrl = Get.find<MycartsController>();
      if (mycartsCtrl.cartGroups.isNotEmpty) {
        cartGroups.assignAll(mycartsCtrl.cartGroups);
        for (int i = 0; i < cartGroups.length; i++) {
          selectedDeliveryMethods[i] = cartGroups[i].hasPickup ? 0 : 1;
        }
        isLoading.value = false;
        return;
      }
    }

    // 4. Otherwise fetch cart from API
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      final response = await NetworkCaller.getRequest(Urls.cart);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData = body is Map ? (body['data'] ?? body) : null;

        List<dynamic>? itemsList;
        if (rawData is Map && rawData['items'] is List) {
          itemsList = rawData['items'] as List;
        } else if (rawData is List) {
          itemsList = rawData;
        }

        if (itemsList != null && itemsList.isNotEmpty) {
          final List<CartItemModel> parsed = itemsList.map((item) {
            return CartItemModel.fromJson(item as Map<String, dynamic>);
          }).toList();

          _rebuildGroups(parsed);
          for (int i = 0; i < cartGroups.length; i++) {
            selectedDeliveryMethods[i] = cartGroups[i].hasPickup ? 0 : 1;
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching cart for place order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _rebuildGroups(List<CartItemModel> items) {
    final Map<String, List<CartItemModel>> grouped = {};
    for (final item in items) {
      final key = item.sellerId.isNotEmpty ? item.sellerId : item.sellerName;
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final List<CartGroupModel> groups = [];
    grouped.forEach((key, groupItems) {
      final first = groupItems.first;
      String restaurantImg = AppAssets.homeRecipeCardImage1;
      final lowerKey = key.toLowerCase();
      final lowerName = first.sellerName.toLowerCase();

      if (lowerKey.contains('luca') ||
          lowerName.contains('luca') ||
          lowerName.contains('pasta') ||
          lowerName.contains('pizza')) {
        restaurantImg = AppAssets.homeRecipeCardImage2;
      } else if (lowerKey.contains('priya') ||
          lowerName.contains('priya') ||
          lowerName.contains('spice') ||
          lowerName.contains('biryani')) {
        restaurantImg = AppAssets.homeRecipeCardImage3;
      } else if (lowerKey.contains('chen') ||
          lowerName.contains('chen') ||
          lowerName.contains('dim sum')) {
        restaurantImg = AppAssets.homeRecipeCardImage1;
      } else if (first.image.isNotEmpty) {
        restaurantImg = first.image;
      }

      groups.add(
        CartGroupModel(
          sellerId: first.sellerId,
          sellerName: first.sellerName,
          authorName: first.sellerAuthor,
          restaurantImage: restaurantImg,
          prepTime: first.prepTime,
          hasPickup: first.pickupAvailable,
          deliveryFee: first.deliveryFee,
          items: groupItems,
        ),
      );
    });

    cartGroups.assignAll(groups);
  }

  // --- Dynamic Pricing & Status Helpers ---

  bool isPickup(int index) => (selectedDeliveryMethods[index] ?? 0) == 0;

  double getDeliveryFeeForGroup(int index) {
    if (index < 0 || index >= cartGroups.length) return 0.0;
    // Pickup is free (0.00 delivery fee)
    if (isPickup(index)) return 0.0;
    return cartGroups[index].deliveryFee;
  }

  double get itemsSubtotal {
    double total = 0.0;
    for (final group in cartGroups) {
      for (final item in group.items) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  double get totalDeliveryFee {
    double fee = 0.0;
    for (int i = 0; i < cartGroups.length; i++) {
      fee += getDeliveryFeeForGroup(i);
    }
    return fee;
  }

  double get platformFee => 0.00;

  double get totalPayable => itemsSubtotal + totalDeliveryFee + platformFee;

  String get formattedTotalPayable => '\$${totalPayable.toStringAsFixed(2)}';

  bool get allPickup =>
      cartGroups.isNotEmpty &&
      cartGroups.asMap().keys.every((index) => isPickup(index));

  void selectPaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

  Future<void> onPlaceOrder() async {
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;

      // 1. Extract delivery address dynamically from DeliveryaddressController (no static data)
      String streetAddress = '';
      String apt = '';
      String city = '';
      String note = '';

      if (Get.isRegistered<DeliveryaddressController>()) {
        final addressCtrl = Get.find<DeliveryaddressController>();
        streetAddress = addressCtrl.streetController.text.trim();
        apt = addressCtrl.aptController.text.trim();
        city = addressCtrl.cityController.text.trim();
        note = addressCtrl.notesController.text.trim();
      }

      // If order requires delivery and address is missing, alert user
      if (!allPickup && streetAddress.isEmpty) {
        Get.snackbar(
          'Delivery Address Required',
          'Please enter your delivery street address before proceeding.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
        return;
      }

      // 2. Fetch buyer's real recipient name and phone from profile
      String recipientName = 'Customer';
      String contactPhone = '+1000000000';
      try {
        final profileRes = await NetworkCaller.getRequest(Urls.userMe);
        if (profileRes.isSuccess && profileRes.responseData != null) {
          final pData = profileRes.responseData['data'];
          if (pData is Map) {
            final name = pData['name']?.toString() ?? '';
            final phone = (pData['phone'] ?? pData['phoneNumber'])?.toString() ?? '';
            if (name.isNotEmpty) recipientName = name;
            if (phone.isNotEmpty) contactPhone = phone;
          }
        }
      } catch (e) {
        debugPrint('Error getting buyer profile for order: $e');
      }

      // 3. Payment Method: ONLINE or CASH_ON_DELIVERY (matches backend API spec)
      final bool isOnline = selectedPaymentMethod.value == 0;
      final String methodStr = isOnline ? 'ONLINE' : 'CASH_ON_DELIVERY';

      final Map<String, dynamic> body = {
        'deliveryAddress': {
          'streetAddress': streetAddress.isNotEmpty ? streetAddress : 'Pickup At Seller Kitchen',
          if (apt.isNotEmpty) 'apt': apt,
          'city': city.isNotEmpty ? city : 'City',
          'state': 'State',
          'postalCode': '1000',
          'country': 'USA',
        },
        'recipientName': recipientName,
        'contactPhone': contactPhone,
        if (note.isNotEmpty) 'note': note,
        'paymentMethod': methodStr,
      };

      debugPrint('➡️ [PlaceorderController] Submitting order via POST ${Urls.orders}');
      final response = await NetworkCaller.postRequest(Urls.orders, body: body);

      if (response.isSuccess && response.responseData != null) {
        final bodyData = response.responseData;
        final d = bodyData is Map ? (bodyData['data'] ?? bodyData) : null;
        final orderId = d is Map ? (d['id'] ?? d['_id'] ?? '').toString() : '';
        final orderNumber = d is Map ? (d['orderNumber'] ?? '').toString() : '';

        final firstGroup = cartGroups.isNotEmpty ? cartGroups.first : null;
        final totalCount = cartGroups.fold<int>(
          0,
          (sum, g) => sum + g.items.fold<int>(0, (s, i) => s + i.quantity),
        );

        // 4. If Online Payment selected, create Stripe Checkout Session
        if (isOnline && orderId.isNotEmpty) {
          String checkoutUrl = '';
          debugPrint('➡️ [PlaceorderController] Creating Stripe session via ${Urls.createCheckoutSession}');
          final sessionRes = await NetworkCaller.postRequest(
            Urls.createCheckoutSession,
            body: {'orderId': orderId},
          );

          if (sessionRes.isSuccess && sessionRes.responseData != null) {
            final sData = sessionRes.responseData['data'];
            if (sData is Map) {
              checkoutUrl = sData['url']?.toString() ?? '';
            }
          }

          // Refresh Cart and Orders in memory
          if (Get.isRegistered<MycartsController>()) {
            final mc = Get.find<MycartsController>();
            mc.fetchCart();
            mc.fetchOrders();
          }

          if (checkoutUrl.isNotEmpty) {
            debugPrint('💳 [PlaceorderController] Opening in-app Stripe Checkout: $checkoutUrl');
            Get.off(
              () => StripePaymentView(
                checkoutUrl: checkoutUrl,
                orderId: orderId,
                orderNumber: orderNumber,
                restaurantName: firstGroup?.sellerName ?? "Seller's Kitchen",
                restaurantImage: firstGroup?.restaurantImage ?? AppAssets.homeRecipeCardImage1,
                itemsCountText: '$totalCount item${totalCount > 1 ? 's' : ''}',
                priceText: formattedTotalPayable,
              ),
            );
            return;
          } else {
            // Failed to generate checkout url, navigate to orderplaced with retry button
            Get.offAllNamed(
              '/orderplaced',
              arguments: {
                'orderId': orderId,
                'orderNumber': orderNumber,
                'restaurantName': firstGroup?.sellerName ?? "Seller's Kitchen",
                'restaurantImage': firstGroup?.restaurantImage ?? AppAssets.homeRecipeCardImage1,
                'itemsCountText': '$totalCount item${totalCount > 1 ? 's' : ''}',
                'priceText': formattedTotalPayable,
                'paymentMethodTitle': 'Payment Method',
                'paymentMethodSubtitle': 'Online (Stripe - Pending)',
                'isOnline': true,
                'isSuccess': false,
                'paymentStatus': 'PENDING',
                'checkoutUrl': '',
              },
            );
            return;
          }
        }

        // 5. Cash on Delivery / Pickup Flow
        if (Get.isRegistered<MycartsController>()) {
          final mc = Get.find<MycartsController>();
          mc.fetchCart();
          mc.fetchOrders();
        }

        Get.offAllNamed(
          '/orderplaced',
          arguments: {
            'orderId': orderId,
            'orderNumber': orderNumber,
            'restaurantName': firstGroup?.sellerName ?? "Seller's Kitchen",
            'restaurantImage': firstGroup?.restaurantImage ?? AppAssets.homeRecipeCardImage1,
            'itemsCountText': '$totalCount item${totalCount > 1 ? 's' : ''}',
            'priceText': formattedTotalPayable,
            'paymentMethodTitle': 'Payment Method',
            'paymentMethodSubtitle':
                allPickup ? 'Cash on Pickup' : 'Cash on Delivery',
            'isOnline': false,
            'isSuccess': true,
            'paymentStatus': 'COD',
            'checkoutUrl': '',
          },
        );
      } else {
        Get.snackbar(
          'Order Placement Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to place order. Please check your items and try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error placing order: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred while placing order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
