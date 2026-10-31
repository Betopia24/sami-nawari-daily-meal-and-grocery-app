import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_assets.dart';
import '../../../../data/models/nutrition_insight_model.dart';

/// A full-width banner card shown when the user has an active meal plan.
/// Displays dynamic data from the AI Nutrition Insight API alongside the CTA.
class MealPlanBannerCard extends StatelessWidget {
  final VoidCallback onViewPlan;
  final NutritionInsightModel? insight;
  final String? subtitle;

  const MealPlanBannerCard({
    super.key,
    required this.onViewPlan,
    this.insight,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final nutrition = insight?.nutrition;
    final summaryText = (insight?.insight != null && insight!.insight!.summary.isNotEmpty)
        ? insight!.insight!.summary
        : (subtitle ?? '');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 16.sp),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'Your AI Meal Plan',
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (nutrition != null && nutrition.calories > 0) ...[
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: [
                      _buildMacroBadge('🔥 ${nutrition.calories} kcal'),
                      if (nutrition.proteinG > 0)
                        _buildMacroBadge('${nutrition.proteinG}g Protein'),
                      if (nutrition.carbsG > 0)
                        _buildMacroBadge('${nutrition.carbsG}g Carbs'),
                    ],
                  ),
                ],
                if (summaryText.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    summaryText,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: onViewPlan,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "View Today's Plan",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward,
                          size: 14.sp,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          ClipRRect(
            child: Image.asset(
              AppAssets.mealPlanGraphic,
              width: 95.w,
              height: 90.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
