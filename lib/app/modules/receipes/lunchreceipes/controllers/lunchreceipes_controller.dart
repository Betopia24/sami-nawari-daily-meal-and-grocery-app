import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import '../../../../../core/utils/app_assets.dart';

class LunchreceipesController extends GetxController {
  final isLoading = true.obs;
  final tags = ['All', 'Light', 'Quick', 'Hearty', 'Salads'];
  final selectedTagIndex = 0.obs;

  final RxList<Map<String, dynamic>> recipes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  /// Fetches recipes from backend API for lunch category
  Future<void> fetchRecipes() async {
    isLoading.value = true;
    try {
      // 1. Fetch from /foods/recipe/LUNCH
      final response = await NetworkCaller.getRequest('${Urls.foodRecipes}/LUNCH');
      List<Map<String, dynamic>> parsedList = [];

      if (response.isSuccess && response.responseData != null) {
        parsedList = _parseRecipeItems(response.responseData);
      }

      // 2. If empty, check /foods?category=LUNCH
      if (parsedList.isEmpty) {
        final foodsResponse = await NetworkCaller.getRequest(
          Urls.foods,
          queryParameters: {'category': 'LUNCH'},
        );
        if (foodsResponse.isSuccess && foodsResponse.responseData != null) {
          parsedList = _parseRecipeItems(foodsResponse.responseData);
        }
      }

      if (parsedList.isNotEmpty) {
        recipes.assignAll(parsedList);
      } else {
        recipes.assignAll(_fallbackLunchRecipes);
      }
    } catch (e) {
      debugPrint('Error fetching lunch recipes: $e');
      recipes.assignAll(_fallbackLunchRecipes);
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
            tagsList = ['Quick', 'Hearty'];
          }

          return {
            'id': map['id']?.toString() ?? '',
            'imagePath': imgList.isNotEmpty
                ? imgList.first
                : AppAssets.homeLunchCardImage,
            'tags': tagsList,
            'title': map['name']?.toString() ?? 'Recipe',
            'time': map['preparationTime']?.toString() ?? '20 min',
            'calories': map['calories']?.toString() ?? '420 kcal',
            'rating': (map['rating'] as num?)?.toDouble() ?? 4.8,
          };
        }).toList();
      }
    } catch (e) {
      debugPrint('Error parsing lunch recipe items: $e');
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

  static final List<Map<String, dynamic>> _fallbackLunchRecipes = [
    {
      'id': 'lunch_1',
      'imagePath': AppAssets.homeLunchCardImage,
      'tags': ['Quick', 'Light'],
      'title': 'Thai Green Curry Bowl',
      'time': '25 min',
      'calories': '450 kcal',
      'rating': 4.8,
    },
    {
      'id': 'lunch_2',
      'imagePath': AppAssets.homeBreakfastCardImage,
      'tags': ['Hearty', 'Quick'],
      'title': 'Grilled Chicken Caesar Wrap',
      'time': '15 min',
      'calories': '380 kcal',
      'rating': 4.7,
    },
    {
      'id': 'lunch_3',
      'imagePath': AppAssets.homeDinnerCardImage,
      'tags': ['Salads', 'Light'],
      'title': 'Mediterranean Quinoa Salad',
      'time': '20 min',
      'calories': '320 kcal',
      'rating': 4.9,
    },
  ];
}
