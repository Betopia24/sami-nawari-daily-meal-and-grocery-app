import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../data/network/network.dart';
import '../../../data/network/url.dart';
import 'groceries_controller.dart';

class InspirationmealdetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString foodId = ''.obs;
  final RxInt activeTab = 0.obs;
  final RxInt servings = 2.obs;
  int baseServings = 2;

  final RxString title = ''.obs;
  final RxString description = ''.obs;
  final RxString imageUrl = ''.obs;
  final RxString imageAsset = ''.obs;
  final RxString difficulty = ''.obs;
  final RxString prepTime = ''.obs;
  final RxDouble price = 0.0.obs;
  final RxBool isBookmarked = false.obs;

  final RxList<Map<String, dynamic>> rawIngredients = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> ingredients = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, String>> methodSteps = <Map<String, String>>[].obs;
  final RxList<String> proTips = <String>[].obs;
  final RxList<String> missingIngredients = <String>[].obs;

  final RxSet<int> completedSteps = <int>{}.obs;
  final RxBool isAddingIngredients = false.obs;

  @override
  void onInit() {
    super.onInit();
    initFromArguments(Get.arguments);
  }

  void initFromArguments([dynamic customArgs]) {
    activeTab.value = 0;
    completedSteps.clear();
    isAddingIngredients.value = false;

    final args = customArgs ?? Get.arguments;
    if (args is Map) {
      foodId.value = (args['id'] ?? args['_id'] ?? args['foodId'] ?? '').toString();

      if (args['title'] != null && args['title'].toString().isNotEmpty) {
        title.value = args['title'].toString();
      }
      if (args['name'] != null && args['name'].toString().isNotEmpty) {
        title.value = args['name'].toString();
      }
      if (args['description'] != null) {
        description.value = args['description'].toString();
      }
      if (args['imageUrl'] != null) {
        imageUrl.value = args['imageUrl'].toString();
      }
      if (args['imageAsset'] != null) {
        imageAsset.value = args['imageAsset'].toString();
      }
      if (args['difficulty'] != null) {
        difficulty.value = args['difficulty'].toString();
      }
      if (args['prepTime'] != null) {
        prepTime.value = args['prepTime'].toString();
      }
      if (args['servings'] is int) {
        servings.value = args['servings'] as int;
        baseServings = servings.value;
      }

      if (args['ingredients'] is List) {
        rawIngredients.value = (args['ingredients'] as List).map((e) {
          if (e is Map) {
            return {
              'name': (e['name'] ?? '').toString(),
              'baseQuantity': (e['quantity'] as num?)?.toDouble() ?? 1.0,
              'unit': (e['unit'] ?? '').toString(),
              'icon': (e['icon'] ?? 'assets/emojis/olive_emoji.png').toString(),
              'inPantry': e['inPantry'] ?? false,
            };
          }
          return <String, dynamic>{};
        }).where((m) => m.isNotEmpty).toList();

        _recalculateIngredients();
      }

      if (args['methodSteps'] is List) {
        methodSteps.value = List<Map<String, String>>.from(
          (args['methodSteps'] as List).map(
            (e) => e is Map
                ? e.map(
                    (k, v) => MapEntry(k.toString(), v.toString()),
                  )
                : <String, String>{},
          ),
        );
      }

      if (args['proTips'] is List) {
        proTips.value = List<String>.from(
          (args['proTips'] as List).map((e) => e.toString()),
        );
      }

      if (args['missingIngredients'] is List) {
        missingIngredients.value = List<String>.from(
          (args['missingIngredients'] as List).map((e) => e.toString()),
        );
      }

      if (args['rawFood'] is Map) {
        _populateFromFoodData(Map<String, dynamic>.from(args['rawFood'] as Map));
      }
    }

    // Call live API for detailed food data and bookmark status
    if (foodId.value.isNotEmpty) {
      fetchFoodDetails(foodId.value);
    }
  }

  /// Fetches food details directly from backend API: GET /foods/:id
  Future<void> fetchFoodDetails(String targetId) async {
    final id = targetId.trim();
    if (id.isEmpty) return;

    final isMongoId = RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(id);
    if (!isMongoId) return;

    isLoading.value = true;
    try {
      debugPrint('➡️ [InspirationmealdetailsController] Calling GET ${Urls.foods}/$id');
      final response = await NetworkCaller.getRequest('${Urls.foods}/$id');
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data = body is Map<String, dynamic> ? (body['data'] ?? body) : null;
        if (data is Map<String, dynamic>) {
          _populateFromFoodData(data);
        }
      }
      checkBookmarkStatus(id);
    } catch (e) {
      debugPrint('Error fetching food details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFromFoodData(Map<String, dynamic> data) {
    if (data['name'] != null && data['name'].toString().isNotEmpty) {
      title.value = data['name'].toString();
    }
    if (data['description'] != null && data['description'].toString().isNotEmpty) {
      description.value = data['description'].toString();
    }
    final imgs = data['images'];
    if (imgs is List && imgs.isNotEmpty) {
      imageUrl.value = imgs.first.toString();
    } else if (data['image'] != null) {
      imageUrl.value = data['image'].toString();
    }

    if (data['preparationTime'] != null) {
      prepTime.value = data['preparationTime'].toString();
    }

    final cat = (data['category'] ?? '').toString();
    final subCat = (data['subcategory'] ?? '').toString();
    if (subCat.isNotEmpty) {
      difficulty.value = subCat.capitalizeFirst ?? subCat;
    } else if (cat.isNotEmpty) {
      difficulty.value = cat.capitalizeFirst ?? cat;
    }

    if (data['price'] != null) {
      price.value = (data['price'] as num?)?.toDouble() ?? 0.0;
    }

    // Ingredients parsing with base quantity for servings scaling
    final ingList = data['ingredients'];
    if (ingList is List && ingList.isNotEmpty) {
      rawIngredients.value = ingList.map((item) {
        if (item is Map) {
          final ingName = (item['name'] ?? '').toString();
          final baseQty = (item['quantity'] as num?)?.toDouble() ?? 1.0;
          final unit = (item['unit'] ?? '').toString();
          return {
            'name': ingName,
            'baseQuantity': baseQty,
            'unit': unit,
            'icon': 'assets/emojis/olive_emoji.png',
            'inPantry': false,
          };
        }
        return <String, dynamic>{};
      }).where((m) => m.isNotEmpty).toList();

      _updatePantryMatches();
    }

    // Method steps: only real steps from API (no dummy data)
    final List<Map<String, String>> steps = [];
    final rawInst = data['instructions'] ??
        data['recipe']?['instructions'] ??
        data['steps'] ??
        data['method'];
    if (rawInst is List) {
      for (var inst in rawInst) {
        if (inst is Map) {
          steps.add({
            'title': (inst['title'] ?? 'Step ${steps.length + 1}').toString(),
            'description': (inst['description'] ?? inst['step'] ?? '').toString(),
          });
        } else if (inst is String && inst.trim().isNotEmpty) {
          steps.add({
            'title': 'Step ${steps.length + 1}',
            'description': inst.trim(),
          });
        }
      }
    }
    methodSteps.value = steps;

    // Pro Tips: only real tips from API (no dummy data)
    final List<String> tips = [];
    final rawTips = data['proTips'] ?? data['tips'];
    if (rawTips is List) {
      for (var tip in rawTips) {
        if (tip != null && tip.toString().trim().isNotEmpty) {
          tips.add(tip.toString().trim());
        }
      }
    }
    proTips.value = tips;
  }

  void _updatePantryMatches() {
    List<String> pantry = [];
    if (Get.isRegistered<GroceriesController>()) {
      final gc = Get.find<GroceriesController>();
      pantry = [
        ...gc.pendingItems.map((i) => i.title.toLowerCase().trim()),
        ...gc.recentlyUsedItems.map((i) => i.title.toLowerCase().trim()),
      ];
    }

    final missing = <String>[];
    final updatedRaw = <Map<String, dynamic>>[];

    for (final raw in rawIngredients) {
      final name = (raw['name'] ?? '').toString().trim();
      final isMatch = pantry.any(
        (p) =>
            p.isNotEmpty &&
            (p.contains(name.toLowerCase()) || name.toLowerCase().contains(p)),
      );
      if (!isMatch && name.isNotEmpty) {
        missing.add(name);
      }
      final copy = Map<String, dynamic>.from(raw);
      copy['inPantry'] = isMatch;
      updatedRaw.add(copy);
    }

    rawIngredients.value = updatedRaw;
    missingIngredients.value = missing;
    _recalculateIngredients();
  }

  void _recalculateIngredients() {
    if (rawIngredients.isEmpty) {
      ingredients.value = [];
      return;
    }
    final scale = servings.value / (baseServings > 0 ? baseServings : 2);
    final updated = <Map<String, dynamic>>[];
    for (final raw in rawIngredients) {
      final baseQty = (raw['baseQuantity'] as num?)?.toDouble() ?? 1.0;
      final newQty = (baseQty * scale);
      final qtyStr = newQty == newQty.roundToDouble()
          ? newQty.toInt().toString()
          : newQty.toStringAsFixed(1);
      final unit = (raw['unit'] ?? '').toString();
      updated.add({
        'name': raw['name'] ?? '',
        'amount': '$qtyStr $unit'.trim(),
        'icon': raw['icon'] ?? 'assets/emojis/olive_emoji.png',
        'inPantry': raw['inPantry'] ?? false,
      });
    }
    ingredients.value = updated;
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

  void toggleStep(int index) {
    if (completedSteps.contains(index)) {
      completedSteps.remove(index);
    } else {
      completedSteps.add(index);
    }
  }

  Future<void> checkBookmarkStatus(String id) async {
    try {
      final response = await NetworkCaller.getRequest(Urls.bookmarks);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data = body is Map ? (body['data'] ?? body) : body;
        if (data is List) {
          final exists = data.any((item) {
            if (item is Map) {
              final bId = item['id']?.toString() ?? item['foodId']?.toString();
              return bId == id;
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
    final targetId = foodId.value;
    if (targetId.isEmpty) return;

    final prev = isBookmarked.value;
    isBookmarked.value = !prev;

    NetworkCaller.postRequest(
      Urls.toggleBookmark,
      body: {'foodId': targetId},
    ).then((response) {
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data = body is Map ? (body['data'] ?? body) : null;
        if (data is Map && data.containsKey('bookmarked')) {
          isBookmarked.value = data['bookmarked'] == true;
        }
      } else {
        isBookmarked.value = prev;
      }
    }).catchError((_) {
      isBookmarked.value = prev;
    });
  }

  /// Adds missing ingredients for this meal directly to user's Grocery List
  Future<void> addMissingIngredientsToGrocery() async {
    if (missingIngredients.isEmpty) {
      Get.snackbar(
        'Ingredients Ready',
        'All ingredients for this meal are already in your pantry!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isAddingIngredients.value = true;

      // 1. Find or create a target grocery list
      String targetListId = '';
      final listsResponse = await NetworkCaller.getRequest(Urls.grocery);
      if (listsResponse.isSuccess && listsResponse.responseData != null) {
        final rawData = listsResponse.responseData['data'];
        if (rawData is List && rawData.isNotEmpty) {
          final first = rawData.first as Map<String, dynamic>;
          targetListId = first['id']?.toString() ?? '';
        }
      }

      if (targetListId.isEmpty) {
        final createResponse = await NetworkCaller.postRequest(
          Urls.grocery,
          body: {
            'name': 'My Grocery List',
            'description': 'Items added from AI Meal Inspiration',
          },
        );
        if (createResponse.isSuccess && createResponse.responseData != null) {
          final data = createResponse.responseData['data'];
          if (data is Map) {
            targetListId = data['id']?.toString() ?? '';
          }
        }
      }

      if (targetListId.isNotEmpty) {
        int added = 0;
        for (final item in missingIngredients) {
          final addRes = await NetworkCaller.postRequest(
            Urls.groceryItem(targetListId),
            body: {
              'name': item,
              'quantity': 1,
              'unit': 'pcs',
              'category': 'OTHER',
              'priority': 'MEDIUM',
              'notes': 'Added from AI Meal Inspiration: ${title.value}',
            },
          );
          if (addRes.isSuccess) added++;
        }

        if (Get.isRegistered<GroceriesController>()) {
          Get.find<GroceriesController>().fetchGroceryLists();
        }

        Get.snackbar(
          'Grocery Updated',
          'Successfully added $added missing ingredient(s) to your grocery list!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not find or create a grocery list. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error adding missing ingredients: $e');
    } finally {
      isAddingIngredients.value = false;
    }
  }
}
