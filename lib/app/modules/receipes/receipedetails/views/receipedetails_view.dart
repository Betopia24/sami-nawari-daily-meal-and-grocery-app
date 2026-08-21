import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../controllers/receipedetails_controller.dart';
import '../../widgets/nutrition_summary_card.dart';
import '../../widgets/servings_counter.dart';
import '../../widgets/recipe_ingredient_item.dart';
import '../../widgets/recipe_method_step_card.dart';
import '../../widgets/pro_tips_card.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/floating_seam_sliver_header.dart';

class ReceipedetailsView extends GetView<ReceipedetailsController> {
  const ReceipedetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: _buildBottomBar(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              FloatingSeamSliverHeader(
                expandedHeight: 350,
                toolbarHeight: 121,
                floatingCardOverhang: 37,
                titleBottomOffset: 40,
                imagePath: AppAssets.homeRecipeCardImage1,
                titleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildHeaderTag('High Protein'),
                        const SizedBox(width: 8),
                        _buildHeaderTag('Healthy'),
                        const SizedBox(width: 8),
                        _buildHeaderTag('Quick'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Avocado Toast with Poached Egg',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.surface,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'American',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.surface.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '•',
                          style: TextStyle(color: AppColors.surface),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.star,
                          color: AppColors.secondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.surface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(2,340)',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.surface.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
                floatingCard: const NutritionSummaryCard(
                  prepTime: '5m',
                  cookTime: '10m',
                  calories: '380',
                ),
              ),

              // Remaining Body Content
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.surface,
                  child: Column(
                    children: [
                      // Servings counter aligned to right
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Obx(
                            () => ServingsCounter(
                              count: controller.servings.value,
                              onIncrement: controller.incrementServings,
                              onDecrement: controller.decrementServings,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Custom Tab Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildCustomTabBar(),
                      ),
                      const SizedBox(height: 24),
                      // Tab Content
                      Obx(() {
                        if (controller.activeTab.value == 0) {
                          return _buildIngredientsTab();
                        } else {
                          return _buildMethodTab();
                        }
                      }),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Header Bar (Back button, Bookmark)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
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
              ],
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

  Widget _buildCustomTabBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => _buildTabItem(
                'Ingredients',
                0,
                controller.activeTab.value == 0,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => _buildTabItem('Method', 1, controller.activeTab.value == 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index, bool isActive) {
    return GestureDetector(
      onTap: () => controller.switchTab(index),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsTab() {
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

  Widget _buildMethodTab() {
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

  Widget _buildBottomBar() {
    return Obx(() {
      // Only show sticky button when Ingredients tab is active
      if (controller.activeTab.value == 0) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: PrimaryButton(
              onPressed: () {},
              text: 'Add Ingredients to Grocery List',
              svgPrefix: AppAssets.storeIcon,
              showArrow: false,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
