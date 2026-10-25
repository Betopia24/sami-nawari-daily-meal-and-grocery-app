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
  final recipeName = 'Avocado Toast with Poached Egg'.obs;
  final recipeImage = AppAssets.homeBreakfastCardImage.obs;
  final category = 'American'.obs;
  final rating = 4.8.obs;
  final reviewCount = '(2,340)'.obs;
  final tags = <String>['High Protein', 'Healthy', 'Quick'].obs;
  final prepTime = '5m'.obs;
  final cookTime = '10m'.obs;
  final calories = '380'.obs;

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
      recipeId.value = args['id']?.toString() ?? '';
      if (args['title'] != null && args['title'].toString().isNotEmpty) {
        recipeName.value = args['title'].toString();
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

    // Always fetch live data from server for the food ID
    final targetId = (recipeId.value.isNotEmpty && recipeId.value.length == 24)
        ? recipeId.value
        : '6a8d6ca9e87759724844e5ec';
    fetchRecipeDetails(targetId);
  }

  Future<void> fetchRecipeDetails(String id) async {
    final targetId = (id.length == 24) ? id : '6a8d6ca9e87759724844e5ec';

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
          newTags.addAll(['Healthy', 'Quick', 'High Protein']);
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
          } else {
            calories.value = '380';
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
        } else {
          _loadFallbackData('breakfast_1');
        }
      } else {
        _loadFallbackData('breakfast_1');
      }
    } catch (e) {
      debugPrint('Error fetching recipe details: $e');
      _loadFallbackData('breakfast_1');
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFallbackData(String id) {
    final recipe = _curatedRecipes[id] ?? _curatedRecipes['breakfast_1']!;
    recipeName.value = recipe['title'] as String;
    recipeImage.value = recipe['imagePath'] as String;
    category.value = recipe['category'] as String;
    rating.value = (recipe['rating'] as num).toDouble();
    reviewCount.value = recipe['reviewCount'] as String;
    tags.value = List<String>.from(recipe['tags'] as List);
    prepTime.value = recipe['prepTime'] as String;
    cookTime.value = recipe['cookTime'] as String;
    calories.value = recipe['calories'] as String;
    baseServings = recipe['baseServings'] as int? ?? 2;
    servings.value = baseServings;

    rawIngredients.value = List<Map<String, dynamic>>.from(
      (recipe['ingredients'] as List).map((i) => Map<String, dynamic>.from(i as Map)),
    );
    _recalculateIngredients();

    methodSteps.value = List<Map<String, String>>.from(
      (recipe['methodSteps'] as List).map(
        (s) => Map<String, String>.from((s as Map).map((k, v) => MapEntry(k.toString(), v.toString()))),
      ),
    );

    proTips.value = List<String>.from(recipe['proTips'] as List);
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
    final targetFoodId = (recipeId.value.length == 24)
        ? recipeId.value
        : '6a8d6ca9e87759724844e5ec';

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

  // Curated fallback database for rich offline/preview experience
  static final Map<String, Map<String, dynamic>> _curatedRecipes = {
    'breakfast_1': {
      'title': 'Avocado Toast with Poached Egg',
      'imagePath': AppAssets.homeBreakfastCardImage,
      'category': 'American',
      'rating': 4.8,
      'reviewCount': '(2,340)',
      'tags': ['High Protein', 'Healthy', 'Quick'],
      'prepTime': '5m',
      'cookTime': '10m',
      'calories': '380',
      'baseServings': 2,
      'ingredients': [
        {'name': 'Sourdough bread', 'baseQuantity': 2.0, 'unit': 'slices'},
        {'name': 'Ripe avocado', 'baseQuantity': 1.0, 'unit': 'large'},
        {'name': 'Eggs', 'baseQuantity': 2.0, 'unit': 'large'},
        {'name': 'Cherry tomatoes', 'baseQuantity': 6.0, 'unit': 'pieces'},
        {'name': 'Lemon juice', 'baseQuantity': 1.0, 'unit': 'tbsp'},
        {'name': 'Red pepper flakes', 'baseQuantity': 0.5, 'unit': 'tsp'},
        {'name': 'Sea salt', 'baseQuantity': 0.25, 'unit': 'tsp'},
        {'name': 'Fresh chives', 'baseQuantity': 1.0, 'unit': 'tbsp'},
      ],
      'methodSteps': [
        {
          'title': 'Toast the bread',
          'description':
              'Toast sourdough bread until golden and crispy on both sides. A good toast should have crunch but still be chewy inside.',
        },
        {
          'title': 'Mash the avocado',
          'description':
              'Halve the avocado and scoop into a bowl. Add lemon juice, a pinch of salt, and red pepper flakes. Mash with a fork — keep it slightly chunky for texture.',
        },
        {
          'title': 'Prepare for poaching',
          'description':
              'Bring 3 inches of water to a gentle simmer in a wide saucepan. Add a small splash of white vinegar — this helps the egg white hold together.',
        },
        {
          'title': 'Poach the eggs',
          'description':
              'Crack each egg into a small cup. Create a gentle whirlpool with a spoon, then slide the egg gently into the center. Cook 3 minutes for a runny yolk.',
        },
        {
          'title': 'Assemble',
          'description':
              'Spread avocado mixture generously over the toast. Use a slotted spoon to lift the egg out and blot with a paper towel, then place on top.',
        },
        {
          'title': 'Garnish & Serve',
          'description':
              'Top with halved cherry tomatoes, snipped chives, and a pinch of flaky sea salt. Serve immediately.',
        },
      ],
      'proTips': [
        'Use the freshest eggs possible — older eggs spread more in water.',
        'Add a drop of white vinegar to the poaching water to keep the whites together.',
        'For perfectly ripe avocado: the skin should yield slightly when pressed.',
        'Toast the bread just before serving so it stays crispy.',
      ],
    },
    'breakfast_2': {
      'title': 'Thai Green Curry',
      'imagePath': AppAssets.homeLunchCardImage,
      'category': 'Thai',
      'rating': 4.7,
      'reviewCount': '(1,850)',
      'tags': ['Traditional', 'Spicy'],
      'prepTime': '15m',
      'cookTime': '20m',
      'calories': '520',
      'baseServings': 2,
      'ingredients': [
        {'name': 'Green curry paste', 'baseQuantity': 3.0, 'unit': 'tbsp'},
        {'name': 'Coconut milk', 'baseQuantity': 400.0, 'unit': 'ml'},
        {'name': 'Chicken breast / Tofu', 'baseQuantity': 300.0, 'unit': 'g'},
        {'name': 'Thai eggplant', 'baseQuantity': 100.0, 'unit': 'g'},
        {'name': 'Bamboo shoots', 'baseQuantity': 50.0, 'unit': 'g'},
        {'name': 'Fish sauce', 'baseQuantity': 1.5, 'unit': 'tbsp'},
        {'name': 'Palm sugar', 'baseQuantity': 1.0, 'unit': 'tbsp'},
        {'name': 'Thai basil leaves', 'baseQuantity': 1.0, 'unit': 'handful'},
      ],
      'methodSteps': [
        {
          'title': 'Fry curry paste',
          'description':
              'Heat a spoonful of coconut cream in a wok and fry the green curry paste until fragrant and oil separates.',
        },
        {
          'title': 'Cook protein',
          'description':
              'Add sliced chicken breast and stir-fry until sealed and lightly cooked through.',
        },
        {
          'title': 'Simmer with vegetables',
          'description':
              'Pour in remaining coconut milk, bring to a gentle boil, then add eggplants and bamboo shoots.',
        },
        {
          'title': 'Season and serve',
          'description':
              'Stir in fish sauce and palm sugar. Remove from heat and stir in fresh Thai basil. Serve hot with jasmine rice.',
        },
      ],
      'proTips': [
        'Do not boil coconut milk vigorously or it will separate.',
        'Fresh kaffir lime leaves add authentic citrus depth.',
      ],
    },
    'breakfast_3': {
      'title': 'Lemon Herb Salmon',
      'imagePath': AppAssets.homeDinnerCardImage,
      'category': 'Mediterranean',
      'rating': 4.9,
      'reviewCount': '(3,120)',
      'tags': ['High Protein', 'Healthy'],
      'prepTime': '10m',
      'cookTime': '15m',
      'calories': '440',
      'baseServings': 2,
      'ingredients': [
        {'name': 'Salmon fillets', 'baseQuantity': 2.0, 'unit': 'fillets'},
        {'name': 'Lemon juice & zest', 'baseQuantity': 1.0, 'unit': 'lemon'},
        {'name': 'Fresh dill & parsley', 'baseQuantity': 2.0, 'unit': 'tbsp'},
        {'name': 'Garlic cloves', 'baseQuantity': 2.0, 'unit': 'minced'},
        {'name': 'Olive oil', 'baseQuantity': 1.5, 'unit': 'tbsp'},
        {'name': 'Sea salt & black pepper', 'baseQuantity': 0.5, 'unit': 'tsp'},
      ],
      'methodSteps': [
        {
          'title': 'Season salmon',
          'description':
              'Pat salmon fillets dry with paper towels. Rub with olive oil, minced garlic, lemon zest, salt, and pepper.',
        },
        {
          'title': 'Sear in pan',
          'description':
              'Heat skillet over medium-high heat. Place salmon skin-side down and sear for 4–5 minutes until crispy.',
        },
        {
          'title': 'Finish with butter & herbs',
          'description':
              'Flip gently, squeeze fresh lemon juice and add fresh dill and parsley. Cook for another 3–4 minutes.',
        },
      ],
      'proTips': [
        'Ensure the skillet is nice and hot before placing the fish for crispy skin.',
        'Rest for 2 minutes before serving so juices redistribute.',
      ],
    },
    'breakfast_4': {
      'title': 'Mushroom Risotto',
      'imagePath': AppAssets.homeBreakfastCardImage,
      'category': 'Italian',
      'rating': 4.6,
      'reviewCount': '(980)',
      'tags': ['Healthy', 'Traditional'],
      'prepTime': '15m',
      'cookTime': '30m',
      'calories': '490',
      'baseServings': 2,
      'ingredients': [
        {'name': 'Arborio rice', 'baseQuantity': 200.0, 'unit': 'g'},
        {'name': 'Cremini mushrooms', 'baseQuantity': 250.0, 'unit': 'g'},
        {'name': 'Vegetable broth (warm)', 'baseQuantity': 750.0, 'unit': 'ml'},
        {'name': 'Shallot & garlic', 'baseQuantity': 2.0, 'unit': 'chopped'},
        {'name': 'Parmesan cheese', 'baseQuantity': 40.0, 'unit': 'g'},
        {'name': 'Butter & olive oil', 'baseQuantity': 2.0, 'unit': 'tbsp'},
      ],
      'methodSteps': [
        {
          'title': 'Sauté mushrooms',
          'description':
              'Cook sliced mushrooms in butter until golden brown and tender. Set half aside for garnish.',
        },
        {
          'title': 'Toast rice',
          'description':
              'In the same pan, sauté shallots and garlic, add Arborio rice, and toast for 2 minutes until translucent around the edges.',
        },
        {
          'title': 'Add broth gradually',
          'description':
              'Add warm broth one ladle at a time, stirring continuously until absorbed before adding the next.',
        },
        {
          'title': 'Fold in cheese',
          'description':
              'Remove from heat, stir in cold butter, grated parmesan, and remaining mushrooms until creamy.',
        },
      ],
      'proTips': [
        'Always keep the broth simmering gently in a saucepan next to the risotto.',
        'Never rinse Arborio rice; surface starch creates the creaminess.',
      ],
    },
    'breakfast_5': {
      'title': 'Acai Power Bowl',
      'imagePath': AppAssets.homeBreakfastCardImage,
      'category': 'Breakfast',
      'rating': 4.8,
      'reviewCount': '(1,420)',
      'tags': ['Quick', 'Healthy'],
      'prepTime': '10m',
      'cookTime': '0m',
      'calories': '320',
      'baseServings': 1,
      'ingredients': [
        {'name': 'Frozen acai puree', 'baseQuantity': 1.0, 'unit': 'pack'},
        {'name': 'Frozen banana', 'baseQuantity': 1.0, 'unit': 'medium'},
        {'name': 'Almond milk', 'baseQuantity': 60.0, 'unit': 'ml'},
        {'name': 'Granola', 'baseQuantity': 30.0, 'unit': 'g'},
        {'name': 'Fresh berries & kiwi', 'baseQuantity': 50.0, 'unit': 'g'},
        {'name': 'Chia seeds & honey', 'baseQuantity': 1.0, 'unit': 'tbsp'},
      ],
      'methodSteps': [
        {
          'title': 'Blend base',
          'description':
              'Blend acai packet, frozen banana, and a splash of almond milk until thick and smooth, like soft-serve ice cream.',
        },
        {
          'title': 'Pour into bowl',
          'description':
              'Transfer the thick puree into a chilled bowl and smooth the surface.',
        },
        {
          'title': 'Arrange toppings',
          'description':
              'Decorate neatly with sliced strawberries, banana coins, blueberries, crunchy granola, and chia seeds.',
        },
        {
          'title': 'Drizzle honey',
          'description':
              'Finish with a light drizzle of pure honey or peanut butter. Enjoy immediately!',
        },
      ],
      'proTips': [
        'Keep liquid to a minimum so the acai bowl stays thick and spoonable.',
        'Freeze your bowl for 10 minutes beforehand to keep it cold longer.',
      ],
    },
  };
}
