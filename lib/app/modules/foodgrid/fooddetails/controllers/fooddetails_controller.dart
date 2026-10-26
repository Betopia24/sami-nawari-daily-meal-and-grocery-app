import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/food_item_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../routes/app_routes.dart';

class FooddetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isBookmarkLoading = false.obs;

  // Food details
  final RxString foodId = ''.obs;
  final RxString foodName = 'Chicken Biriyani Tiffin'.obs;
  final RxString sellerName = "Maria's Kitchen".obs;
  final RxString sellerProfilePicture = ''.obs;
  final RxString sellerAddress = 'San Francisco, CA'.obs;
  final RxString foodImage = AppAssets.homeRecipeCardImage3.obs;
  final RxList<String> images = <String>[].obs;
  final RxDouble price = 18.00.obs;
  final RxString rating = '4.7'.obs;
  final RxString reviewCount = '84 reviews'.obs;
  final RxString prepTime = '20 min'.obs;
  final RxString category = 'Lunch'.obs;
  final RxBool pickupAvailable = true.obs;
  final RxBool deliveryAvailable = true.obs;
  final RxString description =
      'Hummus, baba ghanoush, tabbouleh, olives, and fresh pita for 2. A taste of the Mediterranean coast.'
          .obs;

  // Ingredients: list of maps { 'name': 'Spinach', 'quantity': '100g' }
  final RxList<Map<String, String>> ingredients = <Map<String, String>>[].obs;

  // Popular / other dishes from backend
  final RxList<FoodItemModel> popularDishes = <FoodItemModel>[].obs;

  // Bookmark state
  final RxBool isBookmarked = false.obs;

  // Cart / Quantity
  final RxInt quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _initFromArguments();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void _initFromArguments() {
    final args = Get.arguments;
    if (args is FoodItemModel) {
      _applyFoodModel(args);
      fetchFoodDetails(args.id);
    } else if (args is Map) {
      final id = args['id']?.toString() ?? args['foodId']?.toString() ?? '';
      if (args['name'] != null && args['name'].toString().isNotEmpty) {
        foodName.value = args['name'].toString();
      }
      if (args['price'] != null) {
        price.value = (args['price'] is num)
            ? (args['price'] as num).toDouble()
            : double.tryParse(args['price'].toString()) ?? 18.0;
      }
      if (id.isNotEmpty) {
        foodId.value = id;
        fetchFoodDetails(id);
      } else {
        fetchFoodDetails('6a8d6ca9e87759724844e5ec');
      }
    } else if (args is String && args.isNotEmpty) {
      foodId.value = args;
      fetchFoodDetails(args);
    } else {
      // Default fallback id: first live food item on backend
      fetchFoodDetails('6a8d6ca9e87759724844e5ec');
    }
    _fetchPopularDishes();
  }

  void _applyFoodModel(FoodItemModel food) {
    foodId.value = food.id;
    if (food.name.isNotEmpty) foodName.value = food.name;
    if (food.displaySeller.isNotEmpty) sellerName.value = food.displaySeller;
    if (food.sellerAddress.isNotEmpty) sellerAddress.value = food.sellerAddress;
    if (food.sellerProfilePicture.isNotEmpty) {
      sellerProfilePicture.value = food.sellerProfilePicture;
    }
    if (food.firstImage.isNotEmpty) foodImage.value = food.firstImage;
    if (food.images.isNotEmpty) images.assignAll(food.images);
    if (food.price > 0) price.value = food.price;
    if (food.preparationTime.isNotEmpty) prepTime.value = food.preparationTime;
    if (food.category.isNotEmpty) {
      category.value = food.category.capitalizeFirst ?? food.category;
    }
    pickupAvailable.value = food.pickupAvailable;
    deliveryAvailable.value = food.deliveryAvailable;
    if (food.description.isNotEmpty) description.value = food.description;
    if (food.rating.isNotEmpty) rating.value = food.rating;
  }

  Future<void> fetchFoodDetails(String id) async {
    final validId =
        (id.isNotEmpty && id.length == 24) ? id : '6a8d6ca9e87759724844e5ec';
    foodId.value = validId;

    try {
      isLoading.value = true;
      // Try explore food details first as it provides isBookmarked directly
      final response =
          await NetworkCaller.getRequest('${Urls.exploreFoods}/$validId');

      Map<String, dynamic>? data;
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        data = body is Map<String, dynamic>
            ? (body['data'] is Map ? body['data'] : body)
            : null;
      } else {
        // Fallback to /foods/:id
        final fallbackResponse =
            await NetworkCaller.getRequest('${Urls.foods}/$validId');
        if (fallbackResponse.isSuccess && fallbackResponse.responseData != null) {
          final body = fallbackResponse.responseData;
          data = body is Map<String, dynamic>
              ? (body['data'] is Map ? body['data'] : body)
              : null;
        }
      }

      if (data != null) {
        _parseFoodDetailsData(data);
      } else {
        _loadDefaultFallback();
      }
    } catch (e) {
      debugPrint('Error fetching food details: $e');
      _loadDefaultFallback();
    } finally {
      isLoading.value = false;
      // Always verify bookmark status from bookmarks endpoint as well
      checkBookmarkStatus(validId);
    }
  }

  void _parseFoodDetailsData(Map<String, dynamic> data) {
    Map<String, dynamic> food = {};
    if (data.containsKey('food') && data['food'] is Map) {
      food = Map<String, dynamic>.from(data['food'] as Map);
      if (data['isBookmarked'] != null) {
        isBookmarked.value = data['isBookmarked'] == true;
      }
    } else {
      food = data;
    }

    if (food['id'] != null) foodId.value = food['id'].toString();
    if (food['name'] != null && food['name'].toString().isNotEmpty) {
      foodName.value = food['name'].toString();
    }
    if (food['description'] != null &&
        food['description'].toString().isNotEmpty) {
      description.value = food['description'].toString();
    }

    // Images
    if (food['images'] is List && (food['images'] as List).isNotEmpty) {
      final imgList = (food['images'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
      images.assignAll(imgList);
      if (imgList.isNotEmpty) {
        foodImage.value = imgList.first;
      }
    }

    // Price
    if (food['price'] != null) {
      final p = food['price'];
      price.value =
          (p is num) ? p.toDouble() : double.tryParse(p.toString()) ?? price.value;
    }

    // Category
    if (food['category'] != null && food['category'].toString().isNotEmpty) {
      final cat = food['category'].toString();
      category.value = cat.capitalizeFirst ?? cat;
    }

    // Preparation Time
    if (food['preparationTime'] != null &&
        food['preparationTime'].toString().isNotEmpty) {
      prepTime.value = food['preparationTime'].toString();
    }

    // Pickup & Delivery
    if (food['pickupAvailable'] != null) {
      pickupAvailable.value = food['pickupAvailable'] == true;
    }
    if (food['deliveryAvailable'] != null) {
      deliveryAvailable.value = food['deliveryAvailable'] == true;
    }

    // Seller
    if (food['seller'] is Map) {
      final seller = food['seller'] as Map;
      final sellerNameVal = seller['name']?.toString() ?? '';
      String businessName = '';
      String address = '';

      if (seller['sellerProfile'] is Map) {
        final profile = seller['sellerProfile'] as Map;
        businessName = profile['businessName']?.toString() ?? '';
        address = profile['address']?.toString() ?? '';
        if (profile['averageRating'] != null &&
            (profile['averageRating'] as num) > 0) {
          rating.value = (profile['averageRating'] as num).toStringAsFixed(1);
        }
        if (profile['reviewCount'] != null &&
            (profile['reviewCount'] as num) > 0) {
          reviewCount.value = '${profile['reviewCount']} reviews';
        }
      }

      sellerName.value = businessName.isNotEmpty
          ? businessName
          : (sellerNameVal.isNotEmpty ? sellerNameVal : "Maria's Kitchen");

      if (address.isNotEmpty) {
        sellerAddress.value = address;
      }

      if (seller['profilePicture'] != null &&
          seller['profilePicture'].toString().isNotEmpty) {
        sellerProfilePicture.value = seller['profilePicture'].toString();
      }
    }

    // Ingredients
    if (food['ingredients'] is List) {
      final ingList = (food['ingredients'] as List).map((item) {
        if (item is Map) {
          final n = item['name']?.toString() ?? '';
          final q = item['quantity']?.toString() ?? '';
          final u = item['unit']?.toString() ?? '';
          final qtyFormatted =
              '$q$u'.trim().isEmpty ? '1 pc' : '$q$u'.trim();
          return {'name': n, 'quantity': qtyFormatted};
        }
        return {'name': item.toString(), 'quantity': '1 pc'};
      }).where((e) => e['name']!.isNotEmpty).toList();

      if (ingList.isNotEmpty) {
        ingredients.assignAll(ingList);
      } else {
        _setDefaultIngredients();
      }
    } else {
      _setDefaultIngredients();
    }
  }

  void _setDefaultIngredients() {
    ingredients.assignAll([
      {'name': 'Chickpeas', 'quantity': '200g'},
      {'name': 'Tahini', 'quantity': '3 tbsp'},
      {'name': 'Lemon juice', 'quantity': '2 tbsp'},
      {'name': 'Garlic', 'quantity': '2 cloves'},
      {'name': 'Baba ganoush', 'quantity': '100g'},
      {'name': 'Tabbouleh', 'quantity': '80g'},
      {'name': 'Kalamata olives', 'quantity': '60g'},
      {'name': 'Fresh pita bread', 'quantity': '4 pcs'},
    ]);
  }

  void _loadDefaultFallback() {
    foodName.value = 'Spanakopita';
    sellerName.value = "Maria's Kitchen";
    sellerAddress.value = '123 Market St, San Francisco, CA';
    price.value = 4.50;
    prepTime.value = '15 mins';
    category.value = 'Lunch';
    rating.value = '4.8';
    reviewCount.value = '84 reviews';
    description.value =
        'Authentic Greek spinach pie with fresh herbs and crisp pastry from Maria’s Kitchen.';
    foodImage.value = AppAssets.homeRecipeCardImage3;
    _setDefaultIngredients();
  }

  Future<void> _fetchPopularDishes() async {
    try {
      final response = await NetworkCaller.getRequest(Urls.foods);
      if (response.isSuccess && response.responseData != null) {
        dynamic rawData = response.responseData;
        if (rawData is Map && rawData['data'] != null) {
          rawData = rawData['data'];
          if (rawData is Map && rawData['data'] is List) {
            rawData = rawData['data'];
          }
        }
        if (rawData is List) {
          final list = rawData
              .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
              .where((food) => food.id != foodId.value)
              .toList();
          if (list.isNotEmpty) {
            popularDishes.assignAll(list);
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching popular dishes: $e');
    }
  }

  void navigateToFood(String newFoodId) {
    if (newFoodId.isEmpty || newFoodId == foodId.value) return;
    Get.toNamed(
      Routes.fooddetails,
      arguments: newFoodId,
      preventDuplicates: false,
    );
  }

  Future<void> checkBookmarkStatus(String targetId) async {
    try {
      final response = await NetworkCaller.getRequest(Urls.bookmarks);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data = body is Map ? (body['data'] ?? body) : body;
        if (data is List) {
          final exists = data.any((item) {
            if (item is Map) {
              final bId =
                  item['id']?.toString() ?? item['foodId']?.toString();
              return bId == targetId;
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
    final targetId =
        foodId.value.isNotEmpty ? foodId.value : '6a8d6ca9e87759724844e5ec';

    // 1. Instant optimistic UI update
    final previousState = isBookmarked.value;
    final newState = !previousState;
    isBookmarked.value = newState;

    // 2. Fire API request
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
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Saved',
          isBookmarked.value
              ? '${foodName.value} bookmarked successfully'
              : 'Bookmark removed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      } else {
        // Revert on failure
        isBookmarked.value = previousState;
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Bookmark',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update bookmark. Please sign in.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    }).catchError((e) {
      isBookmarked.value = previousState;
      debugPrint('Error toggling bookmark: $e');
    });
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  Future<void> addToCart() async {
    final targetId =
        foodId.value.isNotEmpty ? foodId.value : '6a8d6ca9e87759724844e5ec';

    try {
      final response = await NetworkCaller.postRequest(
        Urls.cart,
        body: {
          'foodId': targetId,
          'quantity': quantity.value,
        },
      );
      if (response.isSuccess) {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Added to Cart',
          '${quantity.value}x ${foodName.value} added to your cart ($totalPrice)',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Cart',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Could not add item to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Cart',
        'Something went wrong while adding to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  void viewCart() {
    Get.toNamed(Routes.mycarts);
  }

  String get formattedUnitPrice => '\$${price.value.toStringAsFixed(2)}';
  String get totalPrice =>
      '\$${(price.value * quantity.value).toStringAsFixed(2)}';
}
