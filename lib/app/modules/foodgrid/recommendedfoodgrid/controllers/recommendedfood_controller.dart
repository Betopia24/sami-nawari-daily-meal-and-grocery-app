import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/models/food_item_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class RecommendedfoodController extends GetxController {
  final isLoading = true.obs;
  final foods = <FoodItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedFoods();
  }

  /// Fetches recommended food items from the backend API.
  Future<void> fetchRecommendedFoods() async {
    try {
      isLoading.value = true;
      foods.clear();

      // 1. First attempt: AI recommendations endpoint
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
        debugPrint('AI recommendations request failed, falling back to /foods: $e');
      }

      // 2. Second attempt: /foods endpoint
      final foodsResponse = await NetworkCaller.getRequest(
        Urls.foods,
        queryParameters: {'limit': 20},
      );
      if (foodsResponse.isSuccess && foodsResponse.responseData != null) {
        final list = _parseFoodList(foodsResponse.responseData);
        if (list.isNotEmpty) {
          foods.assignAll(list);
          return;
        }
      }

      foods.clear();
    } catch (e) {
      debugPrint('Error fetching recommended foods: $e');
      foods.clear();
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
