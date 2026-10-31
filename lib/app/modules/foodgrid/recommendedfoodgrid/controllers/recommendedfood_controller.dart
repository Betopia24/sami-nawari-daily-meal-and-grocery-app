import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/food_item_model.dart';
import '../../../../data/network/local_storage.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../routes/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';

class RecommendedfoodController extends GetxController {
  final isLoading = true.obs;
  final foods = <FoodItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialFoods();
  }

  bool isOwnFood(FoodItemModel food) => LocalStorage.isOwnFood(food);

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
      }
      Get.toNamed(Routes.mycarts);
    } catch (e) {
      Get.toNamed(Routes.mycarts);
    }
  }

  /// Initializes foods from navigation arguments, dashboard cache, or API.
  void _loadInitialFoods() {
    // 1. Direct navigation arguments passed from Dashboard "See all"
    final args = Get.arguments;
    if (args is List<FoodItemModel> && args.isNotEmpty) {
      foods.assignAll(args);
      isLoading.value = false;
      return;
    } else if (args is List && args.isNotEmpty) {
      final list = args.whereType<FoodItemModel>().toList();
      if (list.isNotEmpty) {
        foods.assignAll(list);
        isLoading.value = false;
        return;
      }
    }

    // 2. Read from active DashboardController if available
    if (Get.isRegistered<DashboardController>()) {
      final dashboardCtrl = Get.find<DashboardController>();
      if (dashboardCtrl.recommendedFoods.isNotEmpty) {
        foods.assignAll(dashboardCtrl.recommendedFoods);
        isLoading.value = false;
        return;
      }
    }

    // 3. Otherwise fetch from backend API
    fetchRecommendedFoods();
  }

  /// Fetches recommended food items from the backend API.
  Future<void> fetchRecommendedFoods() async {
    try {
      if (foods.isEmpty) {
        isLoading.value = true;
      }

      // 1. Query /foods endpoint (matching DashboardController source)
      final foodsResponse = await NetworkCaller.getRequest(Urls.foods);
      if (foodsResponse.isSuccess && foodsResponse.responseData != null) {
        final list = _parseFoodList(foodsResponse.responseData);
        if (list.isNotEmpty) {
          foods.assignAll(list);
          // Keep DashboardController in sync if registered
          if (Get.isRegistered<DashboardController>()) {
            Get.find<DashboardController>().recommendedFoods.assignAll(list);
          }
          return;
        }
      }

      // 2. Fallback attempt: AI recommendations endpoint
      try {
        final aiResponse = await NetworkCaller.postRequest(
          Urls.aiRecommendFoods,
          body: {'limit': 20},
        );
        if (aiResponse.isSuccess && aiResponse.responseData != null) {
          final list = _parseFoodList(aiResponse.responseData);
          if (list.isNotEmpty) {
            foods.assignAll(list);
            return;
          }
        }
      } catch (e) {
        debugPrint('AI recommendations request failed: $e');
      }

      // If empty or error, retain existing dashboard items if available
      if (foods.isEmpty && Get.isRegistered<DashboardController>()) {
        final dashboardCtrl = Get.find<DashboardController>();
        if (dashboardCtrl.recommendedFoods.isNotEmpty) {
          foods.assignAll(dashboardCtrl.recommendedFoods);
        }
      }
    } catch (e) {
      debugPrint('Error fetching recommended foods: $e');
    } finally {
      isLoading.value = false;
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
