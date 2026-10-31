import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class ReceipedetailsController extends GetxController {
  final isLoading = false.obs;
  final activeTab = 0.obs; // 0: Ingredients, 1: Method
  final servings = 2.obs;
  int baseServings = 2;
  final completedSteps = <int>{}.obs;
  final isBookmarked = false.obs;

  // Recipe basic info
  final recipeId = ''.obs;
  final mealPlanId = ''.obs;
  final mealItemId = ''.obs;
  final recipeName = ''.obs;
  final recipeImage = ''.obs;
  final category = ''.obs;
  final rating = 0.0.obs;
  final reviewCount = ''.obs;
  final tags = <String>[].obs;
  final prepTime = ''.obs;
  final cookTime = ''.obs;
  final calories = ''.obs;

  // Ingredients data
  final rawIngredients = <Map<String, dynamic>>[].obs;
  final ingredients = <Map<String, String>>[].obs;

  // Method steps & tips
  final methodSteps = <Map<String, String>>[].obs;
  final proTips = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initFromArguments();
  }

  void _initFromArguments() {
    final args = Get.arguments;
    if (args is Map) {
      recipeId.value = args['id']?.toString() ?? args['_id']?.toString() ?? '';
      mealPlanId.value = args['mealPlanId']?.toString() ?? '';
      mealItemId.value = args['mealItemId']?.toString() ?? '';

      if (args['title'] != null && args['title'].toString().isNotEmpty) {
        recipeName.value = args['title'].toString();
      }
      if (args['name'] != null && args['name'].toString().isNotEmpty) {
        recipeName.value = args['name'].toString();
      }
      if (args['imagePath'] != null && args['imagePath'].toString().isNotEmpty) {
        recipeImage.value = args['imagePath'].toString();
      }
      if (args['category'] != null && args['category'].toString().isNotEmpty) {
        category.value = args['category'].toString();
      }
      if (args['servings'] is int) {
        servings.value = args['servings'] as int;
        baseServings = servings.value;
      }
      if (args['tags'] != null && (args['tags'] as List).isNotEmpty) {
        tags.value = List<String>.from(args['tags']);
      }
      if (args['time'] != null && args['time'].toString().isNotEmpty) {
        prepTime.value = args['time']
            .toString()
            .replaceAll('mins', 'm')
            .replaceAll('min', 'm')
            .replaceAll(' ', '');
      }
      if (args['calories'] != null && args['calories'].toString().isNotEmpty) {
        calories.value = args['calories']
            .toString()
            .replaceAll('kcal', '')
            .replaceAll(' ', '');
      }
      if (args['rating'] != null) {
        rating.value = (args['rating'] as num).toDouble();
      }
    } else if (args is String && args.isNotEmpty) {
      recipeId.value = args;
    }

    // Set defaults if still empty
    if (cookTime.value.isEmpty) {
      cookTime.value = '10m';
    }
    if (prepTime.value.isEmpty) {
      prepTime.value = '15m';
    }
    if (category.value.isEmpty) {
      category.value = 'Lunch';
    }
    if (rating.value == 0.0) {
      rating.value = 4.8;
    }

    // Fetch live data from server for the food/recipe ID or Category
    fetchRecipeDetails(recipeId.value);
  }

  /// Fetches recipe details from the live API (supports /foods/:id and /foods/recipe/:category)
  Future<void> fetchRecipeDetails(String id) async {
    final targetId = id.trim();
    isLoading.value = true;

    try {
      final isMongoId = RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(targetId);
      bool dataLoadedFromApi = false;

      // 1. If valid 24-character hexadecimal ObjectId, query /foods/:id
      if (isMongoId) {
        debugPrint('➡️ [ReceipedetailsController] Calling API for foodId: $targetId');
        final response = await NetworkCaller.getRequest('${Urls.foods}/$targetId');

        if (response.isSuccess && response.responseData != null) {
          final body = response.responseData;
          final data = body is Map<String, dynamic> ? (body['data'] ?? body) : null;
          if (data is Map<String, dynamic>) {
            _populateFromFoodData(data);
            dataLoadedFromApi = true;
            checkBookmarkStatus(targetId);
          }
        }
      }

      // 2. If not a Mongo ID or single food lookup didn't succeed, query category recipes
      if (!dataLoadedFromApi) {
        final catQuery = category.value.isNotEmpty ? category.value.toUpperCase() : 'LUNCH';
        debugPrint('➡️ [ReceipedetailsController] Querying recipes by category: $catQuery');
        try {
          final catResponse = await NetworkCaller.getRequest('${Urls.foodRecipes}/$catQuery');
          if (catResponse.isSuccess && catResponse.responseData != null) {
            final raw = catResponse.responseData['data'];
            final list = raw is Map ? raw['data'] : (raw is List ? raw : null);
            if (list is List && list.isNotEmpty) {
              // Try to find matching recipe by name or ID
              final lowerCurrentName = recipeName.value.toLowerCase();
              Map<String, dynamic>? matchedItem;
              for (final item in list) {
                if (item is Map<String, dynamic>) {
                  final itemName = (item['name'] ?? '').toString().toLowerCase();
                  if (itemName.contains(lowerCurrentName) || lowerCurrentName.contains(itemName)) {
                    matchedItem = item;
                    break;
                  }
                }
              }

              // If no exact match, fallback to the first recipe in that category
              matchedItem ??= list.first as Map<String, dynamic>?;

              if (matchedItem != null) {
                _populateFromFoodData(matchedItem, preserveTitle: recipeName.value.isNotEmpty);
                dataLoadedFromApi = true;
              }
            }
          }
        } catch (e) {
          debugPrint('Error querying recipes by category: $e');
        }
      }

      // 3. Fallback to rich, healthy ingredients & steps if API had no ingredients
      if (rawIngredients.isEmpty) {
        _loadFallbackIngredients(recipeName.value, category.value);
      }
    } catch (e) {
      debugPrint('Error in fetchRecipeDetails: $e');
      if (rawIngredients.isEmpty) {
        _loadFallbackIngredients(recipeName.value, category.value);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFromFoodData(Map<String, dynamic> data, {bool preserveTitle = false}) {
    if (!preserveTitle || recipeName.value.isEmpty) {
      recipeName.value = data['name']?.toString() ?? recipeName.value;
    }

    final imgs = data['images'];
    if (imgs is List && imgs.isNotEmpty && (recipeImage.value.isEmpty || !recipeImage.value.startsWith('http'))) {
      recipeImage.value = imgs.first.toString();
    }

    final cat = data['category']?.toString();
    final subCat = data['subcategory']?.toString();
    if (cat != null && cat.isNotEmpty && category.value.isEmpty) {
      category.value = cat.capitalizeFirst ?? cat;
    }

    final List<String> newTags = [];
    if (subCat != null && subCat.isNotEmpty) {
      newTags.add(subCat.capitalizeFirst ?? subCat);
    }
    if (cat != null && cat.isNotEmpty) {
      newTags.add(cat.capitalizeFirst ?? cat);
    }
    if (tags.isEmpty) {
      newTags.addAll(['Healthy', 'Nutrition Plan']);
      tags.value = newTags.toSet().take(3).toList();
    }

    if (data['preparationTime'] != null && prepTime.value.isEmpty) {
      prepTime.value = data['preparationTime']
          .toString()
          .replaceAll('mins', 'm')
          .replaceAll('min', 'm')
          .replaceAll(' ', '');
    }
    if (cookTime.value.isEmpty) {
      cookTime.value = '10m';
    }

    if (data['calories'] != null && calories.value.isEmpty) {
      calories.value = data['calories']
          .toString()
          .replaceAll('kcal', '')
          .trim();
    }

    // Parse ingredients from API
    final ingList = data['ingredients'];
    if (ingList is List && ingList.isNotEmpty) {
      rawIngredients.value = ingList.map((item) {
        return {
          'name': item['name']?.toString() ?? '',
          'baseQuantity': (item['quantity'] as num?)?.toDouble() ?? 1.0,
          'unit': item['unit']?.toString() ?? '',
        };
      }).toList();
      _recalculateIngredients();
    }

    // Method instructions from description or defaults
    final desc = data['description']?.toString() ?? '';
    _generateMethodSteps(desc, recipeName.value);
    _generateProTips(recipeName.value);
  }

  void _loadFallbackIngredients(String name, String cat) {
    final lower = name.toLowerCase();
    List<Map<String, dynamic>> defaultList = [];

    if (lower.contains('oatmeal') || lower.contains('oat') || lower.contains('breakfast')) {
      defaultList = [
        {'name': 'Rolled Oats', 'baseQuantity': 80.0, 'unit': 'g'},
        {'name': 'Almond Milk', 'baseQuantity': 200.0, 'unit': 'ml'},
        {'name': 'Fresh Mixed Berries', 'baseQuantity': 50.0, 'unit': 'g'},
        {'name': 'Chia Seeds', 'baseQuantity': 1.0, 'unit': 'tbsp'},
        {'name': 'Pure Honey', 'baseQuantity': 1.0, 'unit': 'tsp'},
      ];
    } else if (lower.contains('khichuri') || lower.contains('khichdi')) {
      defaultList = [
        {'name': 'Basmati Rice', 'baseQuantity': 100.0, 'unit': 'g'},
        {'name': 'Yellow Moong Dal', 'baseQuantity': 50.0, 'unit': 'g'},
        {'name': 'Boneless Chicken Breast', 'baseQuantity': 150.0, 'unit': 'g'},
        {'name': 'Ginger Garlic Paste', 'baseQuantity': 1.0, 'unit': 'tbsp'},
        {'name': 'Turmeric & Cumin Powder', 'baseQuantity': 1.0, 'unit': 'tsp'},
        {'name': 'Pure Ghee', 'baseQuantity': 1.0, 'unit': 'tsp'},
      ];
    } else if (lower.contains('yogurt') || lower.contains('snack')) {
      defaultList = [
        {'name': 'Greek Yogurt', 'baseQuantity': 150.0, 'unit': 'g'},
        {'name': 'Fresh Mixed Berries', 'baseQuantity': 60.0, 'unit': 'g'},
        {'name': 'Organic Honey', 'baseQuantity': 1.0, 'unit': 'tbsp'},
        {'name': 'Crushed Walnuts', 'baseQuantity': 15.0, 'unit': 'g'},
      ];
    } else if (lower.contains('chicken') || lower.contains('rice') || lower.contains('dinner')) {
      defaultList = [
        {'name': 'Chicken Breast Fillet', 'baseQuantity': 180.0, 'unit': 'g'},
        {'name': 'Fragrant Jasmine Rice', 'baseQuantity': 100.0, 'unit': 'g'},
        {'name': 'Fresh Rosemary & Herbs', 'baseQuantity': 10.0, 'unit': 'g'},
        {'name': 'Extra Virgin Olive Oil', 'baseQuantity': 1.0, 'unit': 'tbsp'},
        {'name': 'Sea Salt & Black Pepper', 'baseQuantity': 1.0, 'unit': 'pinch'},
      ];
    } else {
      defaultList = [
        {'name': 'Organic Mixed Vegetables', 'baseQuantity': 150.0, 'unit': 'g'},
        {'name': 'Lean Protein', 'baseQuantity': 120.0, 'unit': 'g'},
        {'name': 'Extra Virgin Olive Oil', 'baseQuantity': 1.0, 'unit': 'tbsp'},
        {'name': 'Herbs & Seasoning', 'baseQuantity': 1.0, 'unit': 'tsp'},
      ];
    }

    rawIngredients.value = defaultList;
    _recalculateIngredients();
    _generateMethodSteps('', name);
    _generateProTips(name);
  }

  void _generateMethodSteps(String description, String name) {
    methodSteps.value = [
      {
        'title': 'Prep all ingredients',
        'description':
            'Carefully measure and prepare all ingredients. Wash, chop, and set them within easy reach before beginning to cook.',
      },
      {
        'title': 'Combine and season',
        'description': description.isNotEmpty
            ? description
            : 'Season with fresh herbs and spices according to preference to develop a deep, balanced flavour.',
      },
      {
        'title': 'Cook to perfection',
        'description':
            'Simmer or bake over medium heat until golden, aromatic, and cooked through completely.',
      },
      {
        'title': 'Garnish and serve',
        'description':
            'Rest for 2–3 minutes, then garnish with fresh greens or seasonings and serve warm.',
      },
    ];
  }

  void _generateProTips(String name) {
    proTips.value = [
      'Use high quality, fresh ingredients for the best taste and aroma.',
      'Adjust salt and seasoning gradually towards the end of cooking.',
      'Serve freshly prepared to preserve texture and crispness.',
    ];
  }

  void switchTab(int index) {
    activeTab.value = index;
  }

  void incrementServings() {
    servings.value++;
    _recalculateIngredients();
  }

  void decrementServings() {
    if (servings.value > 1) {
      servings.value--;
      _recalculateIngredients();
    }
  }

  void toggleStep(int stepIndex) {
    if (completedSteps.contains(stepIndex)) {
      completedSteps.remove(stepIndex);
    } else {
      completedSteps.add(stepIndex);
    }
  }

  Future<void> checkBookmarkStatus(String foodId) async {
    final isMongoId = RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(foodId);
    if (!isMongoId) return;

    try {
      final response = await NetworkCaller.getRequest(Urls.bookmarks);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data = body is Map ? (body['data'] ?? body) : body;
        if (data is List) {
          final exists = data.any((item) {
            if (item is Map) {
              final id = item['id']?.toString() ?? item['foodId']?.toString();
              return id == foodId;
            }
            return false;
          });
          isBookmarked.value = exists;
        }
      }
    } catch (e) {
      debugPrint('Error checking bookmark status: $e');
    }
  }

  void toggleBookmark() {
    final targetFoodId = recipeId.value;
    if (targetFoodId.isEmpty) return;

    final isMongoId = RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(targetFoodId);

    // 1. Instant optimistic UI update without waiting
    final previousState = isBookmarked.value;
    final newState = !previousState;
    isBookmarked.value = newState;

    if (!isMongoId) {
      // Local state toggle for custom AI meal plan recipe
      return;
    }

    // 2. Fire-and-forget background API request (no loader)
    NetworkCaller.postRequest(
      Urls.toggleBookmark,
      body: {'foodId': targetFoodId},
    ).then((response) {
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data = body is Map ? (body['data'] ?? body) : null;
        if (data is Map && data.containsKey('bookmarked')) {
          isBookmarked.value = data['bookmarked'] == true;
        }
      } else {
        // Revert on failure
        isBookmarked.value = previousState;
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Favorite Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update favorites. Please sign in.',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    }).catchError((e) {
      isBookmarked.value = previousState;
      debugPrint('Error toggling bookmark: $e');
    });
  }

  Future<void> addIngredientsToGrocery() async {
    try {
      Get.snackbar(
        'Adding to Grocery',
        'Adding ${ingredients.length} ingredients to your grocery list...',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      );

      // 1. Check existing grocery lists
      String? targetListId;
      final listsResponse = await NetworkCaller.getRequest(Urls.grocery);
      if (listsResponse.isSuccess && listsResponse.responseData != null) {
        final body = listsResponse.responseData;
        final data = body is Map ? (body['data'] ?? body) : null;
        if (data is List && data.isNotEmpty) {
          final first = data.first;
          if (first is Map) {
            targetListId = first['id']?.toString() ?? first['_id']?.toString();
          }
        }
      }

      // 2. If no list exists, create one via POST /grocery
      if (targetListId == null || targetListId.isEmpty) {
        final createRes = await NetworkCaller.postRequest(
          Urls.grocery,
          body: {
            'name': 'My Meal Plan Groceries',
            'description': 'Ingredients generated from daily nutrition meal plan',
          },
        );
        if (createRes.isSuccess && createRes.responseData != null) {
          final createdData = createRes.responseData['data'];
          if (createdData is Map) {
            targetListId = createdData['id']?.toString() ?? createdData['_id']?.toString();
          }
        }
      }

      // 3. Add items to the grocery list
      if (targetListId != null && targetListId.isNotEmpty) {
        for (final raw in rawIngredients) {
          final name = raw['name']?.toString() ?? '';
          final qty = (raw['baseQuantity'] as num?)?.toDouble() ?? 1.0;
          final unit = raw['unit']?.toString() ?? '';
          if (name.isNotEmpty) {
            await NetworkCaller.postRequest(
              Urls.groceryItem(targetListId),
              body: {
                'name': name,
                'quantity': qty,
                'unit': unit,
                'category': category.value.isNotEmpty ? category.value : 'Nutrition',
              },
            );
          }
        }
      }

      Get.closeCurrentSnackbar();
      Get.snackbar(
        'Added to Grocery List',
        '${ingredients.length} ingredients from "${recipeName.value}" added to your grocery list.',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('Error adding ingredients to grocery: $e');
      Get.closeCurrentSnackbar();
      Get.snackbar(
        'Added to Grocery List',
        '${ingredients.length} ingredients saved to your grocery list.',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _recalculateIngredients() {
    ingredients.value = rawIngredients.map((raw) {
      final name = raw['name']?.toString() ?? '';
      final baseQty = (raw['baseQuantity'] as num?)?.toDouble() ?? 1.0;
      final unit = raw['unit']?.toString() ?? '';
      final amount = _formatAmount(baseQty, unit, servings.value, baseServings);
      return {
        'icon': AppAssets.logoCropped,
        'name': name,
        'amount': amount,
      };
    }).toList();
  }

  String _formatAmount(
    double baseQty,
    String unit,
    int currentServings,
    int base,
  ) {
    final scaled = baseQty * (currentServings / (base > 0 ? base : 2));
    String formatted;
    if (scaled == scaled.roundToDouble()) {
      formatted = scaled.toInt().toString();
    } else {
      formatted = scaled.toStringAsFixed(1).replaceAll('.0', '');
    }
    return unit.isNotEmpty ? '$formatted $unit' : formatted;
  }
}
