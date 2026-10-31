import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/nutrition_goal_card.dart';
import '../controllers/nutritionboard_controller.dart';
import '../widgets/meal_plan_banner_card.dart';
import '../widgets/nutrition_board_shimmer.dart';

class NutritionboardView extends GetView<NutritionboardController> {
  final bool? showBackButton;

  const NutritionboardView({
    super.key,
    this.showBackButton,
  });

  bool _shouldShowBackButton(BuildContext context) {
    if (showBackButton != null) return showBackButton!;
    if (Get.arguments is Map && (Get.arguments as Map).containsKey('showBackButton')) {
      return Get.arguments['showBackButton'] as bool;
    }
    return Navigator.canPop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            _buildSliverAppBar(context),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const NutritionBoardShimmer();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      _buildPersonalizedSection(),
                      SizedBox(height: 16.h),
                      _buildCreateMealPlanBanner(),
                      SizedBox(height: 24.h),
                      _buildGoalGrid(),
                      SizedBox(height: 24.h),
                      _buildDisclaimerCard(),
                      SizedBox(height: 140.h), // Bottom padding for navbar
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Sliver App Bar ──────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(BuildContext context) {
    final bool shouldShowBack = _shouldShowBackButton(context);

    return SliverAppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      floating: false,
      snap: false,
      pinned: true,
      automaticallyImplyLeading: false,
      leadingWidth: shouldShowBack ? 72.w : 0,
      leading: shouldShowBack
          ? Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: const Center(child: CustomBackButton()),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition For You',
            style: GoogleFonts.outfit(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          Text(
            'Personalized nutrition guidance powered by AI',
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      titleSpacing: shouldShowBack ? 8.w : 20.w,
    );
  }

  // ─── "Personalized with AI" Section Header ────────────────────────────────

  Widget _buildPersonalizedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personalized with AI',
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Based on your goal, preferences & dietary needs',
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ─── Create Meal Plan / Active Plan Banner ────────────────────────────────

  Widget _buildCreateMealPlanBanner() {
    return Obx(() {
      if (controller.hasMealPlan.value && controller.latestInsight.value != null) {
        // Show the active plan banner with dynamic API macros and insight summary
        return MealPlanBannerCard(
          onViewPlan: controller.onViewTodaysPlan,
          insight: controller.latestInsight.value,
        );
      }

      // Show the "Create Your Meal Plan" CTA
      return GestureDetector(
        onTap: controller.onCreateMealPlan,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/aienhance_icon.svg',
                width: 24.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your Meal Plan',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Get a personalized 1 month meal plan based on your\ngoals, routine & preferences.',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ],
          ),
        ),
      );
    });
  }

  // ─── 2-Column Goal Grid ───────────────────────────────────────────────────

  Widget _buildGoalGrid() {
    final categories = controller.goalCategories;
    final rows = <Widget>[];

    for (int i = 0; i < categories.length; i += 2) {
      final left = categories[i];
      final right = i + 1 < categories.length ? categories[i + 1] : null;

      rows.add(
        Row(
          children: [
            Expanded(
              child: NutritionGoalCard(
                emoji: left['emoji'] as String,
                title: left['title'] as String,
                subtitle: left['subtitle'] as String,
                onTap: () => controller.onGoalTapped(left['title'] as String),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: right != null
                  ? NutritionGoalCard(
                      emoji: right['emoji'] as String,
                      title: right['title'] as String,
                      subtitle: right['subtitle'] as String,
                      onTap: () =>
                          controller.onGoalTapped(right['title'] as String),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );

      if (i + 2 < categories.length) {
        rows.add(SizedBox(height: 12.h));
      }
    }

    return Column(children: rows);
  }

  // ─── AI Disclaimer Card ───────────────────────────────────────────────────

  Widget _buildDisclaimerCard() {
    return Obx(() {
      final suggestions = controller.latestInsight.value?.insight?.suggestions;
      final guidanceText = (suggestions != null && suggestions.isNotEmpty)
          ? suggestions.first
          : 'AI-based food guidance. Always consult a healthcare professional for personal medical advice.';

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: AppColors.backgroundLightGreen,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Icon(
                Icons.auto_awesome,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                guidanceText,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
