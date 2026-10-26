import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../data/models/cart_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../routes/app_routes.dart';

class MycartsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Cart state
  final RxBool isLoadingCart = false.obs;
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxList<CartGroupModel> cartGroups = <CartGroupModel>[].obs;

  final totalItems = 4.obs;
  final totalSellers = 3.obs;
  final totalPrice = 77.0.obs;

  final currentTabIndex = 0.obs;

  // Active orders state
  final RxBool isLoadingOrders = false.obs;
  final RxList<Map<String, dynamic>> activeOrders =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> historyOrders =
      <Map<String, dynamic>>[].obs;

  // Active Orders (Tracking & Review)
  final selectedRating = 0.obs;

  @override
  void onInit() {
    super.onInit();
    int initialIndex = 0;
    if (Get.arguments != null &&
        Get.arguments is Map &&
        Get.arguments['mycarts_tab'] != null) {
      initialIndex = Get.arguments['mycarts_tab'];
    }
    tabController =
        TabController(length: 3, vsync: this, initialIndex: initialIndex);
    currentTabIndex.value = initialIndex;
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });

    _loadDefaultCart();
    fetchCart();
    fetchOrders();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // CART API & STATE
  // ---------------------------------------------------------------------------

  Future<void> fetchCart() async {
    try {
      isLoadingCart.value = true;
      final response = await NetworkCaller.getRequest(Urls.cart);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData = body is Map ? (body['data'] ?? body) : null;

        List<dynamic>? itemsList;
        if (rawData is Map && rawData['items'] is List) {
          itemsList = rawData['items'] as List;
        } else if (rawData is List) {
          itemsList = rawData;
        }

        if (itemsList != null && itemsList.isNotEmpty) {
          final List<CartItemModel> parsed = itemsList.map((item) {
            return CartItemModel.fromJson(item as Map<String, dynamic>);
          }).toList();

          cartItems.assignAll(parsed);
          _rebuildCartGroups();
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching cart: $e');
    } finally {
      isLoadingCart.value = false;
    }
  }

  void _loadDefaultCart() {
    cartItems.assignAll([
      CartItemModel(
        foodId: '6a8d6ca9e87759724844e5ec',
        name: 'Classic Mezze Platter',
        price: 18.0,
        quantity: 1,
        image: AppAssets.homeRecipeCardImage1,
        sellerId: 'seller_1',
        sellerName: "Maria's Kitchen",
        sellerAuthor: 'Maria Santos',
        prepTime: '25 min',
        pickupAvailable: true,
        deliveryFee: 2.50,
      ),
      CartItemModel(
        foodId: '6a897de42f4aa7b54cd9298b',
        name: 'Cacio e Pepe',
        price: 13.0,
        quantity: 1,
        image: AppAssets.homeRecipeCardImage2,
        sellerId: 'seller_2',
        sellerName: "Luca's Pasta Club",
        sellerAuthor: 'Luca Buanchi',
        prepTime: '20 min',
        pickupAvailable: true,
        deliveryFee: 2.50,
      ),
      CartItemModel(
        foodId: 'food_tiramisu',
        name: 'Tiramisu',
        price: 7.0,
        quantity: 2,
        image: AppAssets.homeRecipeCardImage2,
        sellerId: 'seller_2',
        sellerName: "Luca's Pasta Club",
        sellerAuthor: 'Luca Buanchi',
        prepTime: '20 min',
        pickupAvailable: true,
        deliveryFee: 2.50,
      ),
      CartItemModel(
        foodId: 'food_biryani',
        name: 'Chiken Biriyani',
        price: 16.0,
        quantity: 2,
        image: AppAssets.homeRecipeCardImage3,
        sellerId: 'seller_3',
        sellerName: "Priya's Spice House",
        sellerAuthor: 'Priya Sharma',
        prepTime: '40 min',
        pickupAvailable: true,
        deliveryFee: 2.50,
      ),
    ]);
    _rebuildCartGroups();
  }

  void _rebuildCartGroups() {
    final Map<String, List<CartItemModel>> grouped = {};
    for (final item in cartItems) {
      final key = item.sellerName.isNotEmpty ? item.sellerName : item.sellerId;
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final List<CartGroupModel> groups = [];
    grouped.forEach((key, items) {
      final first = items.first;
      String restaurantImg = AppAssets.homeRecipeCardImage1;
      if (key.toLowerCase().contains('luca')) {
        restaurantImg = AppAssets.homeRecipeCardImage2;
      } else if (key.toLowerCase().contains('priya')) {
        restaurantImg = AppAssets.homeRecipeCardImage3;
      } else if (first.image.isNotEmpty) {
        restaurantImg = first.image;
      }

      groups.add(
        CartGroupModel(
          sellerId: first.sellerId,
          sellerName: first.sellerName,
          authorName: first.sellerAuthor,
          restaurantImage: restaurantImg,
          prepTime: first.prepTime,
          hasPickup: first.pickupAvailable,
          deliveryFee: first.deliveryFee,
          items: items,
        ),
      );
    });

    cartGroups.assignAll(groups);
    _recalculateTotals();
  }

  void _recalculateTotals() {
    int count = 0;
    double price = 0.0;
    for (final item in cartItems) {
      count += item.quantity;
      price += (item.price * item.quantity);
    }
    totalItems.value = count;
    totalSellers.value = cartGroups.length;
    totalPrice.value = price;
  }

  void incrementItem(String foodId) {
    final index = cartItems.indexWhere((element) => element.foodId == foodId);
    if (index != -1) {
      final item = cartItems[index];
      final newQuantity = item.quantity + 1;
      cartItems[index] = item.copyWith(quantity: newQuantity);
      _rebuildCartGroups();

      // Call API in background
      NetworkCaller.patchRequest(
        Urls.cartQuantity,
        body: {'foodId': foodId, 'action': 'increase'},
      );
    }
  }

  void decrementItem(String foodId) {
    final index = cartItems.indexWhere((element) => element.foodId == foodId);
    if (index != -1) {
      final item = cartItems[index];
      if (item.quantity > 1) {
        final newQuantity = item.quantity - 1;
        cartItems[index] = item.copyWith(quantity: newQuantity);
        _rebuildCartGroups();

        // Call API in background
        NetworkCaller.patchRequest(
          Urls.cartQuantity,
          body: {'foodId': foodId, 'action': 'decrease'},
        );
      }
    }
  }

  void deleteItem(String foodId) {
    final index = cartItems.indexWhere((element) => element.foodId == foodId);
    if (index != -1) {
      final removed = cartItems.removeAt(index);
      _rebuildCartGroups();

      Get.closeCurrentSnackbar();
      Get.snackbar(
        'Item Removed',
        '${removed.name} removed from your cart',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Call API in background
      NetworkCaller.deleteRequest('${Urls.cart}/$foodId');
    }
  }

  void bookmarkItem(String foodId) {
    final index = cartItems.indexWhere((element) => element.foodId == foodId);
    if (index != -1) {
      final item = cartItems[index];
      final newState = !item.isBookmarked;
      cartItems[index] = item.copyWith(isBookmarked: newState);
      _rebuildCartGroups();

      Get.closeCurrentSnackbar();
      Get.snackbar(
        'Bookmark',
        newState ? '${item.name} bookmarked' : 'Bookmark removed',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Call API in background
      NetworkCaller.postRequest(
        Urls.toggleBookmark,
        body: {'foodId': foodId},
      );
    }
  }

  void checkout() {
    Get.toNamed(Routes.revieworder);
  }

  // ---------------------------------------------------------------------------
  // ORDERS API (ACTIVE & HISTORY)
  // ---------------------------------------------------------------------------

  Future<void> fetchOrders() async {
    try {
      isLoadingOrders.value = true;
      final response = await NetworkCaller.getRequest(Urls.orders);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData = body is Map ? (body['data'] ?? body) : null;

        List<dynamic>? ordersList;
        if (rawData is Map && rawData['data'] is List) {
          ordersList = rawData['data'] as List;
        } else if (rawData is List) {
          ordersList = rawData;
        }

        if (ordersList != null && ordersList.isNotEmpty) {
          final List<Map<String, dynamic>> active = [];
          final List<Map<String, dynamic>> history = [];

          for (final o in ordersList) {
            if (o is Map<String, dynamic>) {
              final status = o['status']?.toString().toUpperCase() ?? '';
              if (status == 'DELIVERED' ||
                  status == 'COMPLETED' ||
                  status == 'CANCELLED') {
                history.add(o);
              } else {
                active.add(o);
              }
            }
          }

          if (active.isNotEmpty) activeOrders.assignAll(active);
          if (history.isNotEmpty) historyOrders.assignAll(history);
        }
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      isLoadingOrders.value = false;
    }
  }

  void setRating(int rating) {
    selectedRating.value = rating;
  }

  void onRefreshStatus() {
    fetchOrders();
    Get.snackbar(
      'Status Refreshed',
      'Order status is up to date.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  void onCancelOrder([String? orderId]) {
    final targetId = orderId ??
        (activeOrders.isNotEmpty
            ? activeOrders.first['id']?.toString()
            : null);

    Get.defaultDialog(
      title: 'Cancel Order',
      middleText: 'Are you sure you want to cancel this order?',
      textConfirm: 'Yes, Cancel',
      textCancel: 'Keep Order',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () async {
        Get.back();
        if (targetId != null && targetId.isNotEmpty) {
          final response = await NetworkCaller.patchRequest(
            '${Urls.orders}/$targetId/cancel',
          );
          if (response.isSuccess) {
            Get.snackbar(
              'Order Cancelled',
              'Your order has been cancelled successfully.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFEF4444),
              colorText: Colors.white,
            );
            fetchOrders();
          } else {
            Get.snackbar(
              'Cancel Order',
              response.errorMessage.isNotEmpty
                  ? response.errorMessage
                  : 'Order cancelled.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      },
    );
  }

  void onContactSeller() {
    Get.snackbar(
      'Contact Seller',
      'Opening chat with kitchen...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  void onSubmitReview([String? orderId, String? foodId]) {
    if (selectedRating.value == 0) {
      Get.snackbar(
        'Rating Required',
        'Please select a rating before submitting.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return;
    }

    final targetOrderId = orderId ??
        (activeOrders.isNotEmpty
            ? activeOrders.first['id']?.toString()
            : '6a8d619cb0849aa54585717b');
    final targetFoodId = foodId ?? '6a897de42f4aa7b54cd9298b';

    NetworkCaller.postRequest(
      Urls.reviews,
      body: {
        'orderId': targetOrderId,
        'foodId': targetFoodId,
        'rating': selectedRating.value,
        'comment': 'The food was absolutely delicious and freshly prepared!',
      },
    );

    Get.snackbar(
      'Review Submitted',
      'Thank you for your feedback!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
    selectedRating.value = 0;
  }
}
