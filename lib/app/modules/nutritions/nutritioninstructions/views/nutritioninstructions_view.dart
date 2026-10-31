import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/ai_insight_card.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/focus_list_card.dart';
import '../../../../widgets/food_chips_card.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/nutritioninstructions_controller.dart';
import '../widgets/nutrition_instructions_shimmer.dart';

class NutritioninstructionsView extends GetView<NutritioninstructionsController> {
  const NutritioninstructionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  CustomBackButton(onTap: () => Get.back()),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Insight',
                          style: GoogleFonts.outfit(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        Obx(() {
                          if (controller.isIndividualMeal.value &&
                              controller.recipeTitle.value.isNotEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                '${controller.mealTitle.value} • ${controller.recipeTitle.value}',
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2EBE5)),

            // Body with RefreshIndicator & Shimmer
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshInstructions,
                color: AppColors.primary,
                backgroundColor: Colors.white,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const NutritionInstructionsShimmer();
                    }

                    final nutrition = controller.latestInsight.value?.nutrition;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AI Insight Card
                        AiInsightCard(insightText: controller.aiInsightText.value),

                        // Optional Macronutrients Targets from OpenAPI
                        if (nutrition != null && nutrition.calories > 0) ...[
                          SizedBox(height: 16.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FBF9),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: const Color(0xFFE2EBE5)),
                            ),
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 6.h,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                _buildNutritionPill(
                                  '🔥 ${nutrition.calories} kcal',
                                  AppColors.primary,
                                ),
                                if (nutrition.proteinG > 0)
                                  _buildNutritionPill(
                                    '${nutrition.proteinG}g Protein',
                                    const Color(0xFF1E88E5),
                                  ),
                                if (nutrition.carbsG > 0)
                                  _buildNutritionPill(
                                    '${nutrition.carbsG}g Carbs',
                                    const Color(0xFFFB8C00),
                                  ),
                                if (nutrition.fiberG > 0)
                                  _buildNutritionPill(
                                    '${nutrition.fiberG}g Fiber',
                                    const Color(0xFF43A047),
                                  ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 24.h),

                        // Why This Plan / Meal?
                        FocusListCard(
                          title: controller.whyThisPlanTitle.value,
                          items: controller.whyThisPlanItems,
                        ),
                        SizedBox(height: 24.h),

                        // What to Focus on
                        FocusListCard(
                          title: 'What to Focus on',
                          items: controller.focusItems,
                        ),
                        SizedBox(height: 24.h),

                        // Foods to Eat
                        FoodChipsCard(
                          title: 'Foods to Eat',
                          icon: Icons.check_circle,
                          themeColor: AppColors.primary,
                          chipBackgroundColor: const Color(0xFFF4F9F6),
                          foods: controller.foodsToEat,
                        ),
                        SizedBox(height: 24.h),

                        // Foods to Avoid
                        FoodChipsCard(
                          title: 'Foods to Avoid',
                          icon: Icons.cancel_outlined,
                          themeColor: const Color(0xFFFF4B4B),
                          chipBackgroundColor: const Color(0xFFFFF0F0),
                          foods: controller.foodsToAvoid,
                        ),

                        // Optional: View Recipe & Method button for individual meals
                        if (controller.isIndividualMeal.value) ...[
                          SizedBox(height: 32.h),
                          PrimaryButton(
                            text: 'View Recipe & Method',
                            onPressed: controller.onViewRecipeDetails,
                            showArrow: true,
                          ),
                        ],

                        SizedBox(height: 40.h),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionPill(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
