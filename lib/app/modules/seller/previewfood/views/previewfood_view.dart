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
          child: controller.isSubmitting.value
              ? const SizedBox(
                  height: 51,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                )
              : PrimaryButton(
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
          leadingWidth: 72,
          leading: const Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: CustomBackButton(
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
                imageFile: controller.images.isNotEmpty ? controller.images.first : null,
                foodName: controller.foodName.value.isNotEmpty
                    ? controller.foodName.value
                    : 'Paneer Butter Masala',
                restaurantName: controller.restaurantName.value,
                floatingCard: PreviewFoodHeaderCard(
                  price: '\$${controller.price.value.toStringAsFixed(2)}',
                  rating: '5.0',
                  reviewCount: '(New)',
                  time: controller.preparationTime.value.isNotEmpty
                      ? controller.preparationTime.value
                      : '25 mins',
                  mealType: controller.category.value,
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
                      controller.description.value.isNotEmpty
                          ? controller.description.value
                          : 'No description provided.',
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
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: controller.ingredients.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: Text(
                                  'No ingredients added',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                for (int i = 0; i < controller.ingredients.length; i++)
                                  PreviewIngredientTile(
                                    name: controller.ingredients[i]['name']?.toString() ?? '',
                                    quantity:
                                        '${controller.ingredients[i]['quantity'] ?? ''} ${controller.ingredients[i]['unit'] ?? ''}'
                                            .trim(),
                                    isLast: i == controller.ingredients.length - 1,
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
                    if (controller.cookingSteps.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: Text(
                            'No instructions added',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      for (int i = 0; i < controller.cookingSteps.length; i++) ...[
                        PreviewMethodStepCard(
                          stepNumber: i + 1,
                          title: 'Step ${i + 1}',
                          description: controller.cookingSteps[i],
                          isActive: true,
                        ),
                        const SizedBox(height: 16),
                      ],
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
  _TabBarDelegate(this.tabBar) : height = 90.0;

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
