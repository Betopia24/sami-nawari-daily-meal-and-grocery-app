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
      if (args['title'] != null && args['title'].toString().isNotEmpty) {
        recipeName.value = args['title'].toString();
      }
      if (args['name'] != null && args['name'].toString().isNotEmpty) {
        recipeName.value = args['name'].toString();
      }
      if (args['imagePath'] != null && args['imagePath'].toString().isNotEmpty) {
        recipeImage.value = args['imagePath'].toString();
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

    // Fetch live data from server for the food ID if available
    final targetId = recipeId.value;
    if (targetId.isNotEmpty) {
      fetchRecipeDetails(targetId);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchRecipeDetails(String id) async {
    if (id.isEmpty) {
      isLoading.value = false;
      return;
    }
    final targetId = id;

    try {
      isLoading.value = true;
      debugPrint('➡️ [ReceipedetailsController] Calling API for foodId: $targetId');
      final response = await NetworkCaller.getRequest('${Urls.foods}/$targetId');

      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data = body is Map<String, dynamic> ? (body['data'] ?? body) : null;

        if (data is Map<String, dynamic>) {
          recipeName.value = data['name']?.toString() ?? recipeName.value;

          final imgs = data['images'];
          if (imgs is List && imgs.isNotEmpty) {
            recipeImage.value = imgs.first.toString();
          }

          final cat = data['category']?.toString();
          final subCat = data['subcategory']?.toString();
          if (cat != null && cat.isNotEmpty) {
            category.value = cat.capitalizeFirst ?? cat;
          }

          final List<String> newTags = [];
          if (subCat != null && subCat.isNotEmpty) {
            newTags.add(subCat.capitalizeFirst ?? subCat);
          }
          if (cat != null && cat.isNotEmpty) {
            newTags.add(cat.capitalizeFirst ?? cat);
          }
          if (newTags.isEmpty) {
            newTags.addAll(['Healthy', 'Quick', 'Delicious']);
          }
          tags.value = newTags.toSet().take(3).toList();

          if (data['preparationTime'] != null) {
            prepTime.value = data['preparationTime']
                .toString()
                .replaceAll('mins', 'm')
                .replaceAll('min', 'm')
                .replaceAll(' ', '');
          }
          cookTime.value = '10m';

          if (data['calories'] != null) {
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

          // Check if this food is bookmarked by the user
          checkBookmarkStatus(targetId);
        }
      }
    } catch (e) {
      debugPrint('Error fetching recipe details: $e');
    } finally {
      isLoading.value = false;
    }
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

    // 1. Instant optimistic UI update without waiting
    final previousState = isBookmarked.value;
    final newState = !previousState;
    isBookmarked.value = newState;

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

  void addIngredientsToGrocery() {
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
