import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/custom_shimmer.dart';

/// Shimmer skeleton loader for Today's Meal Plan screen
class MealPlanShimmer extends StatelessWidget {
  const MealPlanShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date card shimmer
        CustomShimmer.card(
          width: double.infinity,
          height: 64.h,
          radius: 16.r,
        ),
        SizedBox(height: 24.h),

        // Subtitle shimmer ("Your personalized meals for today")
        Center(
          child: CustomShimmer.rectangular(
            width: 220.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 24.h),

        // Section Title shimmer ("Today's Meals")
        CustomShimmer.rectangular(
          width: 120.w,
          height: 18.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
        SizedBox(height: 16.h),

        // 4 Meal cards shimmer
        ...List.generate(
          4,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFF3F3F3)),
              ),
              child: Row(
                children: [
                  CustomShimmer.circular(size: 48.w),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmer.rectangular(
                          width: 60.w,
                          height: 11.h,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        SizedBox(height: 6.h),
                        CustomShimmer.rectangular(
                          width: 100.w,
                          height: 15.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        SizedBox(height: 6.h),
                        CustomShimmer.rectangular(
                          width: 160.w,
                          height: 13.h,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Tip row shimmer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomShimmer.circular(size: 20.w),
            SizedBox(width: 10.w),
            CustomShimmer.rectangular(
              width: 210.w,
              height: 12.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
