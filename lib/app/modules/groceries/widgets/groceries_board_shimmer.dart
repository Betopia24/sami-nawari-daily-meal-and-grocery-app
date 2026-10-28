import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../widgets/custom_shimmer.dart';

class GroceriesBoardShimmer extends StatelessWidget {
  final int itemCount;

  const GroceriesBoardShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Shimmer (Title + People avatars)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomShimmer.rectangular(
              width: 140.w,
              height: 20.h,
              borderRadius: BorderRadius.circular(6.r),
            ),
            Row(
              children: [
                CustomShimmer.circular(size: 26.w),
                SizedBox(width: 4.w),
                CustomShimmer.circular(size: 26.w),
              ],
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Subtitle Shimmer ("X Items")
        CustomShimmer.rectangular(
          width: 50.w,
          height: 12.h,
          borderRadius: BorderRadius.circular(4.r),
        ),

        SizedBox(height: 16.h),

        // Items Grid Shimmer (3 columns)
        _buildShimmerGrid(itemCount),
      ],
    );
  }

  Widget _buildShimmerGrid(int count) {
    final List<Widget> rows = [];
    for (int i = 0; i < count; i += 3) {
      if (i > 0) {
        rows.add(SizedBox(height: 12.h));
      }
      rows.add(
        Row(
          children: [
            for (int col = 0; col < 3; col++) ...[
              if (col > 0) SizedBox(width: 12.w),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 0.80,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.borderLight, width: 1.w),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon circle skeleton
                        CustomShimmer.circular(size: 32.w),
                        SizedBox(height: 8.h),

                        // Title skeleton
                        CustomShimmer.rectangular(
                          width: 56.w,
                          height: 10.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        SizedBox(height: 6.h),

                        // Two pill tags
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomShimmer.rectangular(
                              width: 24.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            SizedBox(width: 4.w),
                            CustomShimmer.rectangular(
                              width: 24.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),

                        // Added by footer
                        CustomShimmer.rectangular(
                          width: 44.w,
                          height: 7.h,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Column(children: rows);
  }
}
