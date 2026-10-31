import 'package:daily_meal_and_grocery_app/app/widgets/custom_back_button.dart';
import 'package:daily_meal_and_grocery_app/app/widgets/primary_button.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_assets.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../routes/app_routes.dart';
import '../../widgets/cart_item_card.dart';
import '../../widgets/cart_restaurant_card.dart';
import '../../widgets/checkout_bottom_bar.dart';
import '../../widgets/order_status_timeline_card.dart';
import '../../widgets/track_order_details_card.dart';
import '../../widgets/history_order_card.dart';
import '../../widgets/mycarts_shimmer.dart';
import '../controllers/mycarts_controller.dart';

class MycartsView extends GetView<MycartsController> {
  const MycartsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    children: [
                      const CustomBackButton(),
                      const SizedBox(width: 16),
                      Text(
                        'My Orders',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => TabBar(
                    controller: controller.tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2,
                    tabs: [
                      Tab(
                        text: controller.isLoadingCart.value
                            ? 'Cart'
                            : 'Cart (${controller.totalItems.value})',
                      ),
                      const Tab(text: 'Active'),
                      const Tab(text: 'History'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      _buildCartTab(context),
                      _buildActiveTab(),
                      _buildHistoryTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Obx(
                  () {
                    if (controller.currentTabIndex.value != 0) {
                      return const SizedBox.shrink();
                    }
                    if (controller.isLoadingCart.value) {
                      return const CheckoutBottomBarShimmer();
                    }
                    if (controller.cartGroups.isNotEmpty) {
                      return CheckoutBottomBar(
                        totalItems: controller.totalItems.value,
                        totalSellers: controller.totalSellers.value,
                        totalPrice: controller.totalPrice.value,
                        onCheckout: controller.checkout,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCart.value) {
        return const MyCartsShimmer();
      }

      if (controller.cartGroups.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore our delicious homemade meals and add your favorites to cart!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Browse Foods',
                  width: 180,
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Get.back();
                    } else {
                      Get.offAllNamed(Routes.navbar);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchCart,
        color: AppColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          itemCount: controller.cartGroups.length,
          itemBuilder: (context, index) {
            final group = controller.cartGroups[index];
            return CartRestaurantCard(
              restaurantImage: group.restaurantImage,
              restaurantName: group.sellerName,
              authorName: group.authorName,
              totalPrice: group.totalPrice,
              timeText: group.prepTime,
              hasPickup: group.hasPickup,
              deliveryFee: group.deliveryFee,
              items: group.items.map((item) {
                return CartItemCard(
                  imagePath: item.image,
                  title: item.name,
                  pricePerItem: item.price,
                  quantity: item.quantity,
                  isBookmarked: item.isBookmarked,
                  onIncrement: () => controller.incrementItem(item.foodId),
                  onDecrement: () => controller.decrementItem(item.foodId),
                  onBookmark: () => controller.bookmarkItem(item.foodId),
                  onDelete: () => controller.deleteItem(item.foodId),
                );
              }).toList(),
            );
          },
        ),
      );
    });
  }

  Widget _buildActiveTab() {
    return Obx(() {
      if (controller.isLoadingOrders.value &&
          controller.activeOrders.isEmpty) {
        return const ActiveOrdersShimmer();
      }

      final activeList = controller.activeOrders;
      if (activeList.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.fetchOrders,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 60, 32, 120),
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time_outlined,
                        size: 56,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Active Orders',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When you place an order, you can track its real-time preparation and delivery progress here.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Get.toNamed(Routes.homemadefoodgrid),
                      child: Text(
                        'Explore Foods',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchOrders,
        color: AppColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          itemCount: activeList.length,
          itemBuilder: (context, orderIndex) {
            final order = activeList[orderIndex];
            final items = (order['items'] is List)
                ? (order['items'] as List)
                : [];
            final firstItem =
                items.isNotEmpty && items.first is Map ? items.first as Map : null;

            final foodName =
                firstItem?['foodName']?.toString() ?? 'Order Item';
            final orderTitle = items.length > 1
                ? '$foodName + ${items.length - 1} more'
                : foodName;

            final restaurantName = controller.isSeller
                ? (order['recipientName']?.toString() ??
                    order['userName']?.toString() ??
                    'Customer')
                : (order['seller']?['sellerProfile']?['businessName']?.toString() ??
                    order['seller']?['name']?.toString() ??
                    order['sellerName']?.toString() ??
                    firstItem?['sellerName']?.toString() ??
                    'Kitchen');

            final foodImage = firstItem?['image']?.toString() ??
                firstItem?['foodImage']?.toString() ??
                AppAssets.homeRecipeCardImage1;

            final statusRaw = order['status']?.toString() ?? 'CONFIRMED';
            final statusDisplay = controller.formatStatusTitle(statusRaw);

            final totalPrice = order['totalPrice'] != null
                ? '\$${(order['totalPrice'] as num).toStringAsFixed(2)}'
                : '\$0.00';

            final itemsCount = items.fold<int>(
              0,
              (sum, it) =>
                  sum +
                  ((it is Map ? it['quantity'] as num? : null)?.toInt() ?? 1),
            );
            final itemsCountStr = itemsCount > 0
                ? '$itemsCount item${itemsCount > 1 ? 's' : ''}'
                : '1 item';

            final paymentMethodStr = controller.formatPaymentMethod(
                order['paymentMethod']?.toString() ?? 'CASH_ON_DELIVERY');

            final addrMap = order['deliveryAddress'] is Map
                ? order['deliveryAddress'] as Map
                : null;
            final street = addrMap?['streetAddress']?.toString() ?? '';
            final city = addrMap?['city']?.toString() ?? '';
            final addressStr = (street.isNotEmpty && city.isNotEmpty)
                ? '$street, $city'
                : (street.isNotEmpty
                    ? street
                    : (city.isNotEmpty ? city : 'Delivery Address'));

            final timeAgoStr =
                controller.formatTimeAgo(order['createdAt']?.toString());
            final timelineSteps = controller.buildTimelineSteps(order);

            final cleanStatus = statusRaw.toUpperCase().trim().replaceAll(' ', '_');
            final isSeller = controller.isSeller;

            // Buyer can cancel up to PREPARING:
            // PENDING_PAYMENT, CONFIRMED, NEW, ORDER_PLACED, ACCEPTED, PREPARING.
            // After PREPARING (OUT_FOR_DELIVERY, DELIVERED, COMPLETED, CANCELLED): button disappears.
            final canCancel = !isSeller &&
                (cleanStatus == 'CONFIRMED' ||
                    cleanStatus == 'NEW' ||
                    cleanStatus == 'ORDER_PLACED' ||
                    cleanStatus == 'PENDING_PAYMENT' ||
                    cleanStatus == 'ACCEPTED' ||
                    cleanStatus == 'PREPARING');

            return Column(
              children: [
                TrackOrderDetailsCard(
                  restaurantName: restaurantName,
                  restaurantImage: foodImage,
                  orderName: orderTitle,
                  timeAgo: timeAgoStr,
                  status: statusDisplay,
                  eta: '~20-30 min',
                  itemsAndPrice: '$itemsCountStr  •  $totalPrice',
                  paymentMethod: paymentMethodStr,
                  address: addressStr,
                  onContactSeller: () => controller.onContactSeller(order),
                ),
                const SizedBox(height: 16),
                OrderStatusTimelineCard(
                  steps: timelineSteps,
                  bottomActions: Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'Refresh Status',
                          showArrow: false,
                          isOutlined: isSeller || canCancel,
                          onPressed: controller.onRefreshStatus,
                        ),
                      ),
                      if (isSeller) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Update Status',
                            showArrow: false,
                            backgroundColor: AppColors.primary,
                            onPressed: () =>
                                controller.showUpdateStatusSheet(order),
                          ),
                        ),
                      ] else if (canCancel) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => controller.onCancelOrder(
                              order['id']?.toString(),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFFE4E6)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Cancel Order',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      );
    });
  }

  Widget _buildHistoryTab() {
    return Obx(() {
      if (controller.isLoadingOrders.value &&
          controller.historyOrders.isEmpty) {
        return const ActiveOrdersShimmer();
      }

      final historyList = controller.historyOrders;

      if (historyList.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.fetchOrders,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 60, 32, 120),
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.history_outlined,
                        size: 56,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Order History Yet',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your delivered, completed, and past orders will show up here with receipts and reordering options.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Get.toNamed(Routes.homemadefoodgrid),
                      child: Text(
                        'Start Ordering',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchOrders,
        color: AppColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final order = historyList[index];
            final items = (order['items'] is List)
                ? (order['items'] as List)
                : [];
            final firstItem =
                items.isNotEmpty && items.first is Map ? items.first as Map : null;

            final foodName =
                firstItem?['foodName']?.toString() ?? 'Food Order';
            final title = items.length > 1
                ? '$foodName (+${items.length - 1} items)'
                : foodName;

            final seller = order['seller']?['sellerProfile']
                        ?['businessName']
                    ?.toString() ??
                order['seller']?['name']?.toString() ??
                order['sellerName']?.toString() ??
                firstItem?['sellerName']?.toString() ??
                'Kitchen';

            final foodImg = firstItem?['image']?.toString() ??
                firstItem?['foodImage']?.toString() ??
                order['image']?.toString() ??
                AppAssets.homeRecipeCardImage1;

            final price =
                (order['totalPrice'] as num?)?.toDouble() ?? 0.0;
            final status = controller.formatStatusTitle(
                order['status']?.toString() ?? 'Delivered');
            final timeAgo =
                controller.formatTimeAgo(order['createdAt']?.toString());
            final qty = (firstItem?['quantity'] as num?)?.toInt() ?? 1;
            final orderId = order['id']?.toString() ?? '';

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: HistoryOrderCard(
                title: title,
                restaurantName: seller,
                imagePath: foodImg,
                status: status,
                timeAgo: timeAgo,
                price: price,
                quantity: qty,
                isReviewed: false,
                isSeller: controller.isSeller,
                onReceipt: () => controller.showReceipt(order),
                onReview: () => controller.openReviewDialog(order),
                onReorder: () => controller.onReorder(orderId),
              ),
            );
          },
        ),
      );
    });
  }
}
