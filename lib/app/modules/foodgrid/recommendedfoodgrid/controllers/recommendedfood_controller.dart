import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/models/food_item_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../../core/utils/app_assets.dart';

class RecommendedfoodController extends GetxController {
  final isLoading = false.obs;
  final foods = <FoodItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedFoods();
  }

  /// Fetches recommended food items from the backend API.
  /// Falls back gracefully to server /foods and curated items if needed.
  Future<void> fetchRecommendedFoods() async {
    try {
      isLoading.value = true;

      // 1. First attempt: AI recommendations endpoint
      try {
        final aiResponse = await NetworkCaller.postRequest(
          Urls.aiRecommendFoods,
          body: {'limit': 20},
        );
        if (aiResponse.isSuccess && aiResponse.responseData != null) {
          final list = _parseFoodList(aiResponse.responseData);
          if (list.isNotEmpty) {
            foods.assignAll(_combineWithFallback(list));
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
          foods.assignAll(_combineWithFallback(list));
          return;
        }
      }

      // 3. Fallback: curated recommended list
      foods.assignAll(_fallbackRecommendedFoods);
    } catch (e) {
      debugPrint('Error fetching recommended foods: $e');
      foods.assignAll(_fallbackRecommendedFoods);
    } finally {
      isLoading.value = false;
    }
  }

  List<FoodItemModel> _combineWithFallback(List<FoodItemModel> serverList) {
    final existingIds = serverList.map((e) => e.id).toSet();
    final combined = List<FoodItemModel>.from(serverList);
    for (final item in _fallbackRecommendedFoods) {
      if (!existingIds.contains(item.id)) {
        combined.add(item);
      }
    }
    return combined;
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

  static final List<FoodItemModel> _fallbackRecommendedFoods = [
    FoodItemModel(
      id: '6a8d6ca9e87759724844e5ec',
      name: 'Spanakopita',
      description:
          'Authentic Greek spinach pie with fresh herbs and crisp pastry from Maria’s Kitchen.',
      images: [
        'https://res.cloudinary.com/dgk8lgdzb/image/upload/v1787653287/uploads/tkue6iscqbdqq8kqoygp.jpg',
      ],
      category: 'LUNCH',
      subcategory: 'QUICK',
      price: 4.5,
      preparationTime: '15 mins',
      calories: '310 kcal',
      rating: '4.8',
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: '6a897de42f4aa7b54cd9298b',
      name: 'Margherita Pizza',
      description:
          'Classic Italian pizza with tomato sauce, fresh mozzarella, and basil.',
      images: [
        'https://res.cloudinary.com/dgk8lgdzb/image/upload/v1787395554/uploads/ke0aoe73jkzg6yowz3ao.jpg',
      ],
      category: 'LUNCH',
      subcategory: 'QUICK',
      price: 12.0,
      preparationTime: '15 mins',
      calories: '450 kcal',
      rating: '4.9',
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'rec_dumplings',
      name: 'Steamed Veg Dumplings',
      description:
          'Handmade vegetable dumplings steamed to perfection with dipping sauce.',
      images: [AppAssets.homeRecipeCardImage1],
      category: 'Previously viewed',
      price: 12.0,
      preparationTime: '50m',
      calories: '310 kcal',
      rating: '4.6',
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'rec_soup',
      name: 'Lemon Lentil Soup',
      description:
          'Zesty and comforting red lentil soup with freshly squeezed lemon.',
      images: [AppAssets.homeRecipeCardImage2],
      category: 'Previously viewed',
      price: 8.5,
      preparationTime: '25m',
      calories: '290 kcal',
      rating: '4.5',
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'rec_oats',
      name: 'Berry Overnight Oats',
      description:
          'Rolled oats soaked overnight in almond milk with wild forest berries.',
      images: [AppAssets.homeRecipeCardImage2],
      category: 'Favourite category',
      price: 7.0,
      preparationTime: '12m',
      calories: '320 kcal',
      rating: '4.8',
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'rec_rice',
      name: 'Herbed Rice & Veg Bowl',
      description:
          'Fragrant jasmine rice infused with aromatic herbs and roasted vegetables.',
      images: [AppAssets.homeRecipeCardImage3],
      category: 'Favourite category',
      price: 14.0,
      preparationTime: '45m',
      calories: '520 kcal',
      rating: '4.9',
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'rec_grilled',
      name: 'Grilled Veg Dinner Plate',
      description:
          'Charred seasonal vegetables with balsamic glaze and homemade dip.',
      images: [AppAssets.homeRecipeCardImage1],
      category: 'Food preference',
      price: 15.0,
      preparationTime: '40m',
      calories: '430 kcal',
      rating: '4.7',
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
    FoodItemModel(
      id: 'rec_omelet',
      name: 'Masala Omelet Toast',
      description:
          'Spiced Indian-style masala omelet served on toasted sourdough.',
      images: [AppAssets.homeRecipeCardImage2],
      category: 'Recently cooked',
      price: 9.0,
      preparationTime: '15m',
      calories: '380 kcal',
      rating: '4.6',
      pickupAvailable: true,
      deliveryAvailable: true,
    ),
  ];
}
