import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../../../../core/utils/app_assets.dart';

class BreakfastreceipesController extends GetxController {
  final isLoading = true.obs;
  final tags = ['All', 'Healthy', 'Quick', 'Traditional', 'High Protein'];
  final selectedTagIndex = 0.obs;

  final RxList<Map<String, dynamic>> recipes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  /// Fetches recipes from backend API for breakfast category
  Future<void> fetchRecipes() async {
    isLoading.value = true;
    try {
      // 1. Fetch from /foods/recipe/BREAKFAST
      final response = await NetworkCaller.getRequest('${Urls.foodRecipes}/BREAKFAST');
      List<Map<String, dynamic>> parsedList = [];

      if (response.isSuccess && response.responseData != null) {
        parsedList = _parseRecipeItems(response.responseData);
      }

      // 2. If empty, check /foods?category=BREAKFAST
      if (parsedList.isEmpty) {
        final foodsResponse = await NetworkCaller.getRequest(
          Urls.foods,
          queryParameters: {'category': 'BREAKFAST'},
        );
        if (foodsResponse.isSuccess && foodsResponse.responseData != null) {
          parsedList = _parseRecipeItems(foodsResponse.responseData);
        }
      }

      // 3. If still empty, check all /foods from server
      if (parsedList.isEmpty) {
        final allFoodsResponse = await NetworkCaller.getRequest(Urls.foods);
        if (allFoodsResponse.isSuccess && allFoodsResponse.responseData != null) {
          parsedList = _parseRecipeItems(allFoodsResponse.responseData);
        }
      }

      if (parsedList.isNotEmpty) {
        recipes.assignAll(parsedList);
      } else {
        // Fallback to curated breakfast recipes if server has no items yet
        recipes.assignAll(_fallbackBreakfastRecipes);
      }
    } catch (e) {
      debugPrint('Error fetching breakfast recipes: $e');
      recipes.assignAll(_fallbackBreakfastRecipes);
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
            tagsList = ['Healthy', 'Quick'];
          }

          return {
            'id': map['id']?.toString() ?? '',
            'imagePath': imgList.isNotEmpty
                ? imgList.first
                : AppAssets.homeBreakfastCardImage,
            'tags': tagsList,
            'title': map['name']?.toString() ?? 'Recipe',
            'time': map['preparationTime']?.toString() ?? '15 min',
            'calories': map['calories']?.toString() ?? '380 kcal',
            'rating': (map['rating'] as num?)?.toDouble() ?? 4.8,
          };
        }).toList();
      }
    } catch (e) {
      debugPrint('Error parsing recipe items: $e');
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

  static final List<Map<String, dynamic>> _fallbackBreakfastRecipes = [
    {
      'id': '6a8d6ca9e87759724844e5ec',
      'imagePath': AppAssets.homeBreakfastCardImage,
      'tags': ['High Protein', 'Healthy', 'Quick'],
      'title': 'Avocado Toast with Poached Egg',
      'time': '15 min',
      'calories': '380 kcal',
      'rating': 4.8,
    },
    {
      'id': '6a897de42f4aa7b54cd9298b',
      'imagePath': AppAssets.homeLunchCardImage,
      'tags': ['Traditional', 'Spicy'],
      'title': 'Thai Green Curry',
      'time': '35 min',
      'calories': '520 kcal',
      'rating': 4.7,
    },
    {
      'id': '6a8d6ca9e87759724844e5ec',
      'imagePath': AppAssets.homeDinnerCardImage,
      'tags': ['High Protein'],
      'title': 'Lemon Herb Salmon',
      'time': '25 min',
      'calories': '440 kcal',
      'rating': 4.9,
    },
    {
      'id': '6a897de42f4aa7b54cd9298b',
      'imagePath': AppAssets.homeSnacksCardImage,
      'tags': ['Healthy'],
      'title': 'Mushroom Risotto',
      'time': '45 min',
      'calories': '490 kcal',
      'rating': 4.6,
    },
    {
      'id': '6a8d6ca9e87759724844e5ec',
      'imagePath': AppAssets.homeBreakfastCardImage,
      'tags': ['Quick', 'Healthy'],
      'title': 'Acai Power Bowl',
      'time': '10 min',
      'calories': '310 kcal',
      'rating': 4.8,
    },
    {
      'id': '6a897de42f4aa7b54cd9298b',
      'imagePath': AppAssets.homeLunchCardImage,
      'tags': ['Traditional'],
      'title': 'Shakshuka',
      'time': '30 min',
      'calories': '350 kcal',
      'rating': 4.7,
    },
  ];
}
