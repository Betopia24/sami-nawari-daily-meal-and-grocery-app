import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void _loadMenuData() {
    final id = restaurant['id'] ?? '1';

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

    filteredMenuItems.assignAll(allMenuItems);
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
