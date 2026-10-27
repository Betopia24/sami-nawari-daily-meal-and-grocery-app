import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/custom_shimmer.dart';

/// Shimmer skeleton loader for ExploreboardView while API loads sellers
class ExploreSellersShimmer extends StatelessWidget {
  final int itemCount;

  const ExploreSellersShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildCardShimmer(),
        childCount: itemCount,
      ),
    );
  }

  Widget _buildCardShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Image Skeleton with Badge Skeleton
          Stack(
            children: [
              CustomShimmer.rectangular(
                height: 140.h,
                width: double.infinity,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: CustomShimmer.rectangular(
                  width: 65.w,
                  height: 22.h,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                CustomShimmer.rectangular(
                  width: 170.w,
                  height: 18.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 6.h),

                // Owner
                CustomShimmer.rectangular(
                  width: 80.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 8.h),

                // Rating & Distance Row
                Row(
                  children: [
                    CustomShimmer.rectangular(
                      width: 16.w,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    SizedBox(width: 4.w),
                    CustomShimmer.rectangular(
                      width: 40.w,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(width: 8.w),
                    CustomShimmer.rectangular(
                      width: 60.w,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Info Pills (Prep time & Delivery fee)
                Row(
                  children: [
                    CustomShimmer.rectangular(
                      width: 68.w,
                      height: 26.h,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    SizedBox(width: 8.w),
                    CustomShimmer.rectangular(
                      width: 110.w,
                      height: 26.h,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Service Pills (Pickup & Delivery)
                Row(
                  children: [
                    CustomShimmer.rectangular(
                      width: 78.w,
                      height: 26.h,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    SizedBox(width: 8.w),
                    CustomShimmer.rectangular(
                      width: 84.w,
                      height: 26.h,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Description lines
                CustomShimmer.rectangular(
                  width: double.infinity,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 6.h),
                CustomShimmer.rectangular(
                  width: 220.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 16.h),

                // Bookmark & View Menu buttons
                Row(
                  children: [
                    CustomShimmer.rectangular(
                      width: 36.w,
                      height: 36.h,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    const Spacer(),
                    CustomShimmer.rectangular(
                      width: 130.w,
                      height: 40.h,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
