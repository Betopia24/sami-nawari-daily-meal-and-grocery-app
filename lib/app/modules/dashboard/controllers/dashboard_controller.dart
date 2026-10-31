import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import 'package:daily_meal_and_grocery_app/app/data/models/food_item_model.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/local_storage.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';
import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';

class DashboardController extends GetxController {
  final isLoading = true.obs;

  // User details
  final userName = 'Rafi'.obs;
  final userLocation = 'San Francisco, CA'.obs;
  final greetingMessage = 'Good Morning'.obs;

  // Unread notification count
  final unreadNotificationCount = 0.obs;

  // Food lists from API
  final recommendedFoods = <FoodItemModel>[].obs;
  final homemadeFoods = <FoodItemModel>[].obs;

  // Search state
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final isSearching = false.obs;
  final isSearchLoading = false.obs;
  final searchResults = <FoodItemModel>[].obs;
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    final cachedId = LocalStorage.idSync;
    if (cachedId != null) {
      LocalStorage.registerSellerInfo(userId: cachedId);
    }
    final user = LocalStorage.userSync;
    if (user != null) {
      LocalStorage.registerSellerInfo(
        userId: user['id']?.toString() ?? user['userId']?.toString(),
        ownerName: user['name']?.toString(),
      );
    }
    _updateGreeting();
    loadDashboardData();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greetingMessage.value = 'Good Morning';
    } else if (hour < 17) {
      greetingMessage.value = 'Good Afternoon';
    } else {
      greetingMessage.value = 'Good Evening';
    }
  }

  /// Loads user profile and dashboard food listings from the backend APIs
  Future<void> loadDashboardData() async {
    isLoading.value = true;

    // Load locally cached user details first for immediate display
    final cachedUser = await LocalStorage.getUser();
    if (cachedUser != null) {
      if (cachedUser['name'] != null && cachedUser['name'].toString().isNotEmpty) {
        userName.value = cachedUser['name'].toString().split(' ').first;
      }
      if (cachedUser['address'] != null && cachedUser['address'].toString().isNotEmpty) {
        userLocation.value = cachedUser['address'].toString();
      }
    }

    try {
      // Concurrently fetch user profile, food items, and unread notifications
      await Future.wait([
        _fetchUserProfile(),
        _fetchRecommendedFoods(),
        _fetchHomemadeFoods(),
        fetchUnreadNotifications(),
      ]);
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull-to-refresh handler
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await NetworkCaller.getRequest(Urls.userMe);
      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData['data'];
        if (data is Map<String, dynamic>) {
          await LocalStorage.saveUser(data);
          if (data['id'] != null) {
            LocalStorage.registerSellerInfo(userId: data['id'].toString());
          }
          if (data['name'] != null && data['name'].toString().isNotEmpty) {
            userName.value = data['name'].toString().split(' ').first;
            LocalStorage.registerSellerInfo(ownerName: data['name'].toString());
          }
          if (data['address'] != null && data['address'].toString().isNotEmpty) {
            userLocation.value = data['address'].toString();
          }
          _fetchSellerProfile();
        }
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
  }

  Future<void> _fetchSellerProfile() async {
    try {
      final response = await NetworkCaller.getRequest(Urls.sellerProfileMe);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data = body is Map ? (body['data'] ?? body) : null;
        if (data is Map) {
          LocalStorage.registerSellerInfo(
            sellerId: data['id']?.toString(),
            userId: data['userId']?.toString(),
            businessName: data['businessName']?.toString(),
            ownerName: data['ownerName']?.toString(),
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching seller profile on dashboard: $e');
    }
  }

  bool isOwnFood(FoodItemModel food) {
    return LocalStorage.isOwnFood(food);
  }

  Future<void> _fetchRecommendedFoods() async {
    try {
      final response = await NetworkCaller.getRequest(Urls.foods);
      if (response.isSuccess && response.responseData != null) {
        final list = _parseFoodList(response.responseData);
        if (list.isNotEmpty) {
          recommendedFoods.assignAll(list);
        }
      }
    } catch (e) {
      debugPrint('Error fetching recommended foods: $e');
    }
  }

  Future<void> _fetchHomemadeFoods() async {
    try {
      final response = await NetworkCaller.getRequest(
        Urls.foods,
        queryParameters: {'limit': 10},
      );
      if (response.isSuccess && response.responseData != null) {
        final list = _parseFoodList(response.responseData);
        if (list.isNotEmpty) {
          homemadeFoods.assignAll(list);
        }
      }
    } catch (e) {
      debugPrint('Error fetching homemade foods: $e');
    }
  }

  List<FoodItemModel> _parseFoodList(dynamic rawResponse) {
    try {
      dynamic rawData;
      if (rawResponse is Map) {
        rawData = rawResponse['data'];
        if (rawData is Map && rawData['data'] is List) {
          rawData = rawData['data'];
        }
      }
      if (rawData is List) {
        return rawData
            .map((item) => FoodItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error parsing foods list: $e');
    }
    return [];
  }

  Future<void> fetchUnreadNotifications() async {
    try {
      final response = await NetworkCaller.getRequest(Urls.notifications);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawList;
        if (body is Map) {
          rawList = body['data'];
          if (rawList is Map && rawList['data'] is List) {
            rawList = rawList['data'];
          }
        }
        if (rawList is List) {
          int count = 0;
          for (final itm in rawList) {
            if (itm is Map && itm['isRead'] == false) {
              count++;
            }
          }
          unreadNotificationCount.value = count;
        }
      }
    } catch (e) {
      debugPrint('Error fetching unread notification count: $e');
    }
  }

  Future<void> addToCart(FoodItemModel food) async {
    try {
      final response = await NetworkCaller.postRequest(
        Urls.cart,
        body: {
          'foodId': food.id,
          'quantity': 1,
        },
      );

      Get.closeCurrentSnackbar();
      if (response.isSuccess) {
        Get.snackbar(
          'Added to Cart',
          '${food.name} added to your cart (\$${food.price.toStringAsFixed(2)})',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar(
          'Cart',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Added to your cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
      Get.toNamed(Routes.mycarts);
    } catch (e) {
      Get.toNamed(Routes.mycarts);
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      isSearching.value = false;
      isSearchLoading.value = false;
      searchResults.clear();
      return;
    }
    isSearching.value = true;
    isSearchLoading.value = true;
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      searchFoods(trimmed);
    });
  }

  Future<void> searchFoods(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }
    isSearching.value = true;
    isSearchLoading.value = true;
    try {
      final response = await NetworkCaller.getRequest(
        Urls.foods,
        queryParameters: {
          'searchTerm': trimmed,
          'limit': 20,
        },
      );
      if (response.isSuccess && response.responseData != null) {
        final list = _parseFoodList(response.responseData);
        searchResults.assignAll(list);
      } else {
        searchResults.clear();
      }
    } catch (e) {
      debugPrint('Error searching foods: $e');
      searchResults.clear();
    } finally {
      isSearchLoading.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    isSearching.value = false;
    isSearchLoading.value = false;
    searchResults.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
