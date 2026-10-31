import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/custom_shimmer.dart';

/// Shimmer loading skeleton specifically tailored to the Nutrition Board layout.
class NutritionBoardShimmer extends StatelessWidget {
  const NutritionBoardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),

        // Personalized Section Title & Subtitle Shimmer
        CustomShimmer.rectangular(
          width: 180.w,
          height: 20.h,
          borderRadius: BorderRadius.circular(6.r),
        ),
        SizedBox(height: 6.h),
        CustomShimmer.rectangular(
          width: 250.w,
          height: 13.h,
          borderRadius: BorderRadius.circular(4.r),
        ),

        SizedBox(height: 16.h),

        // Create Meal Plan / Active Banner Card Shimmer
        CustomShimmer.card(
          width: double.infinity,
          height: 94.h,
          radius: 16.r,
        ),

        SizedBox(height: 24.h),

        // 2-Column Goal Grid Shimmer (3 rows of 2 cards each)
        _buildGoalGridShimmer(),

        SizedBox(height: 24.h),

        // AI Disclaimer Card Shimmer
        CustomShimmer.card(
          width: double.infinity,
          height: 68.h,
          radius: 18.r,
        ),

        SizedBox(height: 140.h),
      ],
    );
  }

  Widget _buildGoalGridShimmer() {
    return Column(
      children: [
        _buildGoalRowShimmer(),
        SizedBox(height: 12.h),
        _buildGoalRowShimmer(),
        SizedBox(height: 12.h),
        _buildGoalRowShimmer(),
      ],
    );
  }

  Widget _buildGoalRowShimmer() {
    return Row(
      children: [
        Expanded(child: _buildGoalCardShimmer()),
        SizedBox(width: 12.w),
        Expanded(child: _buildGoalCardShimmer()),
      ],
    );
  }

  Widget _buildGoalCardShimmer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9F6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EBE5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji icon shimmer
          CustomShimmer.circular(size: 26.w),
          SizedBox(height: 10.h),
          // Title shimmer
          CustomShimmer.rectangular(
            width: 90.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 8.h),
          // Subtitle line 1 shimmer
          CustomShimmer.rectangular(
            width: 110.w,
            height: 10.h,
            borderRadius: BorderRadius.circular(3.r),
          ),
          SizedBox(height: 4.h),
          // Subtitle line 2 shimmer
          CustomShimmer.rectangular(
            width: 70.w,
            height: 10.h,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ],
      ),
    );
  }
}
