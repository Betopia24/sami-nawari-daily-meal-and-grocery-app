import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:daily_meal_and_grocery_app/app/data/models/food_item_model.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/local_storage.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/network.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/url.dart';

class DashboardController extends GetxController {
  final isLoading = true.obs;

  // User details
  final userName = 'Rafi'.obs;
  final userLocation = 'San Francisco, CA'.obs;
  final greetingMessage = 'Good Morning'.obs;

  // Food lists from API
  final recommendedFoods = <FoodItemModel>[].obs;
  final homemadeFoods = <FoodItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
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
      // Concurrently fetch user profile and food items
      await Future.wait([
        _fetchUserProfile(),
        _fetchRecommendedFoods(),
        _fetchHomemadeFoods(),
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
          if (data['name'] != null && data['name'].toString().isNotEmpty) {
            userName.value = data['name'].toString().split(' ').first;
          }
          if (data['address'] != null && data['address'].toString().isNotEmpty) {
            userLocation.value = data['address'].toString();
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
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
}
