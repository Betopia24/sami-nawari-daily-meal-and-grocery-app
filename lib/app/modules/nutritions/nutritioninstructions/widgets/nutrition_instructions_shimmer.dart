import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/custom_shimmer.dart';

/// Shimmer skeleton loader for AI Nutrition Instructions / Insight screen
class NutritionInstructionsShimmer extends StatelessWidget {
  const NutritionInstructionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Insight Card Shimmer
        CustomShimmer.card(
          width: double.infinity,
          height: 120.h,
          radius: 16.r,
        ),
        SizedBox(height: 24.h),

        // Section Title Shimmer
        CustomShimmer.rectangular(
          width: 140.w,
          height: 18.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
        SizedBox(height: 12.h),

        // Focus List Card Shimmer (Why This Plan?)
        CustomShimmer.card(
          width: double.infinity,
          height: 170.h,
          radius: 16.r,
        ),
        SizedBox(height: 24.h),

        // Section Title Shimmer
        CustomShimmer.rectangular(
          width: 160.w,
          height: 18.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
        SizedBox(height: 12.h),

        // Focus List Card Shimmer (What to Focus on)
        CustomShimmer.card(
          width: double.infinity,
          height: 170.h,
          radius: 16.r,
        ),
        SizedBox(height: 24.h),

        // Food Chips Card Shimmer (Foods to Eat)
        CustomShimmer.card(
          width: double.infinity,
          height: 120.h,
          radius: 16.r,
        ),
        SizedBox(height: 24.h),

        // Food Chips Card Shimmer (Foods to Avoid)
        CustomShimmer.card(
          width: double.infinity,
          height: 120.h,
          radius: 16.r,
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}
