import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/food_item_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
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
        foods.assignAll(list);
      } else {
        foods.clear();
      }
    } catch (e) {
      debugPrint('Error fetching homemade foods: $e');
      foods.clear();
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
}
