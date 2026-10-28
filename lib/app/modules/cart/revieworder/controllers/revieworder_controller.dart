import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../data/models/cart_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../mycarts/controllers/mycarts_controller.dart';

class RevieworderController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<CartGroupModel> cartGroups = <CartGroupModel>[].obs;
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxDouble totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. If MycartsController already has populated cart items, use them immediately
    if (Get.isRegistered<MycartsController>()) {
      final mycarts = Get.find<MycartsController>();
      if (mycarts.cartGroups.isNotEmpty) {
        cartGroups.assignAll(mycarts.cartGroups);
        cartItems.assignAll(mycarts.cartItems);
        totalPrice.value = mycarts.totalPrice.value;
        isLoading.value = false;
        return;
      }
    }
    // 2. Otherwise fetch from backend /cart API
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

          cartItems.assignAll(parsed);
          _rebuildCartGroups();
          return;
        }
      }
      if (cartItems.isEmpty) {
        _loadDefaultCart();
      }
    } catch (e) {
      debugPrint('Error fetching review order cart: $e');
      if (cartItems.isEmpty) {
        _loadDefaultCart();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDefaultCart() {
    cartItems.assignAll([
      CartItemModel(
        foodId: '6a8d6ca9e87759724844e5ec',
        name: 'Classic Mezze Platter',
        price: 18.0,
        quantity: 1,
        image: AppAssets.homeRecipeCardImage1,
        sellerId: 'seller_1',
        sellerName: "Maria's Kitchen",
        sellerAuthor: 'Maria Santos',
        prepTime: '25 min',
        pickupAvailable: true,
        deliveryFee: 1.50,
      ),
      CartItemModel(
        foodId: '6a897de42f4aa7b54cd9298b',
        name: 'Cacio e Pepe',
        price: 13.0,
        quantity: 1,
        image: AppAssets.homeRecipeCardImage2,
        sellerId: 'seller_2',
        sellerName: "Luca's Pasta Club",
        sellerAuthor: 'Luca Buanchi',
        prepTime: '20 min',
        pickupAvailable: true,
        deliveryFee: 2.50,
      ),
      CartItemModel(
        foodId: 'food_tiramisu',
        name: 'Tirasamu',
        price: 7.0,
        quantity: 2,
        image: AppAssets.homeRecipeCardImage2,
        sellerId: 'seller_2',
        sellerName: "Luca's Pasta Club",
        sellerAuthor: 'Luca Buanchi',
        prepTime: '20 min',
        pickupAvailable: true,
        deliveryFee: 2.50,
      ),
    ]);
    _rebuildCartGroups();
  }

  void _rebuildCartGroups() {
    final Map<String, List<CartItemModel>> grouped = {};
    for (final item in cartItems) {
      final key = item.sellerId.isNotEmpty ? item.sellerId : item.sellerName;
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final List<CartGroupModel> groups = [];
    double calculatedTotal = 0.0;

    grouped.forEach((key, items) {
      final first = items.first;
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

      final group = CartGroupModel(
        sellerId: first.sellerId,
        sellerName: first.sellerName,
        authorName: first.sellerAuthor,
        restaurantImage: restaurantImg,
        prepTime: first.prepTime,
        hasPickup: first.pickupAvailable,
        deliveryFee: first.deliveryFee,
        items: items,
      );
      groups.add(group);
      calculatedTotal += group.totalPrice;
    });

    cartGroups.assignAll(groups);
    totalPrice.value = calculatedTotal;
  }

  void onContinue() {
    Get.toNamed('/deliveryselection');
  }
}
