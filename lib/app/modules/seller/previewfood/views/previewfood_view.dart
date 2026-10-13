import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/previewfood_controller.dart';
import '../widgets/preview_food_header_card.dart';
import '../widgets/preview_ingredient_tile.dart';
import '../widgets/preview_method_step_card.dart';
import '../../../../widgets/custom_back_button.dart';
import '../widgets/preview_food_sliver_header.dart';

import '../widgets/submit_success_widget.dart';

class PreviewfoodView extends GetView<PreviewfoodController> {
  const PreviewfoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isSubmitted.value) {
        return const SubmitSuccessWidget();
      }

      return Scaffold(
        backgroundColor: const Color(0xFFFAF9F8),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: PrimaryButton(
            text: 'Submit for Review',
            onPressed: () {
              controller.submit();
            },
          ),
        ),
        appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F8),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        leadingWidth: 72, // 16 padding + 40 width + 16 padding
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: const CustomBackButton(
            backgroundColor: Colors.white,
          ),
        ),
        title: Text(
          'Preview Food',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            PreviewFoodSliverHeader(
              expandedHeight: 340,
              collapsedHeight: 180,
              floatingCardOverhang: 55,
              imagePath: AppAssets.homeRecipeCardImage3,
              foodName: 'Paneer Butter Masala',
              restaurantName: "Rafi's Kitchen",
              floatingCard: const PreviewFoodHeaderCard(
                price: '\$11.99',
                rating: '4.7',
                reviewCount: '(84 reviews)',
                time: '45 min',
                mealType: 'Lunch',
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                Column(
                  children: [
                    const SizedBox(height: 24),
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
                            Tab(text: 'Method'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
                controller: controller.tabController,
                children: [
                  // Details Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                          'A classic Indian dish made with paneer (Indian cottage cheese) cooked in a rich and creamy tomato-based sauce, flavored with butter and aromatic spices. Perfectly pairs with garlic naan or basmati rice.',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                  // Ingredients Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              PreviewIngredientTile(
                                name: 'Paneer',
                                quantity: '200g',
                              ),
                              PreviewIngredientTile(
                                name: 'Butter',
                                quantity: '3 tbsp',
                              ),
                              PreviewIngredientTile(
                                name: 'Tomato Puree',
                                quantity: '2 cups',
                              ),
                              PreviewIngredientTile(
                                name: 'Heavy Cream',
                                quantity: '1/2 cup',
                              ),
                              PreviewIngredientTile(
                                name: 'Garam Masala',
                                quantity: '1 tsp',
                              ),
                              PreviewIngredientTile(
                                name: 'Kasuri Methi',
                                quantity: '1 tbsp',
                              ),
                              PreviewIngredientTile(
                                name: 'Garlic Paste',
                                quantity: '1 tbsp',
                              ),
                              PreviewIngredientTile(
                                name: 'Ginger Paste',
                                quantity: '1 tbsp',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                  // Method Tab
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'STEP-BY-STEP INSTRUCTIONS',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const PreviewMethodStepCard(
                          stepNumber: 1,
                          title: 'Prepare the paneer',
                          description: 'Cut the paneer into bite-sized cubes. Soak them in warm water for 15 minutes to make them soft.',
                          isActive: true,
                        ),
                        const SizedBox(height: 16),
                        const PreviewMethodStepCard(
                          stepNumber: 2,
                          title: 'Make the gravy base',
                          description: 'Melt butter in a pan, add ginger-garlic paste and sauté. Add tomato puree and cook until oil separates.',
                          isActive: true,
                        ),
                        const SizedBox(height: 16),
                        const PreviewMethodStepCard(
                          stepNumber: 3,
                          title: 'Add spices',
                          description: 'Add garam masala, red chili powder, salt, and kasuri methi. Mix well and cook for 2 minutes.',
                          isActive: true,
                        ),
                        const SizedBox(height: 16),
                        const PreviewMethodStepCard(
                          stepNumber: 4,
                          title: 'Add cream and paneer',
                          description: 'Lower the heat, stir in the heavy cream, and add the paneer cubes. Simmer for 5-7 minutes.',
                          isActive: true,
                        ),
                        const SizedBox(height: 16),
                        const PreviewMethodStepCard(
                          stepNumber: 5,
                          title: 'Garnish and serve',
                          description: 'Garnish with a drizzle of cream and fresh cilantro. Serve hot with naan or rice.',
                          isActive: true,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
    });
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar, {this.height = 90.0});

  final Widget tabBar;
  final double height;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFFAF9F8), // Match Scaffold background
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || height != oldDelegate.height;
  }
}
