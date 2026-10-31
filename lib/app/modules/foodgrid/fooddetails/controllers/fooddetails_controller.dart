import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/food_item_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../routes/app_routes.dart';

class FooddetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Loading state
  final RxBool isLoading = true.obs;
  final RxBool isBookmarkLoading = false.obs;

  // Food details
  final RxString foodId = ''.obs;
  final RxString foodName = ''.obs;
  final RxString sellerId = ''.obs;
  final RxString sellerOwnerName = ''.obs;
  final RxString sellerName = ''.obs;
  final RxString sellerProfilePicture = ''.obs;
  final RxString sellerAddress = ''.obs;
  final RxString sellerCuisine = ''.obs;
  final RxString foodImage = ''.obs;
  final RxList<String> images = <String>[].obs;
  final RxDouble price = 0.0.obs;
  final RxString rating = '0.0'.obs;
  final RxString reviewCount = '0 reviews'.obs;
  final RxString prepTime = ''.obs;
  final RxString category = ''.obs;
  final RxBool pickupAvailable = true.obs;
  final RxBool deliveryAvailable = true.obs;
  final RxString description = ''.obs;

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

  void resetData() {
    foodId.value = '';
    foodName.value = '';
    sellerId.value = '';
    sellerOwnerName.value = '';
    sellerName.value = '';
    sellerProfilePicture.value = '';
    sellerAddress.value = '';
    sellerCuisine.value = '';
    foodImage.value = '';
    images.clear();
    price.value = 0.0;
    rating.value = '0.0';
    reviewCount.value = '0 reviews';
    prepTime.value = '';
    category.value = '';
    pickupAvailable.value = true;
    deliveryAvailable.value = true;
    description.value = '';
    ingredients.clear();
    quantity.value = 1;
    isBookmarked.value = false;
    popularDishes.clear();
  }

  void _initFromArguments() {
    resetData();
    isLoading.value = true;
    final args = Get.arguments;
    if (args is FoodItemModel) {
      _applyFoodModel(args);
      fetchFoodDetails(args.id);
    } else if (args is Map) {
      final m = Map<String, dynamic>.from(args);
      _applyMapData(m);
      final id = m['id']?.toString() ?? m['foodId']?.toString() ?? '';
      if (id.isNotEmpty) {
        fetchFoodDetails(id);
      } else {
        isLoading.value = false;
      }
    } else if (args is String && args.isNotEmpty) {
      foodId.value = args;
      fetchFoodDetails(args);
    } else {
      isLoading.value = false;
    }
  }

  void _applyMapData(Map<String, dynamic> data) {
    if (data['id'] != null) foodId.value = data['id'].toString();
    if (data['sellerId'] != null) {
      sellerId.value = data['sellerId'].toString();
    } else if (data['userId'] != null) {
      sellerId.value = data['userId'].toString();
    }
    if (data['name'] != null && data['name'].toString().isNotEmpty) {
      foodName.value = data['name'].toString();
    }
    if (data['price'] != null) {
      final p = data['price'];
      price.value =
          (p is num) ? p.toDouble() : double.tryParse(p.toString()) ?? 0.0;
    }
    if (data['image'] != null && data['image'].toString().isNotEmpty) {
      foodImage.value = data['image'].toString();
    }
    if (data['images'] is List && (data['images'] as List).isNotEmpty) {
      final imgList = (data['images'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
      images.assignAll(imgList);
      if (foodImage.value.isEmpty && imgList.isNotEmpty) {
        foodImage.value = imgList.first;
      }
    }
    if (data['sellerName'] != null && data['sellerName'].toString().isNotEmpty) {
      sellerName.value = data['sellerName'].toString();
    } else if (data['seller'] is Map) {
      final s = data['seller'] as Map;
      if (s['id'] != null && sellerId.value.isEmpty) {
        sellerId.value = s['id'].toString();
      }
      if (s['name'] != null) {
        sellerOwnerName.value = s['name'].toString();
      }
      if (s['sellerProfile'] is Map) {
        final sp = s['sellerProfile'] as Map;
        sellerName.value = sp['businessName']?.toString() ?? s['name']?.toString() ?? '';
        if (sp['address'] != null) {
          sellerAddress.value = sp['address'].toString();
        }
        if (sp['cuisine'] != null) {
          sellerCuisine.value = sp['cuisine'].toString();
        }
      } else {
        sellerName.value = s['name']?.toString() ?? '';
      }
    }
    if (data['sellerAddress'] != null && data['sellerAddress'].toString().isNotEmpty) {
      sellerAddress.value = data['sellerAddress'].toString();
    }
    if (data['sellerProfilePicture'] != null) {
      sellerProfilePicture.value = data['sellerProfilePicture'].toString();
    }
    if (data['prepTime'] != null && data['prepTime'].toString().isNotEmpty) {
      prepTime.value = data['prepTime'].toString();
    } else if (data['preparationTime'] != null) {
      prepTime.value = data['preparationTime'].toString();
    }
    if (data['category'] != null && data['category'].toString().isNotEmpty) {
      final cat = data['category'].toString();
      category.value = cat.capitalizeFirst ?? cat;
    }
    if (data['pickupAvailable'] != null) {
      pickupAvailable.value = data['pickupAvailable'] == true;
    }
    if (data['deliveryAvailable'] != null) {
      deliveryAvailable.value = data['deliveryAvailable'] == true;
    }
    if (data['description'] != null) {
      description.value = data['description'].toString();
    }
    if (data['rating'] != null) {
      rating.value = data['rating'].toString();
    }
    if (data['ingredients'] is List &&
        (data['ingredients'] as List).isNotEmpty) {
      final ingList = (data['ingredients'] as List).map((item) {
        if (item is Map) {
          final n = item['name']?.toString() ?? '';
          final q = item['quantity']?.toString() ?? '';
          final u = item['unit']?.toString() ?? '';
          final qtyFormatted =
              '$q$u'.trim().isEmpty ? '' : '$q$u'.trim();
          return {'name': n, 'quantity': qtyFormatted};
        }
        return {'name': item.toString(), 'quantity': ''};
      }).where((e) => e['name']!.isNotEmpty).toList();

      ingredients.assignAll(ingList);
    }
  }

  void _applyFoodModel(FoodItemModel food) {
    foodId.value = food.id;
    if (food.sellerId.isNotEmpty) sellerId.value = food.sellerId;
    if (food.name.isNotEmpty) foodName.value = food.name;
    if (food.displaySeller.isNotEmpty) sellerName.value = food.displaySeller;
    if (food.sellerName.isNotEmpty) sellerOwnerName.value = food.sellerName;
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
    if (id.isEmpty) {
      isLoading.value = false;
      return;
    }
    foodId.value = id;

    try {
      isLoading.value = true;
      // Try explore food details first as it provides isBookmarked directly
      final response =
          await NetworkCaller.getRequest('${Urls.exploreFoods}/$id');

      Map<String, dynamic>? data;
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        data = body is Map<String, dynamic>
            ? (body['data'] is Map ? body['data'] : body)
            : null;
      } else {
        // Fallback to /foods/:id
        final fallbackResponse =
            await NetworkCaller.getRequest('${Urls.foods}/$id');
        if (fallbackResponse.isSuccess && fallbackResponse.responseData != null) {
          final body = fallbackResponse.responseData;
          data = body is Map<String, dynamic>
              ? (body['data'] is Map ? body['data'] : body)
              : null;
        }
      }

      if (data != null) {
        _parseFoodDetailsData(data);
      }
    } catch (e) {
      debugPrint('Error fetching food details: $e');
    } finally {
      isLoading.value = false;
      // Fetch popular dishes and bookmark status
      await _fetchPopularDishes();
      checkBookmarkStatus(id);
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
    if (food['sellerId'] != null && food['sellerId'].toString().isNotEmpty) {
      sellerId.value = food['sellerId'].toString();
    }
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
      if (seller['id'] != null && sellerId.value.isEmpty) {
        sellerId.value = seller['id'].toString();
      }
      final sellerNameVal = seller['name']?.toString() ?? '';
      sellerOwnerName.value = sellerNameVal;
      String businessName = '';
      String address = '';

      if (seller['sellerProfile'] is Map) {
        final profile = seller['sellerProfile'] as Map;
        businessName = profile['businessName']?.toString() ?? '';
        address = profile['address']?.toString() ?? '';
        if (profile['cuisine'] != null) {
          sellerCuisine.value = profile['cuisine'].toString();
        }
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
          : (sellerNameVal.isNotEmpty ? sellerNameVal : '');

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
              '$q$u'.trim().isEmpty ? '' : '$q$u'.trim();
          return {'name': n, 'quantity': qtyFormatted};
        }
        return {'name': item.toString(), 'quantity': ''};
      }).where((e) => e['name']!.isNotEmpty).toList();

      ingredients.assignAll(ingList);
    } else {
      ingredients.clear();
    }
  }

  Future<void> _fetchPopularDishes() async {
    try {
      final List<FoodItemModel> dishes = [];

      // 1. Fetch other dishes from this seller if available
      if (sellerId.value.isNotEmpty) {
        try {
          final sellerMenuResponse =
              await NetworkCaller.getRequest(Urls.sellerMenu(sellerId.value));
          if (sellerMenuResponse.isSuccess && sellerMenuResponse.responseData != null) {
            final body = sellerMenuResponse.responseData;
            dynamic rawData = body is Map ? (body['data'] ?? body) : null;
            List<dynamic>? itemsList;
            if (rawData is Map && rawData['data'] is List) {
              itemsList = rawData['data'] as List;
            } else if (rawData is Map && rawData['items'] is List) {
              itemsList = rawData['items'] as List;
            } else if (rawData is List) {
              itemsList = rawData;
            }

            if (itemsList != null) {
              for (final item in itemsList) {
                if (item is Map) {
                  final model = FoodItemModel.fromJson(Map<String, dynamic>.from(item));
                  if (model.id.isNotEmpty &&
                      model.id != foodId.value &&
                      !dishes.any((d) => d.id == model.id)) {
                    dishes.add(model);
                  }
                }
              }
            }
          }
        } catch (e) {
          debugPrint('Error fetching seller menu for popular dishes: $e');
        }
      }

      // 2. Fetch other foods across platform
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
            for (final item in rawData) {
              if (item is Map) {
                final model = FoodItemModel.fromJson(Map<String, dynamic>.from(item));
                if (model.id.isNotEmpty &&
                    model.id != foodId.value &&
                    !dishes.any((d) => d.id == model.id)) {
                  dishes.add(model);
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching foods for popular dishes: $e');
      }

      popularDishes.assignAll(dishes);
    } catch (e) {
      debugPrint('Error fetching popular dishes: $e');
    }
  }

  void goToSellerProfile() {
    final sId = sellerId.value.isNotEmpty ? sellerId.value : '';
    if (sId.isEmpty && sellerName.value.isEmpty) return;

    final restaurantArgs = {
      'id': sId,
      'sellerId': sId,
      'userId': sId,
      'name': sellerName.value.isNotEmpty ? sellerName.value : 'Alex Ketchecn',
      'owner': sellerOwnerName.value.isNotEmpty ? sellerOwnerName.value : sellerName.value,
      'cuisine': sellerCuisine.value.isNotEmpty ? sellerCuisine.value : 'Homemade',
      'address': sellerAddress.value.isNotEmpty ? sellerAddress.value : 'Dhaka',
      'image': sellerProfilePicture.value,
      'rating': double.tryParse(rating.value) ?? 4.8,
      'reviews': int.tryParse(reviewCount.value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      'distance': '0.4 km',
      'time': prepTime.value.isNotEmpty ? prepTime.value : '25 min',
      'isOpen': true,
      'hasPickup': pickupAvailable.value,
      'hasDelivery': deliveryAvailable.value,
    };

    Get.toNamed(Routes.viewmenu, arguments: restaurantArgs);
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
    if (targetId.isEmpty) return;
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
    final targetId = foodId.value;
    if (targetId.isEmpty) return;

    final previousState = isBookmarked.value;
    final newState = !previousState;
    isBookmarked.value = newState;

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
    final targetId = foodId.value;
    if (targetId.isEmpty) return;

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
        Get.toNamed(Routes.mycarts);
      } else {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Cart',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Item added to your cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        Get.toNamed(Routes.mycarts);
      }
    } catch (e) {
      Get.toNamed(Routes.mycarts);
    }
  }

  void viewCart() {
    Get.toNamed(Routes.mycarts);
  }

  Future<void> refreshFoodDetails() async {
    if (foodId.value.isNotEmpty) {
      await fetchFoodDetails(foodId.value);
    }
  }

  String get formattedUnitPrice =>
      price.value > 0 ? '\$${price.value.toStringAsFixed(2)}' : '\$0.00';
  String get totalPrice =>
      price.value > 0
          ? '\$${(price.value * quantity.value).toStringAsFixed(2)}'
          : '\$0.00';
}
