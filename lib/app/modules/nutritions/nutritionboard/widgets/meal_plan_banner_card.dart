import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_assets.dart';

/// A full-width banner card shown when the user has an active meal plan.
/// Displays the mealplan graphic alongside a CTA to view today's plan.
class MealPlanBannerCard extends StatelessWidget {
  final VoidCallback onViewPlan;

  const MealPlanBannerCard({super.key, required this.onViewPlan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h, right: 12.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Sparkle icon
                    Icon(Icons.auto_awesome, color: Colors.white, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Your Personalized Meal Plan',
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
                SizedBox(height: 8.h),
                Text(
                  '1 month meal plan is ready. Check today\'s\nmeals, AI insights & daily nutrition focus.',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.88),
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: onViewPlan,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
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
          // Mealplan graphic
          ClipRRect(
            child: Image.asset(
              AppAssets.mealPlanGraphic,
              width: 110.w,
              height: 95.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
