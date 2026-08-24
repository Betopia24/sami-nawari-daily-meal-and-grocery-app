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
import '../controllers/mycarts_controller.dart';

class MycartsView extends GetView<MycartsController> {
  const MycartsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                'My Orders',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            TabBar(
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
              tabs: const [
                Tab(text: 'Cart (3)'),
                Tab(text: 'Active'),
                Tab(text: 'History'),
              ],
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Obx(
            () => controller.currentTabIndex.value == 0
                ? CheckoutBottomBar(
                    totalItems: controller.totalItems.value,
                    totalSellers: controller.totalSellers.value,
                    totalPrice: controller.totalPrice.value,
                    onCheckout: controller.checkout,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildCartTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Obx(
          () => CartRestaurantCard(
            restaurantImage: AppAssets.homeRecipeCardImage1,
            restaurantName: "Maria's Kitchen",
            authorName: "Maria Santos",
            totalPrice:
                controller.itemQuantities[0].value * controller.itemPrices[0],
            timeText: '25 min',
            hasPickup: true,
            deliveryFee: 2.50,
            items: [
              CartItemCard(
                imagePath: AppAssets.homeRecipeCardImage1,
                title: "Classic Mezze Platter",
                pricePerItem: controller.itemPrices[0],
                quantity: controller.itemQuantities[0].value,
                onIncrement: () => controller.incrementItem(0),
                onDecrement: () => controller.decrementItem(0),
                onBookmark: () => controller.bookmarkItem(0),
                onDelete: () => controller.deleteItem(0),
              ),
            ],
          ),
        ),
        Obx(
          () => CartRestaurantCard(
            restaurantImage: AppAssets.homeRecipeCardImage2,
            restaurantName: "Luca's Pasta Club",
            authorName: "Luca Buanchi",
            totalPrice:
                (controller.itemQuantities[1].value *
                    controller.itemPrices[1]) +
                (controller.itemQuantities[2].value * controller.itemPrices[2]),
            timeText: '20 min',
            hasPickup: true,
            deliveryFee: 2.50,
            items: [
              CartItemCard(
                imagePath: AppAssets.homeRecipeCardImage2,
                title: "Cacio e Pepe",
                pricePerItem: controller.itemPrices[1],
                quantity: controller.itemQuantities[1].value,
                onIncrement: () => controller.incrementItem(1),
                onDecrement: () => controller.decrementItem(1),
                onBookmark: () => controller.bookmarkItem(1),
                onDelete: () => controller.deleteItem(1),
              ),
              CartItemCard(
                imagePath: AppAssets.homeRecipeCardImage2,
                title: "Tiramisu",
                pricePerItem: controller.itemPrices[2],
                quantity: controller.itemQuantities[2].value,
                onIncrement: () => controller.incrementItem(2),
                onDecrement: () => controller.decrementItem(2),
                onBookmark: () => controller.bookmarkItem(2),
                onDelete: () => controller.deleteItem(2),
              ),
            ],
          ),
        ),
        Obx(
          () => CartRestaurantCard(
            restaurantImage: AppAssets.homeRecipeCardImage3,
            restaurantName: "Priya's Spice House",
            authorName: "Priya Sharma",
            totalPrice:
                controller.itemQuantities[3].value * controller.itemPrices[3],
            timeText: '40 min',
            hasPickup: true,
            deliveryFee: 2.50,
            items: [
              CartItemCard(
                imagePath: AppAssets.homeRecipeCardImage3,
                title: "Chiken Biriyani",
                pricePerItem: controller.itemPrices[3],
                quantity: controller.itemQuantities[3].value,
                onIncrement: () => controller.incrementItem(3),
                onDecrement: () => controller.decrementItem(3),
                onBookmark: () => controller.bookmarkItem(3),
                onDelete: () => controller.deleteItem(3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TrackOrderDetailsCard(
            restaurantName: 'Maria\'s Kitchen',
            restaurantImage: AppAssets.homeRecipeCardImage1,
            orderName: 'Classic Mezze Platter',
            timeAgo: '15 min ago',
            status: 'Preparing',
            eta: '~10 min',
            itemsAndPrice: '1 item  •  \$20.50',
            paymentMethod: 'Cash on Delivery',
            address: '123 Main St, San Francisco',
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
              OrderStatusStep(title: 'Completed', time: '', isCompleted: false),
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
                    onPressed: controller.onCancelOrder,
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
          Obx(
            () => LeaveReviewCard(
              selectedRating: controller.selectedRating.value,
              onRatingChanged: controller.setRating,
              onSubmit: controller.onSubmitReview,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        HistoryOrderCard(
          title: 'Pork & Chive Dumplings (12pc)',
          restaurantName: 'Chen\'s Dim Sum',
          imagePath: AppAssets.homeRecipeCardImage1, // Placeholder
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
          restaurantName: 'Priya\'s Spice House',
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
          restaurantName: 'Maria\'s Kitchen',
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
  }
}
