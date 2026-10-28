import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/seller_food_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class MyFoodController extends GetxController {
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<SellerFoodItem> allFoods = <SellerFoodItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSellerFoods();
  }

  final List<String> standardCategories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  List<String> get availableCategories {
    final existingCategories = allFoods
        .map((f) => f.displayCategory)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();

    final List<String> list = ['All'];
    for (final cat in standardCategories) {
      if (cat != 'All' &&
          (existingCategories.contains(cat) || list.length < 5)) {
        if (!list.contains(cat)) list.add(cat);
      }
    }
    for (final cat in existingCategories) {
      if (!list.contains(cat)) list.add(cat);
    }
    return list;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  List<SellerFoodItem> get filteredFoods {
    final filter = selectedCategory.value.trim().toLowerCase();
    if (filter == 'all') {
      return allFoods;
    }
    return allFoods.where((food) {
      final cat = food.category.toLowerCase();
      final displayCat = food.displayCategory.toLowerCase();
      return cat == filter || displayCat == filter;
    }).toList();
  }

  Future<void> fetchSellerFoods({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await NetworkCaller.getRequest(Urls.sellerFoodsList);

      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData = body is Map ? (body['data'] ?? body) : body;

        List<dynamic>? foodsList;
        if (rawData is Map && rawData['data'] is List) {
          foodsList = rawData['data'] as List;
        } else if (rawData is List) {
          foodsList = rawData;
        } else if (body is List) {
          foodsList = body;
        }

        if (foodsList != null) {
          final List<SellerFoodItem> loaded = foodsList
              .whereType<Map<String, dynamic>>()
              .map((json) => SellerFoodItem.fromJson(json))
              .toList();
          allFoods.assignAll(loaded);
        } else {
          allFoods.clear();
        }
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load food listings';
      }
    } catch (e) {
      debugPrint('Error fetching seller foods: $e');
      errorMessage.value = 'Failed to load food listings. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE FOOD (DELETE /foods/seller/:foodId)
  // ---------------------------------------------------------------------------
  final RxBool isDeleting = false.obs;
  final RxString deletingFoodId = ''.obs;

  Future<bool> deleteFood(String foodId) async {
    isDeleting.value = true;
    deletingFoodId.value = foodId;

    try {
      final endpoint = Urls.getDeleteFoodUrl(foodId);
      final response = await NetworkCaller.deleteRequest(endpoint);

      if (response.isSuccess) {
        allFoods.removeWhere((item) => item.id == foodId);
        Get.snackbar(
          'Deleted',
          response.successMessage ?? 'Food item deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B5E37),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return true;
      } else {
        Get.snackbar(
          'Delete Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to delete food item',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Delete Error',
        'Could not delete food: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isDeleting.value = false;
      deletingFoodId.value = '';
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE FOOD (PATCH /foods/seller/food_id)
  // ---------------------------------------------------------------------------
  final RxBool isUpdating = false.obs;

  Future<bool> updateFood(String foodId, Map<String, dynamic> body) async {
    isUpdating.value = true;

    try {
      final endpoint = Urls.getUpdateFoodUrl(foodId);
      final response = await NetworkCaller.patchRequest(
        endpoint,
        body: body,
      );

      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          response.successMessage ?? 'Food item updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B5E37),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        // Refresh list to fetch updated item from server
        await fetchSellerFoods(showLoading: false);
        return true;
      } else {
        Get.snackbar(
          'Update Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update food item',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Update Error',
        'Could not update food: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
}
