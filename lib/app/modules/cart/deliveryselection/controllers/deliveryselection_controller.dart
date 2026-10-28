import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../data/models/cart_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../mycarts/controllers/mycarts_controller.dart';
import '../../revieworder/controllers/revieworder_controller.dart';

class DeliveryselectionController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<CartGroupModel> cartGroups = <CartGroupModel>[].obs;

  // Selected delivery method for each restaurant index: 0 for Pickup, 1 for Delivery
  final selectedMethods = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() {
    // 1. Take from RevieworderController if already loaded
    if (Get.isRegistered<RevieworderController>()) {
      final reviewController = Get.find<RevieworderController>();
      if (reviewController.cartGroups.isNotEmpty) {
        cartGroups.assignAll(reviewController.cartGroups);
        _initMethods();
        isLoading.value = false;
        return;
      }
    }

    // 2. Take from MycartsController if registered
    if (Get.isRegistered<MycartsController>()) {
      final mycarts = Get.find<MycartsController>();
      if (mycarts.cartGroups.isNotEmpty) {
        cartGroups.assignAll(mycarts.cartGroups);
        _initMethods();
        isLoading.value = false;
        return;
      }
    }

    // 3. Otherwise fetch from API /cart
    fetchCart();
  }

  void _initMethods() {
    for (int i = 0; i < cartGroups.length; i++) {
      final group = cartGroups[i];
      // Default to Pickup (0) if available, otherwise Delivery (1)
      selectedMethods[i] = group.hasPickup ? 0 : 1;
    }
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
          _initMethods();
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching cart for delivery selection: $e');
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

  void selectMethod(int restaurantIndex, int methodIndex) {
    selectedMethods[restaurantIndex] = methodIndex;
  }

  void onContinue() {
    Get.toNamed('/deliveryaddress');
  }
}
