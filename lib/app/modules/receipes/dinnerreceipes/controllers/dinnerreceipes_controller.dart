import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../../../../core/utils/app_assets.dart';

class DinnerreceipesController extends GetxController {
  final isLoading = true.obs;
  final tags = ['All', 'Family', 'Quick', 'Special', 'Comfort'];
  final selectedTagIndex = 0.obs;

  final RxList<Map<String, dynamic>> recipes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  /// Fetches recipes from backend API for dinner category
  Future<void> fetchRecipes() async {
    isLoading.value = true;
    try {
      // 1. Fetch from /foods/recipe/DINNER
      final response = await NetworkCaller.getRequest('${Urls.foodRecipes}/DINNER');
      List<Map<String, dynamic>> parsedList = [];

      if (response.isSuccess && response.responseData != null) {
        parsedList = _parseRecipeItems(response.responseData);
      }

      // 2. If empty, check /foods?category=DINNER
      if (parsedList.isEmpty) {
        final foodsResponse = await NetworkCaller.getRequest(
          Urls.foods,
          queryParameters: {'category': 'DINNER'},
        );
        if (foodsResponse.isSuccess && foodsResponse.responseData != null) {
          parsedList = _parseRecipeItems(foodsResponse.responseData);
        }
      }

      recipes.assignAll(parsedList);
    } catch (e) {
      debugPrint('Error fetching dinner recipes: $e');
      recipes.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> _parseRecipeItems(dynamic rawResponse) {
    try {
      dynamic rawData;
      if (rawResponse is Map) {
        rawData = rawResponse['data'];
        if (rawData is Map && rawData['data'] is List) {
          rawData = rawData['data'];
        }
      }
      if (rawData is List) {
        return rawData.map<Map<String, dynamic>>((item) {
          final map = item as Map<String, dynamic>;
          List<String> imgList = [];
          if (map['images'] is List) {
            imgList = (map['images'] as List)
                .map((e) => e?.toString() ?? '')
                .where((e) => e.isNotEmpty)
                .toList();
          }

          final subcategory = map['subcategory']?.toString() ?? '';
          List<String> tagsList = [];
          if (subcategory.isNotEmpty) {
            tagsList.add(subcategory.capitalizeFirst ?? subcategory);
          }
          if (tagsList.isEmpty) {
            tagsList = ['Family', 'Comfort'];
          }

          return {
            'id': map['id']?.toString() ?? map['_id']?.toString() ?? '',
            'imagePath': imgList.isNotEmpty
                ? imgList.first
                : AppAssets.homeDinnerCardImage,
            'tags': tagsList,
            'title': map['name']?.toString() ?? 'Recipe',
            'time': map['preparationTime']?.toString() ?? '30 min',
            'calories': map['calories']?.toString() ?? '520 kcal',
            'rating': (map['rating'] as num?)?.toDouble() ?? 4.9,
          };
        }).toList();
      }
    } catch (e) {
      debugPrint('Error parsing dinner recipe items: $e');
    }
    return [];
  }

  List<Map<String, dynamic>> get filteredRecipes {
    if (selectedTagIndex.value == 0) return recipes;
    final selectedTag = tags[selectedTagIndex.value].toLowerCase();
    return recipes.where((recipe) {
      final recipeTags = (recipe['tags'] as List)
          .map((t) => t.toString().toLowerCase())
          .toList();
      return recipeTags.any((t) => t.contains(selectedTag) || selectedTag.contains(t));
    }).toList();
  }

  void onTagSelected(int index) {
    selectedTagIndex.value = index;
  }
}
