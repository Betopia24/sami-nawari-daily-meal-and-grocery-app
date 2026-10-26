import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/food_item_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';

class HomemadefoodgridController extends GetxController {
  final isLoading = false.obs;
  final foods = <FoodItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomemadeFoods();
  }

  /// Fetches homemade food items from the backend API.
  Future<void> fetchHomemadeFoods() async {
    try {
      isLoading.value = true;

      // 1. Fetch from /foods with limit
      final response = await NetworkCaller.getRequest(
        Urls.foods,
        queryParameters: {'limit': 20},
      );

      if (response.isSuccess && response.responseData != null) {
        final list = _parseFoodList(response.responseData);
        if (list.isNotEmpty) {
          foods.assignAll(_combineWithFallback(list));
          return;
        }
      }

      // 2. Fallback if empty
      foods.assignAll(_fallbackHomemadeFoods);
    } catch (e) {
      debugPrint('Error fetching homemade foods: $e');
      foods.assignAll(_fallbackHomemadeFoods);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(FoodItemModel food) async {
    try {
      final response = await NetworkCaller.postRequest(
        Urls.cart,
        body: {
          'foodId': food.id,
          'quantity': 1,
        },
      );
      if (response.isSuccess) {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Added to Cart',
          '${food.name} added to your cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Cart',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Could not add item to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Cart',
        'Could not add item to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  List<FoodItemModel> _combineWithFallback(List<FoodItemModel> serverList) {
    final existingIds = serverList.map((e) => e.id).toSet();
    final combined = List<FoodItemModel>.from(serverList);
    for (final item in _fallbackHomemadeFoods) {
      if (!existingIds.contains(item.id)) {
        combined.add(item);
      }
    }
    return combined;
  }

  List<FoodItemModel> _parseFoodList(dynamic rawResponse) {
    try {
      dynamic rawData;
      if (rawResponse is Map) {
        rawData = rawResponse['data'];
        if (rawData is Map && rawData['data'] is List) {
          rawData = rawData['data'];
        } else if (rawData is Map && rawData['items'] is List) {
          rawData = rawData['items'];
        }
      } else if (rawResponse is List) {
        rawData = rawResponse;
      }

      if (rawData is List) {
        return rawData
            .whereType<Map<String, dynamic>>()
            .map((item) => FoodItemModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('Error parsing foods list: $e');
    }
    return [];
  }

  static final List<FoodItemModel> _fallbackHomemadeFoods = [
    FoodItemModel(
      id: '6a8d6ca9e87759724844e5ec',
      name: 'Spanakopita',
      sellerBusinessName: "Maria's Kitchen",
      sellerAddress: '1.1 km away',
      price: 4.5,
      rating: '4.8 (110)',
      images: [
        'https://res.cloudinary.com/dgk8lgdzb/image/upload/v1787653287/uploads/tkue6iscqbdqq8kqoygp.jpg',
      ],
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: '6a897de42f4aa7b54cd9298b',
      name: 'Margherita Pizza',
      sellerBusinessName: "Luca's Pasta Club",
      sellerAddress: '1.5 km away',
      price: 12.0,
      rating: '4.9 (185)',
      images: [
        'https://res.cloudinary.com/dgk8lgdzb/image/upload/v1787395554/uploads/ke0aoe73jkzg6yowz3ao.jpg',
      ],
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'food_biryani_tiffin',
      name: 'Chicken Biryani Tiffin',
      sellerBusinessName: "Amina's Home Kitchen",
      sellerAddress: '0.8 km away',
      price: 6.5,
      rating: '4.9 (214)',
      images: [AppAssets.homeRecipeCardImage1],
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'food_steamed_dumplings',
      name: 'Steamed Veg Dumplings',
      sellerBusinessName: "Mei's Dumpling Table",
      sellerAddress: '1.4 km away',
      price: 4.0,
      rating: '4.7 (132)',
      images: [AppAssets.homeRecipeCardImage2],
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'food_lentil_soup',
      name: 'Lemon Lentil Soup & Bread',
      sellerBusinessName: "Nur's Soup House",
      sellerAddress: '2.1 km away',
      price: 3.5,
      rating: '4.8 (96)',
      images: [AppAssets.homeRecipeCardImage3],
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'food_lamb_kofta',
      name: 'Lamb Kofta with Rice',
      sellerBusinessName: "Chen's Dim Sum",
      sellerAddress: '0.7 km away',
      price: 7.0,
      rating: '4.9 (88)',
      images: [AppAssets.homeRecipeCardImage2],
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
  ];
}
