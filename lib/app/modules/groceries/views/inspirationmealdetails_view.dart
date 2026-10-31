import 'package:flutter/material.dart';
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

class InspirationmealdetailsView extends StatefulWidget {
  const InspirationmealdetailsView({super.key});

  @override
  State<InspirationmealdetailsView> createState() =>
      _InspirationmealdetailsViewState();
}

class _InspirationmealdetailsViewState extends State<InspirationmealdetailsView> {
  late final InspirationmealdetailsController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<InspirationmealdetailsController>()) {
      controller = Get.find<InspirationmealdetailsController>();
      controller.initFromArguments(Get.arguments);
    } else {
      controller = Get.put(InspirationmealdetailsController());
    }
  }

  @override
  void dispose() {
    if (Get.isRegistered<InspirationmealdetailsController>()) {
      Get.delete<InspirationmealdetailsController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: _buildBottomBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildCustomHeader()),

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
                        return _buildDetailsTab();
                      } else if (controller.activeTab.value == 1) {
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
      ),
    );
  }

  Widget _buildCustomHeader() {
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
                  Obx(() {
                    final netUrl = controller.imageUrl.value;
                    final asset = controller.imageAsset.value;
                    if (netUrl.startsWith('http')) {
                      return Image.network(
                        netUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          AppAssets.homeRecipeCardImage1,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (asset.isNotEmpty) {
                      return Image.asset(
                        asset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          AppAssets.homeRecipeCardImage1,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                    return Image.asset(
                      AppAssets.homeRecipeCardImage1,
                      fit: BoxFit.cover,
                    );
                  }),
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
                        Obx(() {
                          final diff = controller.difficulty.value;
                          if (diff.isEmpty) return const SizedBox.shrink();
                          return _buildHeaderTag(diff);
                        }),
                        const SizedBox(height: 12),
                        Obx(
                          () => Text(
                            controller.title.value,
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
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
          // Bookmark button with interactive toggle
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: controller.toggleBookmark,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Obx(
                    () => Icon(
                      controller.isBookmarked.value
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: controller.isBookmarked.value
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      size: 22,
                    ),
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

  Widget _buildDetailsTab() {
    final desc = controller.description.value;
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
            desc.isNotEmpty
                ? desc
                : 'No detailed description provided for this meal.',
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

  Widget _buildIngredientsTab() {
    if (controller.ingredients.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: Text(
            'No specific ingredients listed for this meal.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: controller.ingredients.map((ing) {
          final iconPath =
              (ing['icon'] ?? 'assets/emojis/olive_emoji.png').toString();
          final name = (ing['name'] ?? '').toString();
          final amount = (ing['amount'] ?? '').toString();
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RecipeIngredientItem(
              imagePath: iconPath,
              name: name,
              amount: amount,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMethodTab() {
    final totalSteps = controller.methodSteps.length;
    final completedCount = controller.completedSteps.length;
    final progress = totalSteps == 0
        ? 0.0
        : (completedCount / totalSteps).clamp(0.0, 1.0);
    final steps = controller.methodSteps;
    final completed = controller.completedSteps;
    final tips = controller.proTips;

    if (steps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 44,
                color: AppColors.textSecondary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Text(
                'No preparation steps provided for this meal.',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
              Text(
                '$completedCount/$totalSteps done',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            color: AppColors.primary,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 24),
          // Steps
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final isCompleted = completed.contains(index);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RecipeMethodStepCard(
                stepNumber: index + 1,
                title: step['title'] ?? 'Step ${index + 1}',
                description: step['description'] ?? '',
                isCompleted: isCompleted,
                onTap: () => controller.toggleStep(index),
              ),
            );
          }),
          if (tips.isNotEmpty) ...[
            const SizedBox(height: 8),
            ProTipsCard(tips: tips.toList()),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Obx(() {
      // Only show sticky button when Ingredients tab is active
      if (controller.activeTab.value == 1) {
        final isAdding = controller.isAddingIngredients.value;
        final count = controller.missingIngredients.length;
        final btnText = isAdding
            ? 'Adding to Grocery List...'
            : (count == 0
                ? 'All Ingredients In Pantry'
                : 'Add Missing Ingredients ($count)');

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: PrimaryButton(
              isEnabled: !isAdding,
              onPressed: controller.addMissingIngredientsToGrocery,
              text: btnText,
              showArrow: false,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
