import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../../../../core/utils/app_assets.dart';

class SnacksreceipesController extends GetxController {
  final isLoading = true.obs;
  final tags = ['All', 'Healthy', 'Quick', 'Sweet', 'Savory'];
  final selectedTagIndex = 0.obs;

  final RxList<Map<String, dynamic>> recipes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  /// Fetches recipes from backend API for snacks category
  Future<void> fetchRecipes() async {
    isLoading.value = true;
    try {
      // 1. Fetch from /foods/recipe/SNACKS
      final response = await NetworkCaller.getRequest('${Urls.foodRecipes}/SNACKS');
      List<Map<String, dynamic>> parsedList = [];

      if (response.isSuccess && response.responseData != null) {
        parsedList = _parseRecipeItems(response.responseData);
      }

      // 2. If empty, check /foods?category=SNACKS
      if (parsedList.isEmpty) {
        final foodsResponse = await NetworkCaller.getRequest(
          Urls.foods,
          queryParameters: {'category': 'SNACKS'},
        );
        if (foodsResponse.isSuccess && foodsResponse.responseData != null) {
          parsedList = _parseRecipeItems(foodsResponse.responseData);
        }
      }

      if (parsedList.isNotEmpty) {
        recipes.assignAll(parsedList);
      } else {
        recipes.assignAll(_fallbackSnacksRecipes);
      }
    } catch (e) {
      debugPrint('Error fetching snacks recipes: $e');
      recipes.assignAll(_fallbackSnacksRecipes);
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
            tagsList = ['Quick', 'Healthy'];
          }

          return {
            'id': map['id']?.toString() ?? '',
            'imagePath': imgList.isNotEmpty
                ? imgList.first
                : AppAssets.homeSnacksCardImage,
            'tags': tagsList,
            'title': map['name']?.toString() ?? 'Recipe',
            'time': map['preparationTime']?.toString() ?? '10 min',
            'calories': map['calories']?.toString() ?? '250 kcal',
            'rating': (map['rating'] as num?)?.toDouble() ?? 4.7,
          };
        }).toList();
      }
    } catch (e) {
      debugPrint('Error parsing snacks recipe items: $e');
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

  static final List<Map<String, dynamic>> _fallbackSnacksRecipes = [
    {
      'id': 'snack_1',
      'imagePath': AppAssets.homeSnacksCardImage,
      'tags': ['Quick', 'Healthy'],
      'title': 'Greek Yogurt Berry Parfait',
      'time': '10 min',
      'calories': '220 kcal',
      'rating': 4.8,
    },
    {
      'id': 'snack_2',
      'imagePath': AppAssets.homeBreakfastCardImage,
      'tags': ['Sweet', 'Quick'],
      'title': 'Honey Oat Energy Bites',
      'time': '15 min',
      'calories': '180 kcal',
      'rating': 4.7,
    },
    {
      'id': 'snack_3',
      'imagePath': AppAssets.homeLunchCardImage,
      'tags': ['Savory', 'Healthy'],
      'title': 'Crispy Roasted Chickpeas',
      'time': '25 min',
      'calories': '210 kcal',
      'rating': 4.6,
    },
  ];
}
