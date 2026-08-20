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
          onAddToCart: () {},
          onViewCart: () {},
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              FloatingSeamSliverHeader(
                expandedHeight: 335,
                toolbarHeight: 127,
                floatingCardOverhang: 55,
                titleBottomOffset: 20,
                gradientHeight: 140,
                imagePath: AppAssets.homeRecipeCardImage3, // Mock image
                titleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chicken Biriyani Tiffin',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Maria's Kitchen",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.surface.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                floatingCard: Container(
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
                            '\$18.00',
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
                                    color: AppColors.secondary, // Uses orange/amber from AppColors
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.7',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '84 reviews',
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
                            const FoodBadge(
                              text: '20 min',
                              iconPath: AppAssets.clockIcon,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            FoodBadge(
                              text: 'Lunch',
                              iconPath: AppAssets.serveIcon,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            const FoodBadge(
                              text: 'Pickup',
                              iconPath: AppAssets.pickupIcon,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            const FoodBadge(
                              text: 'Delivery',
                              iconPath: AppAssets.deliveryIcon,
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ],
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
                              dividerColor: Colors
                                  .transparent, // Removes the default grey line at the bottom
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
                        child: Column(
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
                              'Hummus, baba ghanoush, tabbouleh, olives, and fresh pita for 2. A taste of the Mediterranean coast.',
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
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: const [
                                  PopularDishCard(
                                    imagePath: AppAssets.homeDinnerCardImage,
                                    title: 'Classic Mezze Platter',
                                    price: '\$18',
                                    isPopular: true,
                                  ),
                                  PopularDishCard(
                                    imagePath: AppAssets.homeLunchCardImage,
                                    title: 'Chicken Shawarma',
                                    price: '\$14',
                                    isPopular: false,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            const StoreInfoTile(
                              imagePath: AppAssets.homeRecipeCardImage3,
                              title: "Maria's Kitchen",
                              subtitle: 'Mezze platters & fresh pita',
                              distance: '0.4 km away',
                              isOpen: true,
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                      // Ingredients Tab
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    '8 items',
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
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: const Column(
                                children: [
                                  IngredientItem(
                                    name: 'Chickpeas',
                                    quantity: '200g',
                                  ),
                                  IngredientItem(
                                    name: 'Tahini',
                                    quantity: '3 tbsp',
                                  ),
                                  IngredientItem(
                                    name: 'Lemon juice',
                                    quantity: '2 tbsp',
                                  ),
                                  IngredientItem(
                                    name: 'Garlic',
                                    quantity: '2 cloves',
                                  ),
                                  IngredientItem(
                                    name: 'Baba ganoush',
                                    quantity: '100g',
                                  ),
                                  IngredientItem(
                                    name: 'Tabbouleh',
                                    quantity: '80g',
                                  ),
                                  IngredientItem(
                                    name: 'Kalamata olives',
                                    quantity: '60g',
                                  ),
                                  IngredientItem(
                                    name: 'Fresh pita bread',
                                    quantity: '4 pcs',
                                    isLast: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
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
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.bookmarkIcon,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textPrimary,
                      BlendMode.srcIn,
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
}
