import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../controllers/fooddetails_controller.dart';
import '../../widgets/food_badge.dart';
import '../../widgets/ingredient_item.dart';
import '../../widgets/popular_dish_card.dart';
import '../../widgets/store_info_tile.dart';
import '../../widgets/sticky_cart_bottom_bar.dart';
import '../../../../widgets/floating_seam_sliver_header.dart';
import '../../../../widgets/custom_recipe_cover.dart';

class FooddetailsView extends GetView<FooddetailsController> {
  const FooddetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F8),
      bottomNavigationBar: Obx(
        () => StickyCartBottomBar(
          quantity: controller.quantity.value,
          price: controller.totalPrice,
          onDecrement: controller.decrementQuantity,
          onIncrement: controller.incrementQuantity,
          onAddToCart: controller.addToCart,
          onViewCart: controller.viewCart,
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              FloatingSeamSliverHeader(
                expandedHeight: 360,
                toolbarHeight: 127,
                floatingCardOverhang: 55,
                titleBottomOffset: 20,
                gradientHeight: 140,
                imageWidget: Obx(
                  () => _buildHeaderImage(controller.foodImage.value),
                ),
                titleWidget: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.foodName.value,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.surface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.sellerName.value,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.surface.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingCard: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.formattedUnitPrice,
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: AppColors.secondary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      controller.rating.value,
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  controller.reviewCount.value,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              FoodBadge(
                                text: controller.prepTime.value,
                                iconPath: AppAssets.clockIcon,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              FoodBadge(
                                text: controller.category.value,
                                iconPath: AppAssets.serveIcon,
                                color: AppColors.textSecondary,
                              ),
                              if (controller.pickupAvailable.value) ...[
                                const SizedBox(width: 8),
                                const FoodBadge(
                                  text: 'Pickup',
                                  iconPath: AppAssets.pickupIcon,
                                  color: AppColors.primary,
                                ),
                              ],
                              if (controller.deliveryAvailable.value) ...[
                                const SizedBox(width: 8),
                                const FoodBadge(
                                  text: 'Delivery',
                                  iconPath: AppAssets.deliveryIcon,
                                  color: AppColors.secondary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Remaining Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 72), // Adjusted for 55px card overhang
                    // Tab Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TabBar(
                          controller: controller.tabController,
                          indicator: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: const EdgeInsets.all(4),
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: AppColors.textSecondary,
                          labelStyle: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: const [
                            Tab(text: 'Details'),
                            Tab(text: 'Ingredients'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      // Details Tab
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'DESCRIPTION',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.description.value,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Popular Dishes',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 220,
                                child: controller.popularDishes.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            controller.popularDishes.length,
                                        itemBuilder: (context, index) {
                                          final dish =
                                              controller.popularDishes[index];
                                          return PopularDishCard(
                                            imagePath: dish.firstImage.isNotEmpty
                                                ? dish.firstImage
                                                : AppAssets.homeDinnerCardImage,
                                            title: dish.name,
                                            price:
                                                '\$${dish.price.toStringAsFixed(2)}',
                                            isPopular: index == 0,
                                            onTap: () => controller
                                                .navigateToFood(dish.id),
                                          );
                                        },
                                      )
                                    : ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: const [
                                          PopularDishCard(
                                            imagePath:
                                                AppAssets.homeDinnerCardImage,
                                            title: 'Classic Mezze Platter',
                                            price: '\$18.00',
                                            isPopular: true,
                                          ),
                                          PopularDishCard(
                                            imagePath:
                                                AppAssets.homeLunchCardImage,
                                            title: 'Chicken Shawarma',
                                            price: '\$14.00',
                                            isPopular: false,
                                          ),
                                        ],
                                      ),
                              ),
                              const SizedBox(height: 24),
                              StoreInfoTile(
                                imagePath: controller
                                        .sellerProfilePicture.value.isNotEmpty
                                    ? controller.sellerProfilePicture.value
                                    : AppAssets.homeRecipeCardImage3,
                                title: controller.sellerName.value,
                                subtitle: controller.sellerAddress.value.isNotEmpty
                                    ? controller.sellerAddress.value
                                    : 'Mezze platters & fresh pita',
                                distance: '0.4 km away',
                                isOpen: true,
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                      // Ingredients Tab
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'INGREDIENTS',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF4F2EE),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${controller.ingredients.length} items',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  children: controller.ingredients
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    final isLast = index ==
                                        controller.ingredients.length - 1;
                                    return IngredientItem(
                                      name: item['name'] ?? '',
                                      quantity: item['quantity'] ?? '',
                                      isLast: isLast,
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Floating Pinned Buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: GestureDetector(
              onTap: controller.toggleBookmark,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Obx(
                    () => SvgPicture.asset(
                      controller.isBookmarked.value
                          ? AppAssets.bookmarkFilledIcon
                          : AppAssets.bookmarkIcon,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        controller.isBookmarked.value
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const CustomRecipeCover(height: 360),
      );
    }
    return Image.asset(
      path.isNotEmpty ? path : AppAssets.homeRecipeCardImage3,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const CustomRecipeCover(height: 360),
    );
  }
}
