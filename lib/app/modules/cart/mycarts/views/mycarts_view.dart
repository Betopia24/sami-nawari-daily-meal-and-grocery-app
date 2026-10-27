import 'package:daily_meal_and_grocery_app/app/widgets/custom_back_button.dart';
import 'package:daily_meal_and_grocery_app/app/widgets/primary_button.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_assets.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/cart_item_card.dart';
import '../../widgets/cart_restaurant_card.dart';
import '../../widgets/checkout_bottom_bar.dart';
import '../../widgets/leave_review_card.dart';
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
                      _buildCartTab(),
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

  Widget _buildCartTab() {
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
                  onPressed: () => Get.back(),
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
      final hasActive = activeList.isNotEmpty;
      final firstOrder = hasActive ? activeList.first : null;

      final restaurantName = firstOrder?['seller']?['name']?.toString() ??
          firstOrder?['sellerName']?.toString() ??
          "Maria's Kitchen";
      final orderTitle = (firstOrder?['items'] is List &&
              (firstOrder!['items'] as List).isNotEmpty)
          ? firstOrder['items'][0]['foodName']?.toString() ??
              'Classic Mezze Platter'
          : 'Classic Mezze Platter';
      final status = firstOrder?['status']?.toString() ?? 'Preparing';
      final totalPrice = firstOrder?['totalPrice'] != null
          ? '\$${(firstOrder!['totalPrice'] as num).toStringAsFixed(2)}'
          : '\$20.50';
      final address = firstOrder?['deliveryAddress'] is Map
          ? '${firstOrder!['deliveryAddress']['streetAddress'] ?? ''}, ${firstOrder['deliveryAddress']['city'] ?? ''}'
          : '123 Main St, San Francisco';

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        child: Column(
          children: [
            TrackOrderDetailsCard(
              restaurantName: restaurantName,
              restaurantImage: AppAssets.homeRecipeCardImage1,
              orderName: orderTitle,
              timeAgo: '15 min ago',
              status: status,
              eta: '~10 min',
              itemsAndPrice: '1 item  •  $totalPrice',
              paymentMethod: 'Cash on Delivery',
              address: address,
              onContactSeller: controller.onContactSeller,
            ),
            const SizedBox(height: 16),
            OrderStatusTimelineCard(
              steps: [
                OrderStatusStep(
                  title: 'Order Placed',
                  time: '02:41 PM',
                  isCompleted: true,
                ),
                OrderStatusStep(
                  title: 'Accepted',
                  time: '02:42 PM',
                  isCompleted: true,
                ),
                OrderStatusStep(
                  title: 'Preparing',
                  time: '02:45 PM',
                  isCompleted: true,
                ),
                OrderStatusStep(
                  title: 'Out for Delivery',
                  time: '03:15 PM',
                  isCompleted: false,
                ),
                OrderStatusStep(
                  title: 'Delivered',
                  time: '03:25 PM',
                  isCompleted: false,
                ),
                OrderStatusStep(
                  title: 'Completed',
                  time: '',
                  isCompleted: false,
                ),
              ],
              bottomActions: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: 'Refresh Status',
                      showArrow: false,
                      onPressed: controller.onRefreshStatus,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.onCancelOrder(
                        firstOrder?['id']?.toString(),
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
              ),
            ),
            const SizedBox(height: 16),
            LeaveReviewCard(
              selectedRating: controller.selectedRating.value,
              onRatingChanged: controller.setRating,
              onSubmit: () => controller.onSubmitReview(
                firstOrder?['id']?.toString(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildHistoryTab() {
    return Obx(() {
      final historyList = controller.historyOrders;

      if (historyList.isNotEmpty) {
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final order = historyList[index];
            final title = (order['items'] is List &&
                    (order['items'] as List).isNotEmpty)
                ? order['items'][0]['foodName']?.toString() ?? 'Food Item'
                : 'Delicious Meal';
            final seller = order['sellerName']?.toString() ?? "Kitchen";
            final price = (order['totalPrice'] as num?)?.toDouble() ?? 20.0;
            final status = order['status']?.toString() ?? 'Delivered';

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: HistoryOrderCard(
                title: title,
                restaurantName: seller,
                imagePath: AppAssets.homeRecipeCardImage1,
                status: status,
                timeAgo: 'Recently',
                price: price,
                quantity: 1,
                isReviewed: false,
                onReceipt: () {},
                onReview: () {},
                onReorder: () {},
              ),
            );
          },
        );
      }

      // Default curated history cards
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          HistoryOrderCard(
            title: 'Pork & Chive Dumplings (12pc)',
            restaurantName: "Chen's Dim Sum",
            imagePath: AppAssets.homeRecipeCardImage1,
            status: 'Picked Up',
            timeAgo: '3 days ago',
            price: 22.00,
            quantity: 2,
            isReviewed: true,
            reviewScore: 5,
            onReceipt: () {},
            onReview: () {},
            onReorder: () {},
          ),
          const SizedBox(height: 16),
          HistoryOrderCard(
            title: 'Chiken Biriyani',
            restaurantName: "Priya's Spice House",
            imagePath: AppAssets.homeRecipeCardImage3,
            status: 'Delivered',
            timeAgo: '1 weeks ago',
            price: 32.00,
            quantity: 1,
            isReviewed: false,
            onReceipt: () {},
            onReview: () {},
            onReorder: () {},
          ),
          const SizedBox(height: 16),
          HistoryOrderCard(
            title: 'Classic Mezze Platter',
            restaurantName: "Maria's Kitchen",
            imagePath: AppAssets.homeRecipeCardImage2,
            status: 'Delivered',
            timeAgo: '2 weeks ago',
            price: 20.50,
            quantity: 1,
            isReviewed: true,
            reviewScore: 5,
            onReceipt: () {},
            onReview: () {},
            onReorder: () {},
          ),
        ],
      );
    });
  }
}
