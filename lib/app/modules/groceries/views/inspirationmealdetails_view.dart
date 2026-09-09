import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../widgets/custom_segmented_tab_bar.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/custom_back_button.dart';
import '../../receipes/widgets/servings_counter.dart';
import '../../receipes/widgets/recipe_ingredient_item.dart';
import '../../receipes/widgets/recipe_method_step_card.dart';
import '../../receipes/widgets/pro_tips_card.dart';
import '../controllers/inspirationmealdetails_controller.dart';

class InspirationmealdetailsView extends StatelessWidget {
  const InspirationmealdetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InspirationmealdetailsController());

    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: _buildBottomBar(controller),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildCustomHeader(controller)),

            // Remaining Body Content
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.surface,
                child: Column(
                  children: [
                    // Custom Tab Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Obx(
                        () => CustomSegmentedTabBar(
                          tabs: const ['Details', 'Ingredients', 'Method'],
                          activeIndex: controller.activeTab.value,
                          onTabChanged: controller.switchTab,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tab Content
                    Obx(() {
                      if (controller.activeTab.value == 0) {
                        return _buildDetailsTab(controller);
                      } else if (controller.activeTab.value == 1) {
                        return _buildIngredientsTab(controller);
                      } else {
                        return _buildMethodTab(controller);
                      }
                    }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(InspirationmealdetailsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 320,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppAssets.homeRecipeCardImage1,
                    fit: BoxFit.cover,
                  ), // Using placeholder
                  // Dark gradient at the bottom for text
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.textPrimary.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Title and Tag
                  Positioned(
                    bottom: 24,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderTag('Easy'),
                        const SizedBox(height: 12),
                        Text(
                          'Creamy Tomato Pasta',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Back button
          const Positioned(top: 16, left: 16, child: CustomBackButton()),
          // Bookmark button
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.bookmarkIcon,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          // Servings Counter
          Positioned(
            bottom: -20, // Overhang
            right: 20,
            child: Obx(
              () => ServingsCounter(
                count: controller.servings.value,
                onIncrement: controller.incrementServings,
                onDecrement: controller.decrementServings,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildDetailsTab(InspirationmealdetailsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DESCRIPTION',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            controller.description,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab(InspirationmealdetailsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: controller.ingredients.map((ing) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RecipeIngredientItem(
              imagePath: ing['icon']!,
              name: ing['name']!,
              amount: ing['amount']!,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMethodTab(InspirationmealdetailsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STEP-BY-STEP INSTRUCTIONS',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              Obx(
                () => Text(
                  '${controller.completedSteps.length}/${controller.methodSteps.length} done',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          Obx(() {
            final progress = controller.methodSteps.isEmpty
                ? 0.0
                : controller.completedSteps.length /
                      controller.methodSteps.length;
            return LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: AppColors.primary,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            );
          }),
          const SizedBox(height: 24),
          // Steps
          ...List.generate(controller.methodSteps.length, (index) {
            final step = controller.methodSteps[index];
            return Obx(() {
              final isCompleted = controller.completedSteps.contains(index);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RecipeMethodStepCard(
                  stepNumber: index + 1,
                  title: step['title']!,
                  description: step['description']!,
                  isCompleted: isCompleted,
                  onTap: () => controller.toggleStep(index),
                ),
              );
            });
          }),
          const SizedBox(height: 8),
          ProTipsCard(tips: controller.proTips),
        ],
      ),
    );
  }

  Widget _buildBottomBar(InspirationmealdetailsController controller) {
    return Obx(() {
      // Only show sticky button when Ingredients tab is active
      if (controller.activeTab.value == 1) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: PrimaryButton(
              onPressed: () {},
              text: 'Add Missing Ingredients',
              showArrow: false,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
