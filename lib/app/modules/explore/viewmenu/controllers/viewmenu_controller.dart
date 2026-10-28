import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

import '../../../../routes/app_routes.dart';

class ViewmenuController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final selectedTab = 0.obs;
  final selectedCategory = 0.obs;

  // Restaurant data passed via arguments
  late final Map<String, dynamic> restaurant;

  // Menu categories (dynamic per restaurant)
  final categories = <String>[].obs;

  // Popular dishes
  final popularDishes = <Map<String, dynamic>>[].obs;

  // Complete menu items
  final allMenuItems = <Map<String, dynamic>>[].obs;
  final filteredMenuItems = <Map<String, dynamic>>[].obs;

  // About & Review data
  final aboutData = <String, dynamic>{}.obs;
  final reviewsData = <String, dynamic>{}.obs;

  // Loading state for API requests
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });
    restaurant = Get.arguments ?? _defaultRestaurant();
    _loadMenuData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void setCategory(int index) {
    selectedCategory.value = index;
    _filterMenu();
  }

  void _filterMenu() {
    if (selectedCategory.value == 0) {
      filteredMenuItems.assignAll(allMenuItems);
    } else {
      final cat = categories[selectedCategory.value];
      filteredMenuItems.assignAll(
        allMenuItems.where((item) => item['category'] == cat).toList(),
      );
    }
  }

  void goToFoodDetails(Map<String, dynamic> dish) {
    final Map<String, dynamic> dishWithSeller = Map<String, dynamic>.from(dish);
    dishWithSeller['sellerName'] ??=
        restaurant['name'] ?? restaurant['owner'] ?? 'Home Cook';
    dishWithSeller['sellerAddress'] ??= restaurant['address'] ?? '';
    dishWithSeller['sellerProfilePicture'] ??= restaurant['image'] ?? '';
    dishWithSeller['rating'] ??= dish['rating'] ?? 4.8;
    dishWithSeller['prepTime'] ??= dish['prepTime'] ?? '25 mins';
    dishWithSeller['category'] ??= dish['category'] ?? 'Snacks';
    dishWithSeller['pickupAvailable'] ??=
        dish['pickupAvailable'] ?? restaurant['hasPickup'] ?? true;
    dishWithSeller['deliveryAvailable'] ??=
        dish['deliveryAvailable'] ?? restaurant['hasDelivery'] ?? true;

    Get.toNamed(Routes.fooddetails, arguments: dishWithSeller);
  }

  Future<void> _loadMenuData() async {
    final String sellerId = (restaurant['sellerId'] ?? restaurant['userId'] ?? restaurant['id'] ?? '1').toString();

    // Reset / clear previous data so no stale mock items are shown during API loading
    isLoading.value = true;
    categories.clear();
    popularDishes.clear();
    allMenuItems.clear();
    filteredMenuItems.clear();
    aboutData.clear();
    reviewsData.clear();

    try {
      String targetId = sellerId;
      if (restaurant['userId'] != null && restaurant['userId'].toString().isNotEmpty) {
        targetId = restaurant['userId'].toString();
      } else if (restaurant['sellerId'] != null && restaurant['sellerId'].toString().isNotEmpty) {
        targetId = restaurant['sellerId'].toString();
      }

      if (targetId.length > 5 && targetId != '1' && targetId != '2' && targetId != '3') {
        await Future.wait([
          _fetchSellerMenu(targetId),
          _fetchSellerAbout(targetId),
          _fetchSellerReviews(targetId),
        ]);

        // If menu was empty with targetId, try with restaurant['id'] if different
        if (allMenuItems.isEmpty && restaurant['id'] != null && restaurant['id'].toString() != targetId) {
          final altId = restaurant['id'].toString();
          if (altId.length > 5) {
            await Future.wait([
              _fetchSellerMenu(altId),
              if (aboutData.isEmpty) _fetchSellerAbout(altId),
              if (reviewsData.isEmpty) _fetchSellerReviews(altId),
            ]);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading seller live menu data: $e');
    } finally {
      if (allMenuItems.isEmpty) {
        _loadFallbackById(sellerId);
        filteredMenuItems.assignAll(allMenuItems);
      }
      isLoading.value = false;
    }
  }

  void _loadFallbackById(String id) {
    switch (id) {
      case '1':
        _loadMariasKitchen();
        break;
      case '2':
        _loadChensDimSum();
        break;
      case '3':
        _loadPriyasSpiceHouse();
        break;
      default:
        _loadMariasKitchen();
    }
  }

  Future<void> _fetchSellerMenu(String sellerId) async {
    try {
      final response = await NetworkCaller.getRequest(Urls.sellerMenu(sellerId));
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData = body is Map ? (body['data'] ?? body) : null;
        List<dynamic>? itemsList;
        if (rawData is Map && rawData['data'] is List) {
          itemsList = rawData['data'] as List;
        } else if (rawData is Map && rawData['items'] is List) {
          itemsList = rawData['items'] as List;
        } else if (rawData is List) {
          itemsList = rawData;
        }

        if (itemsList != null && itemsList.isNotEmpty) {
          final Set<String> catSet = {'All'};
          final List<Map<String, dynamic>> menu = [];
          final List<Map<String, dynamic>> popular = [];

          for (final item in itemsList) {
            if (item is Map) {
              final Map<String, dynamic> it = Map<String, dynamic>.from(item);
              final String cat = it['category']?.toString() ?? 'Mains';
              catSet.add(cat);

              String img = 'assets/images/homelunchcardimage.png';
              if (it['images'] is List && (it['images'] as List).isNotEmpty) {
                img = (it['images'] as List)[0]?.toString() ?? img;
              }

              final dish = {
                'id': it['id']?.toString() ?? '',
                'name': it['name']?.toString() ?? 'Dish',
                'description': it['description']?.toString() ?? '',
                'image': img,
                'images': (it['images'] is List && (it['images'] as List).isNotEmpty)
                    ? (it['images'] as List).map((e) => e?.toString() ?? '').toList()
                    : [img],
                'price': (it['price'] as num?)?.toDouble() ?? 10.0,
                'prepTime': it['preparationTime']?.toString() ?? '20 min',
                'rating': (it['averageRating'] as num?)?.toDouble() ?? 4.8,
                'isPopular': it['isPopular'] ?? true,
                'category': cat,
                'sellerName': restaurant['name'] ?? restaurant['owner'] ?? 'Home Cook',
                'sellerAddress': restaurant['address'] ?? '',
                'sellerProfilePicture': restaurant['image'] ?? '',
                'pickupAvailable': it['pickupAvailable'] ?? true,
                'deliveryAvailable': it['deliveryAvailable'] ?? true,
                'ingredients': it['ingredients'] ?? [],
              };
              menu.add(dish);
              if (popular.length < 3) {
                popular.add(dish);
              }
            }
          }

          if (menu.isNotEmpty) {
            categories.assignAll(catSet.toList());
            popularDishes.assignAll(popular);
            allMenuItems.assignAll(menu);
            _filterMenu();
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching live seller menu: $e');
    }
  }

  Future<void> _fetchSellerAbout(String sellerId) async {
    try {
      final response = await NetworkCaller.getRequest(Urls.sellerAbout(sellerId));
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData = body is Map ? (body['data'] ?? body) : null;
        if (rawData is Map) {
          final s = Map<String, dynamic>.from(rawData);
          final user = s['user'] is Map ? s['user'] as Map : {};

          final Map<String, String> formattedHours = {};
          if (s['workingHours'] is Map) {
            final wh = s['workingHours'] as Map;
            wh.forEach((key, val) {
              String dayName = key.toString();
              if (dayName == 'mon_fri') {
                dayName = 'Monday - Friday';
              } else if (dayName == 'saturday') {
                dayName = 'Saturday';
              } else if (dayName == 'sunday') {
                dayName = 'Sunday';
              } else if (dayName.isNotEmpty) {
                dayName = dayName[0].toUpperCase() + dayName.substring(1);
              }

              if (val is Map) {
                if (val['isOpen'] == false || val['open'] == null || val['open'].toString().isEmpty) {
                  formattedHours[dayName] = 'Closed';
                } else {
                  formattedHours[dayName] = '${val['open']} - ${val['close']}';
                }
              } else {
                formattedHours[dayName] = val.toString();
              }
            });
          }
          if (formattedHours.isEmpty) {
            formattedHours.addAll({
              'Monday - Friday': '9:00 AM - 7:00 PM',
              'Saturday': '10:00 AM - 8:00 PM',
              'Sunday': 'Closed',
            });
          }

          aboutData.value = {
            'chefImage': user['profilePicture']?.toString() ?? 'assets/images/homereceipecardimage1.jpg',
            'chefName': user['name']?.toString() ?? s['ownerName']?.toString() ?? restaurant['owner'] ?? 'Home Cook',
            'chefRole': (s['cuisineTypes'] is List && (s['cuisineTypes'] as List).isNotEmpty)
                ? '${(s['cuisineTypes'] as List).join(', ')} home cook'
                : 'Passionate home cook',
            'chefBio': s['description']?.toString() ?? 'I prepare fresh home-cooked meals with love.',
            'workingHours': formattedHours,
            'isOpen': s['isOpen'] ?? true,
            'orderingInfo': {
              'minimumOrder': '\$10',
              'deliveryCharge': s['deliveryFee'] != null ? '\$${(s['deliveryFee'] as num).toDouble().toStringAsFixed(2)}' : '\$2.00',
              'pickupStatus': (s['pickupAvailable'] ?? true) ? 'Available' : 'Unavailable',
              'prepTime': '~25 minutes',
              'distance': restaurant['distance'] ?? '1.0 km from you',
            },
          };
        }
      }
    } catch (e) {
      debugPrint('Error fetching seller about: $e');
    }
  }

  Future<void> _fetchSellerReviews(String sellerId) async {
    try {
      final response = await NetworkCaller.getRequest(Urls.sellerReviews(sellerId));
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData = body is Map ? (body['data'] ?? body) : null;
        List<dynamic>? revList;
        if (rawData is Map && rawData['data'] is List) {
          revList = rawData['data'] as List;
        } else if (rawData is List) {
          revList = rawData;
        }

        if (revList != null && revList.isNotEmpty) {
          final List<Map<String, dynamic>> parsedRev = [];
          for (final r in revList) {
            if (r is Map) {
              final user = r['user'] is Map ? r['user'] as Map : {};
              parsedRev.add({
                'image': user['profilePicture']?.toString() ?? 'assets/images/homereceipecardimage2.jpg',
                'name': user['name']?.toString() ?? 'Customer',
                'timeAgo': 'Recently',
                'rating': (r['rating'] as num?)?.toDouble() ?? 5.0,
                'text': r['comment']?.toString() ?? 'Delicious homemade food!',
              });
            }
          }

          if (parsedRev.isNotEmpty) {
            reviewsData.value = {
              'rating': restaurant['rating'] ?? 4.8,
              'totalReviews': parsedRev.length,
              'percentages': {5: 85, 4: 10, 3: 5, 2: 0, 1: 0},
              'list': parsedRev,
            };
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching seller reviews: $e');
    }
  }

  void _loadMariasKitchen() {
    categories.assignAll(['All', 'Platters', 'Pastries', 'Mains', 'Salads']);

    popularDishes.assignAll([
      {
        'name': 'Classic Mezze Platter',
        'image': 'assets/images/homelunchcardimage.png',
        'price': 18.0,
        'isPopular': true,
      },
    ]);

    aboutData.value = {
      'chefImage': 'assets/images/homereceipecardimage1.jpg',
      'chefName': 'Maria Santos',
      'chefRole': 'Italian home cook',
      'chefBio':
          'I trained at a pasta school in Bologna and I\'ve been making fresh pasta every day since. All pasta is made to order using semolina flour and free-range eggs.',
      'workingHours': {
        'Monday': '9:00 AM - 7:00 PM',
        'Tuesday': '9:00 AM - 7:00 PM',
        'Wednesday': '9:00 AM - 7:00 PM',
        'Thursday': '9:00 AM - 8:00 PM',
        'Friday': '9:00 AM - 9:00 PM',
        'Saturday': '10:00 AM - 8:00 PM',
        'Sunday': 'Closed',
      },
      'isOpen': true,
      'orderingInfo': {
        'minimumOrder': '\$15',
        'deliveryCharge': '\$2.00',
        'pickupStatus': 'Available',
        'prepTime': '~20 minutes',
        'distance': '1.5 km from you',
      },
    };

    reviewsData.value = {
      'rating': 4.7,
      'totalReviews': 84,
      'percentages': {5: 78, 4: 15, 3: 5, 2: 2, 1: 2},
      'list': [
        {
          'image': 'assets/images/homereceipecardimage2.jpg',
          'name': 'Sarah K.',
          'timeAgo': '2 days ago',
          'rating': 5.0,
          'text':
              'Best mezze in the neighborhood! The falafel is incredibly crispy and fresh every time.',
        },
        {
          'image': 'assets/images/homereceipecardimage1.jpg',
          'name': 'Marcus T.',
          'timeAgo': '1 week ago',
          'rating': 5.0,
          'text':
              'Maria puts so much love into her food. The lamb kofta is outstanding, and the pita is still warm.',
        },
      ],
    };

    allMenuItems.assignAll([
      {
        'name': 'Classic Mezze Platter',
        'description':
            'Hummus, baba ganoush, tabbouleh, olives, and fresh pita for 2. A taste of the Mediterranean coast.',
        'image': 'assets/images/homelunchcardimage.png',
        'price': 18.0,
        'prepTime': '25 min',
        'rating': 4.9,
        'isPopular': true,
        'category': 'Platters',
      },
      {
        'name': 'Spanakopita',
        'description':
            'Crispy phyllo pastry filled with spinach and feta, baked golden. Served warm.',
        'image': 'assets/images/homereceipecardimage1.jpg',
        'price': 9.0,
        'prepTime': '15 min',
        'rating': 4.8,
        'isPopular': false,
        'category': 'Pastries',
      },
      {
        'name': 'Lamb Kofta with Rice',
        'description':
            'Seasoned lamb kofta with turmeric rice, cucumber yogurt sauce, and grilled pita.',
        'image': 'assets/images/homereceipecardimage2.jpg',
        'price': 16.0,
        'prepTime': '20 min',
        'rating': 4.7,
        'isPopular': false,
        'category': 'Mains',
      },
      {
        'name': 'Greek Salad',
        'description':
            'Ripe tomatoes, cucumbers, kalamata olives, red onion, and generous chunks of feta.',
        'image': 'assets/images/homereceipecardimage3.jpg',
        'price': 8.0,
        'prepTime': '15 min',
        'rating': 4.6,
        'isPopular': false,
        'category': 'Salads',
      },
      {
        'name': 'Chicken Shawarma Wrap',
        'description':
            'Marinated chicken in warm pita with pickled turnips, garlic sauce, and fresh herbs.',
        'image': 'assets/images/homedinnercardimage.png',
        'price': 12.0,
        'prepTime': '20 min',
        'rating': 4.8,
        'isPopular': false,
        'category': 'Mains',
      },
    ]);
  }

  void _loadChensDimSum() {
    categories.assignAll(['All', 'Dumplings', 'Bao', 'Fried']);

    popularDishes.assignAll([
      {
        'name': 'Pork & Chive Dumplings',
        'image': 'assets/images/homedinnercardimage.png',
        'price': 11.0,
        'isPopular': true,
      },
    ]);

    aboutData.value = {
      'chefImage': 'assets/images/homereceipecardimage1.jpg',
      'chefName': 'Wei Chen',
      'chefRole': 'Chinese home cook',
      'chefBio':
          'Third-generation recipe from Guangzhou. I make every dumpling by hand, every morning. No shortcuts, no frozen items.',
      'workingHours': {
        'Monday': '9:00 AM - 7:00 PM',
        'Tuesday': '9:00 AM - 7:00 PM',
        'Wednesday': '9:00 AM - 7:00 PM',
        'Thursday': '9:00 AM - 8:00 PM',
        'Friday': '9:00 AM - 9:00 PM',
        'Saturday': '10:00 AM - 8:00 PM',
        'Sunday': 'Closed',
      },
      'isOpen': true,
      'orderingInfo': {
        'minimumOrder': '\$8',
        'deliveryCharge': '\$3.00',
        'pickupStatus': 'Available',
        'prepTime': '~30 minutes',
        'distance': '0.8 km from you',
      },
    };

    reviewsData.value = {
      'rating': 5.0,
      'totalReviews': 56,
      'percentages': {5: 90, 4: 10, 3: 0, 2: 0, 1: 0},
      'list': [
        {
          'image': 'assets/images/homereceipecardimage1.jpg',
          'name': 'Daniel L.',
          'timeAgo': '3 days ago',
          'rating': 5.0,
          'text':
              'Incredible dumplings! The wrapper is the perfect thickness and the filling is so juicy.',
        },
      ],
    };

    allMenuItems.assignAll([
      {
        'name': 'Pork & Chive Dumplings',
        'description':
            '12 hand-folded dumplings with pork and chive filling. Served with black vinegar dipping sauce.',
        'image': 'assets/images/homedinnercardimage.png',
        'price': 11.0,
        'prepTime': '25 min',
        'rating': 4.9,
        'isPopular': true,
        'category': 'Dumplings',
      },
      {
        'name': 'BBQ Pork Bao (3 pcs)',
        'description':
            'Fluffy steamed buns filled with slow-cooked char siu pork.',
        'image': 'assets/images/homelunchcardimage.png',
        'price': 8.0,
        'prepTime': '20 min',
        'rating': 4.7,
        'isPopular': false,
        'category': 'Bao',
      },
      {
        'name': 'Vegetable Spring Rolls (6 pcs)',
        'description':
            'Crispy fried spring rolls with glass noodles, cabbage, and shiitake mushrooms.',
        'image': 'assets/images/homereceipecardimage1.jpg',
        'price': 7.0,
        'prepTime': '15 min',
        'rating': 4.6,
        'isPopular': false,
        'category': 'Fried',
      },
    ]);
  }

  void _loadPriyasSpiceHouse() {
    categories.assignAll(['All', 'Rice', 'Curries']);

    popularDishes.assignAll([
      {
        'name': 'Chicken Biriyani',
        'image': 'assets/images/homereceipecardimage1.jpg',
        'price': 14.0,
        'isPopular': true,
      },
    ]);

    aboutData.value = {
      'chefImage': 'assets/images/girl.jpg',
      'chefName': 'Priya Sharma',
      'chefRole': 'Indian home cook',
      'chefBio':
          'Born in Mumbai, cooking since I was 8 years old. My curries are made with hand-ground spices I bring back from India.',
      'workingHours': {
        'Monday': '9:00 AM - 7:00 PM',
        'Tuesday': '9:00 AM - 7:00 PM',
        'Wednesday': '9:00 AM - 7:00 PM',
        'Thursday': '9:00 AM - 8:00 PM',
        'Friday': '9:00 AM - 9:00 PM',
        'Saturday': '10:00 AM - 8:00 PM',
        'Sunday': 'Closed',
      },
      'isOpen': true,
      'orderingInfo': {
        'minimumOrder': '\$10',
        'deliveryCharge': '\$3.00',
        'pickupStatus': 'Available',
        'prepTime': '~40 minutes',
        'distance': '1.2 km from you',
      },
    };

    reviewsData.value = {
      'rating': 4.9,
      'totalReviews': 112,
      'percentages': {5: 85, 4: 10, 3: 5, 2: 0, 1: 0},
      'list': [
        {
          'image': 'assets/images/boy.jpg',
          'name': 'Amit B.',
          'timeAgo': '1 week ago',
          'rating': 5.0,
          'text':
              'The biryani reminds me exactly of home. You can taste every spice. Worth every penny.',
        },
        {
          'image': 'assets/images/girl.jpg',
          'name': 'Rachel M.',
          'timeAgo': '2 weeks ago',
          'rating': 5.0,
          'text':
              'Priya\'s dal makhani is the most comforting dish I\'ve had in this city. Rich, creamy, perfect.',
        },
      ],
    };

    allMenuItems.assignAll([
      {
        'name': 'Chicken Biriyani',
        'description':
            'Fragrant basmati rice layered with tender chicken, saffron, and crispy onions. A family recipe.',
        'image': 'assets/images/homereceipecardimage1.jpg',
        'price': 14.0,
        'prepTime': '45 min',
        'rating': 4.9,
        'isPopular': true,
        'category': 'Rice',
      },
      {
        'name': 'Dal Makhani',
        'description':
            'Slow-cooked black lentils in a rich tomato and butter sauce. Vegan on request.',
        'image': 'assets/images/homereceipecardimage2.jpg',
        'price': 10.0,
        'prepTime': '40 min',
        'rating': 4.8,
        'isPopular': false,
        'category': 'Curries',
      },
    ]);
  }

  Map<String, dynamic> _defaultRestaurant() {
    return {
      'id': '1',
      'name': "Maria's Kitchen",
      'owner': 'Maria Santos',
      'cuisine': 'Mediterranean',
      'specialty': 'Mezze platters & fresh pita',
      'rating': 4.7,
      'reviews': 84,
      'distance': '0.4 km',
      'time': '25 min',
      'minOrder': '\$12',
      'isOpen': true,
      'hasPickup': true,
      'hasDelivery': true,
      'image': 'assets/images/homelunchcardimage.png',
    };
  }
}
