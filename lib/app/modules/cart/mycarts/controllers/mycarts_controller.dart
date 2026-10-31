import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/cart_model.dart';
import '../../../../data/network/local_storage.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';
import '../../../../routes/app_routes.dart';
import '../../widgets/order_status_timeline_card.dart';

class MycartsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Cart state
  final RxBool isLoadingCart = true.obs;
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxList<CartGroupModel> cartGroups = <CartGroupModel>[].obs;

  final totalItems = 0.obs;
  final totalSellers = 0.obs;
  final totalPrice = 0.0.obs;

  final currentTabIndex = 0.obs;

  // Active orders state
  final RxBool isLoadingOrders = true.obs;
  final RxList<Map<String, dynamic>> activeOrders =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> historyOrders =
      <Map<String, dynamic>>[].obs;

  // Role & seller status update state
  final RxString userRole = 'BUYER'.obs;
  bool get isSeller => userRole.value.toUpperCase() == 'SELLER';
  final RxBool isUpdatingStatus = false.obs;

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

    loadUserRole();
    fetchCart();
    fetchOrders();
  }

  Future<void> loadUserRole() async {
    final role = (await LocalStorage.getRole()) ?? LocalStorage.roleSync ?? 'BUYER';
    userRole.value = role;
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
      if (cartItems.isEmpty) {
        _loadDefaultCart();
      }
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
      final key = item.sellerId.isNotEmpty ? item.sellerId : item.sellerName;
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final List<CartGroupModel> groups = [];
    grouped.forEach((key, items) {
      final first = items.first;
      String restaurantImg = AppAssets.homeRecipeCardImage1;
      final lowerKey = key.toLowerCase();
      final lowerName = first.sellerName.toLowerCase();

      if (lowerKey.contains('luca') ||
          lowerName.contains('luca') ||
          lowerName.contains('pasta') ||
          lowerName.contains('pizza')) {
        restaurantImg = AppAssets.homeRecipeCardImage2;
      } else if (lowerKey.contains('priya') ||
          lowerName.contains('priya') ||
          lowerName.contains('spice') ||
          lowerName.contains('biryani')) {
        restaurantImg = AppAssets.homeRecipeCardImage3;
      } else if (lowerKey.contains('chen') ||
          lowerName.contains('chen') ||
          lowerName.contains('dim sum')) {
        restaurantImg = AppAssets.homeRecipeCardImage1;
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
      final role = (await LocalStorage.getRole()) ?? LocalStorage.roleSync ?? 'BUYER';
      userRole.value = role;

      final isSellerRole = role.toUpperCase() == 'SELLER';
      final endpoint = isSellerRole
          ? '${Urls.sellerOrders}?page=1&limit=10'
          : '${Urls.orders}?page=1&limit=10';

      final response = await NetworkCaller.getRequest(endpoint);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        dynamic rawData = body is Map ? (body['data'] ?? body) : null;

        List<dynamic>? ordersList;
        if (rawData is Map && rawData['data'] is List) {
          ordersList = rawData['data'] as List;
        } else if (rawData is List) {
          ordersList = rawData;
        }

        final List<Map<String, dynamic>> active = [];
        final List<Map<String, dynamic>> history = [];

        if (ordersList != null) {
          for (final o in ordersList) {
            if (o is Map) {
              final map = Map<String, dynamic>.from(o);
              final status = map['status']?.toString().toUpperCase() ?? '';
              if (status == 'DELIVERED' ||
                  status == 'COMPLETED' ||
                  status == 'CANCELLED') {
                history.add(map);
              } else {
                active.add(map);
              }
            }
          }
        }

        activeOrders.assignAll(active);
        historyOrders.assignAll(history);
      } else {
        activeOrders.clear();
        historyOrders.clear();
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      activeOrders.clear();
      historyOrders.clear();
    } finally {
      isLoadingOrders.value = false;
    }
  }

  List<OrderStatusStep> buildTimelineSteps(Map<String, dynamic> order) {
    final status = (order['status']?.toString().toUpperCase() ?? 'CONFIRMED').trim();
    final createdAtStr = order['createdAt']?.toString();
    final updatedAtStr = order['updatedAt']?.toString();
    final createdTime = formatClockTime(createdAtStr);
    final updatedTime = formatClockTime(updatedAtStr);

    int rank = 1;
    switch (status) {
      case 'PENDING_PAYMENT':
      case 'CONFIRMED':
        rank = 1;
        break;
      case 'ACCEPTED':
        rank = 2;
        break;
      case 'PREPARING':
        rank = 3;
        break;
      case 'OUT_FOR_DELIVERY':
        rank = 4;
        break;
      case 'DELIVERED':
        rank = 5;
        break;
      case 'COMPLETED':
        rank = 6;
        break;
      case 'CANCELLED':
        rank = -1;
        break;
      default:
        rank = 1;
    }

    if (rank == -1) {
      return [
        OrderStatusStep(
          title: 'Order Placed',
          time: createdTime.isNotEmpty ? createdTime : 'Placed',
          isCompleted: true,
        ),
        OrderStatusStep(
          title: 'Order Cancelled',
          time: updatedTime.isNotEmpty ? updatedTime : 'Cancelled',
          isCompleted: true,
        ),
      ];
    }

    return [
      OrderStatusStep(
        title: 'Order Placed',
        time: createdTime.isNotEmpty ? createdTime : 'Placed',
        isCompleted: rank >= 1,
      ),
      OrderStatusStep(
        title: 'Accepted',
        time: rank >= 2 ? (updatedTime.isNotEmpty ? updatedTime : 'Accepted') : '',
        isCompleted: rank >= 2,
      ),
      OrderStatusStep(
        title: 'Preparing',
        time: rank >= 3 ? (updatedTime.isNotEmpty ? updatedTime : 'In Kitchen') : '',
        isCompleted: rank >= 3,
      ),
      OrderStatusStep(
        title: 'Out for Delivery',
        time: rank >= 4 ? (updatedTime.isNotEmpty ? updatedTime : 'On the way') : '',
        isCompleted: rank >= 4,
      ),
      OrderStatusStep(
        title: 'Delivered',
        time: rank >= 5 ? (updatedTime.isNotEmpty ? updatedTime : 'Delivered') : '',
        isCompleted: rank >= 5,
      ),
      OrderStatusStep(
        title: 'Completed',
        time: rank >= 6 ? (updatedTime.isNotEmpty ? updatedTime : 'Completed') : '',
        isCompleted: rank >= 6,
      ),
    ];
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

    if (targetId == null || targetId.isEmpty) return;

    Get.defaultDialog(
      title: 'Cancel Order',
      titleStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700),
      middleText: 'Are you sure you want to cancel this order?',
      middleTextStyle: GoogleFonts.outfit(),
      textConfirm: 'Yes, Cancel',
      textCancel: 'Keep Order',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () async {
        Get.back();
        final response = await NetworkCaller.patchRequest(
          Urls.cancelOrder(targetId),
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
                : 'Failed to cancel order.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }

  void onContactSeller([Map<String, dynamic>? order]) {
    final phone = isSeller
        ? (order?['contactPhone']?.toString() ??
            (order?['deliveryAddress'] is Map
                ? (order?['deliveryAddress'] as Map)['phone']?.toString()
                : null) ??
            '')
        : (order?['seller']?['phone']?.toString() ??
            order?['contactPhone']?.toString() ??
            '');
    final label = isSeller ? 'Contact Customer' : 'Contact Seller';
    final target = isSeller ? 'Customer' : 'Seller';
    Get.snackbar(
      label,
      phone.isNotEmpty ? '$target contact: $phone' : 'Connecting to $target...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  /// Update order status for seller (PATCH /orders/seller/:orderId/status)
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    if (orderId.isEmpty) return false;
    try {
      isUpdatingStatus.value = true;
      final endpoint = Urls.getOrderStatusUpdateUrl(orderId);
      final response = await NetworkCaller.patchRequest(
        endpoint,
        body: {'status': newStatus},
      );
      if (response.isSuccess) {
        final display = formatStatusTitle(newStatus);
        Get.snackbar(
          'Status Updated',
          response.successMessage ?? 'Order status updated to $display',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B5E37),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        await fetchOrders();
        return true;
      } else {
        Get.snackbar(
          'Update Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update order status',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update order status: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  /// Displays interactive status selection bottom sheet for seller
  void showUpdateStatusSheet(Map<String, dynamic> order) {
    final orderId = order['id']?.toString() ?? '';
    if (orderId.isEmpty) return;

    final currentStatus = (order['status']?.toString() ?? 'CONFIRMED').toUpperCase();
    final selectedStatus = currentStatus.obs;

    final statusOptions = const [
      _OrderStatusOption(
        key: 'ACCEPTED',
        label: 'Accepted',
        description: 'Order accepted, awaiting preparation',
        icon: Icons.check_circle_outline,
        color: Color(0xFF10B981),
      ),
      _OrderStatusOption(
        key: 'PREPARING',
        label: 'Preparing',
        description: 'Kitchen is currently preparing food',
        icon: Icons.soup_kitchen_outlined,
        color: Color(0xFFF59E0B),
      ),
      _OrderStatusOption(
        key: 'OUT_FOR_DELIVERY',
        label: 'Out for Delivery',
        description: 'Order is on the way to customer',
        icon: Icons.delivery_dining_outlined,
        color: Color(0xFF3B82F6),
      ),
      _OrderStatusOption(
        key: 'DELIVERED',
        label: 'Delivered',
        description: 'Order delivered to customer',
        icon: Icons.done_all_rounded,
        color: Color(0xFF8B5CF6),
      ),
      _OrderStatusOption(
        key: 'COMPLETED',
        label: 'Completed',
        description: 'Order fulfilled and completed',
        icon: Icons.verified_outlined,
        color: Color(0xFF059669),
      ),
      _OrderStatusOption(
        key: 'CANCELLED',
        label: 'Cancelled',
        description: 'Reject or cancel this order',
        icon: Icons.cancel_outlined,
        color: Color(0xFFEF4444),
      ),
    ];

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update Order Status',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Order #${order['orderNumber'] ?? orderId}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: statusOptions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final opt = statusOptions[index];
                  return Obx(() {
                    final isSelected = selectedStatus.value == opt.key;
                    final isCurrent = currentStatus == opt.key;
                    return InkWell(
                      onTap: () {
                        selectedStatus.value = opt.key;
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? opt.color.withValues(alpha: 0.08)
                              : const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? opt.color : Colors.grey.shade200,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: opt.color.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(opt.icon, size: 20, color: opt.color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        opt.label,
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? opt.color : AppColors.textPrimary,
                                        ),
                                      ),
                                      if (isCurrent) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'Current',
                                            style: GoogleFonts.outfit(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    opt.description,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? opt.color : Colors.grey.shade400,
                                  width: isSelected ? 6.5 : 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 18),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isUpdatingStatus.value
                    ? null
                    : () async {
                        final success = await updateOrderStatus(orderId, selectedStatus.value);
                        if (success) {
                          Get.back();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: isUpdatingStatus.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Confirm Status Update',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            )),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> onReorder(String orderId) async {
    if (orderId.isEmpty) return;
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final response = await NetworkCaller.postRequest(Urls.reorder(orderId));
      Get.back(); // Dismiss progress
      if (response.isSuccess) {
        Get.snackbar(
          'Reordered Successfully',
          'Your reorder has been placed!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        await fetchOrders();
        await fetchCart();
      } else {
        Get.snackbar(
          'Reorder',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to reorder. Please try adding items manually.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      debugPrint('Error reordering: $e');
    }
  }

  void openReviewDialog(Map<String, dynamic> order) {
    final items = (order['items'] is List) ? (order['items'] as List) : [];
    final firstItem = items.isNotEmpty && items.first is Map ? items.first as Map : null;
    final foodId = firstItem?['foodId']?.toString() ?? '';
    final orderId = order['id']?.toString() ?? '';
    final foodName = firstItem?['foodName']?.toString() ?? 'Meal';

    int dialogRating = 5;
    final commentController = TextEditingController();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Review $foodName',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How was your food experience?',
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return IconButton(
                      icon: Icon(
                        starIndex <= dialogRating ? Icons.star : Icons.star_border,
                        color: AppColors.secondary,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          dialogRating = starIndex;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write a few words about your order...',
                    hintStyle: GoogleFonts.outfit(fontSize: 13, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  Get.back();
                  await submitReviewApi(
                    orderId: orderId,
                    foodId: foodId,
                    rating: dialogRating,
                    comment: commentController.text.trim().isNotEmpty
                        ? commentController.text.trim()
                        : 'Great food, freshly prepared and delicious!',
                  );
                },
                child: Text('Submit', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> submitReviewApi({
    required String orderId,
    required String foodId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await NetworkCaller.postRequest(
        Urls.reviews,
        body: {
          if (orderId.isNotEmpty) 'orderId': orderId,
          if (foodId.isNotEmpty) 'foodId': foodId,
          'rating': rating,
          'comment': comment,
        },
      );
      if (response.isSuccess) {
        Get.snackbar(
          'Review Submitted',
          'Thank you for your valuable feedback!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
        fetchOrders();
      } else {
        Get.snackbar(
          'Review',
          response.errorMessage.isNotEmpty ? response.errorMessage : 'Failed to submit review.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error submitting review: $e');
    }
  }

  void showReceipt(Map<String, dynamic> order) {
    final items = (order['items'] is List) ? (order['items'] as List) : [];
    final orderNumber = order['orderNumber']?.toString() ?? 'N/A';
    final dateStr = formatDateTime(order['createdAt']?.toString());
    final subTotal = (order['subTotal'] as num?)?.toDouble() ?? 0.0;
    final deliveryFee = (order['deliveryFee'] as num?)?.toDouble() ?? 0.0;
    final discount = (order['discount'] as num?)?.toDouble() ?? 0.0;
    final total = (order['totalPrice'] as num?)?.toDouble() ?? 0.0;
    final paymentMethod = formatPaymentMethod(order['paymentMethod']?.toString() ?? 'CASH_ON_DELIVERY');
    final status = formatStatusTitle(order['status']?.toString() ?? 'COMPLETED');

    final addrMap = order['deliveryAddress'] is Map ? order['deliveryAddress'] as Map : null;
    final street = addrMap?['streetAddress']?.toString() ?? '';
    final city = addrMap?['city']?.toString() ?? '';
    final fullAddr = (street.isNotEmpty && city.isNotEmpty) ? '$street, $city' : (street.isNotEmpty ? street : city);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Receipt',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5EF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3A8F5C),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Order #$orderNumber • $dateStr',
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
              ),
              const Divider(height: 32),
              Text(
                'Items',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...items.map((it) {
                if (it is! Map) return const SizedBox.shrink();
                final name = it['foodName']?.toString() ?? 'Item';
                final qty = (it['quantity'] as num?)?.toInt() ?? 1;
                final unitPrice = (it['unitPrice'] as num?)?.toDouble() ?? 0.0;
                final sub = (it['subtotal'] as num?)?.toDouble() ?? (qty * unitPrice);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '$name × $qty',
                          style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textPrimary),
                        ),
                      ),
                      Text(
                        '\$${sub.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(height: 24),
              _receiptRow('Subtotal', '\$${subTotal.toStringAsFixed(2)}'),
              _receiptRow('Delivery Fee', '\$${deliveryFee.toStringAsFixed(2)}'),
              if (discount > 0) _receiptRow('Discount', '-\$${discount.toStringAsFixed(2)}'),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (fullAddr.isNotEmpty) ...[
                Text(
                  'Delivered to: $fullAddr',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                'Payment: $paymentMethod',
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    'Close',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String formatTimeAgo(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Recently';
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return 'Recently';
    final diff = DateTime.now().difference(dt.toLocal());
    if (diff.inDays >= 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays >= 7) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  String formatClockTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return '';
    final local = dt.toLocal();
    final hour = local.hour == 0 ? 12 : (local.hour > 12 ? local.hour - 12 : local.hour);
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  String formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return '';
    final local = dt.toLocal();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${local.day} ${months[local.month - 1]} ${local.year}, ${formatClockTime(dateStr)}';
  }

  String formatStatusTitle(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING_PAYMENT':
        return 'Payment Pending';
      case 'CONFIRMED':
        return 'Order Placed';
      case 'ACCEPTED':
        return 'Accepted';
      case 'PREPARING':
        return 'Preparing';
      case 'OUT_FOR_DELIVERY':
        return 'Out for Delivery';
      case 'DELIVERED':
        return 'Delivered';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        if (status.isEmpty) return 'Active';
        return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  String formatPaymentMethod(String method) {
    switch (method.toUpperCase()) {
      case 'CASH_ON_DELIVERY':
        return 'Cash on Delivery';
      case 'STRIPE':
      case 'CARD':
        return 'Card Payment';
      case 'WALLET':
        return 'Wallet';
      default:
        return 'Cash on Delivery';
    }
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

    final targetOrderId = (orderId ??
        (activeOrders.isNotEmpty
            ? activeOrders.first['id']?.toString()
            : null)) ??
        '';
    final targetFoodId = foodId ?? '';

    submitReviewApi(
      orderId: targetOrderId,
      foodId: targetFoodId,
      rating: selectedRating.value,
      comment: 'The food was absolutely delicious and freshly prepared!',
    );
    selectedRating.value = 0;
  }
}

class _OrderStatusOption {
  final String key;
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const _OrderStatusOption({
    required this.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });
}
