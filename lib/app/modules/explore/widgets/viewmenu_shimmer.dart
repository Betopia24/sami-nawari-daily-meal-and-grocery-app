import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/custom_shimmer.dart';

/// Shimmer skeletons for ViewmenuView while API loads menu, about, and reviews data

/// Shimmer skeleton for the "Menu" tab
class ViewMenuShimmer extends StatelessWidget {
  const ViewMenuShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // ── Popular Dishes Skeleton ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer.rectangular(
                  width: 130.w,
                  height: 18.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  height: 168.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(right: 24.w),
                    itemCount: 3,
                    separatorBuilder: (_, _) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) => _buildPopularDishCardShimmer(),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 20.h)),

        // ── Category Chips Skeleton ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                CustomShimmer.rectangular(
                  width: 52.w,
                  height: 32.h,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                SizedBox(width: 8.w),
                CustomShimmer.rectangular(
                  width: 76.w,
                  height: 32.h,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                SizedBox(width: 8.w),
                CustomShimmer.rectangular(
                  width: 72.w,
                  height: 32.h,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                SizedBox(width: 8.w),
                CustomShimmer.rectangular(
                  width: 64.w,
                  height: 32.h,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 20.h)),

        // ── Complete Menu Title Skeleton ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomShimmer.rectangular(
              width: 140.w,
              height: 18.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 14.h)),

        // ── Menu Items List Skeleton ──
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildMenuDishCardShimmer(),
              childCount: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularDishCardShimmer() {
    return Container(
      width: 150.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          CustomShimmer.rectangular(
            width: 150.w,
            height: 100.h,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer.rectangular(
                  width: 90.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmer.rectangular(
                      width: 44.w,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    CustomShimmer.rectangular(
                      width: 40.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(3.r),
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

  Widget _buildMenuDishCardShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dish Thumbnail
          CustomShimmer.rectangular(
            width: 80.w,
            height: 80.h,
            borderRadius: BorderRadius.circular(12.r),
          ),
          SizedBox(width: 12.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomShimmer.rectangular(
                      width: 120.w,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    const Spacer(),
                    CustomShimmer.rectangular(
                      width: 45.w,
                      height: 16.h,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                CustomShimmer.rectangular(
                  width: double.infinity,
                  height: 11.h,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                SizedBox(height: 4.h),
                CustomShimmer.rectangular(
                  width: 130.w,
                  height: 11.h,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    CustomShimmer.rectangular(
                      width: 45.w,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    SizedBox(width: 12.w),
                    CustomShimmer.rectangular(
                      width: 50.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    SizedBox(width: 12.w),
                    CustomShimmer.rectangular(
                      width: 40.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(3.r),
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

/// Shimmer skeleton for the "About" tab
class ViewMenuAboutShimmer extends StatelessWidget {
  const ViewMenuAboutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Chef Bio Card skeleton
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomShimmer.circular(size: 40.r * 2),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmer.rectangular(
                          width: 110.w,
                          height: 16.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        SizedBox(height: 4.h),
                        CustomShimmer.rectangular(
                          width: 150.w,
                          height: 12.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomShimmer.rectangular(
                  width: double.infinity,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                SizedBox(height: 6.h),
                CustomShimmer.rectangular(
                  width: 200.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Working Hours Card skeleton
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer.rectangular(
                  width: 120.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 12.h),
                for (int i = 0; i < 3; i++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomShimmer.rectangular(
                        width: 70.w,
                        height: 12.h,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      CustomShimmer.rectangular(
                        width: 110.w,
                        height: 12.h,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ],
                  ),
                  if (i < 2) SizedBox(height: 8.h),
                ],
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Ordering Info Card skeleton
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer.rectangular(
                  width: 120.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 12.h),
                for (int i = 0; i < 4; i++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomShimmer.rectangular(
                        width: 90.w,
                        height: 12.h,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      CustomShimmer.rectangular(
                        width: 60.w,
                        height: 12.h,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ],
                  ),
                  if (i < 3) SizedBox(height: 8.h),
                ],
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

/// Shimmer skeleton for the "Reviews" tab
class ViewMenuReviewsShimmer extends StatelessWidget {
  const ViewMenuReviewsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Review Summary skeleton
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    CustomShimmer.rectangular(
                      width: 50.w,
                      height: 36.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 4.h),
                    CustomShimmer.rectangular(
                      width: 60.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ],
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    children: [
                      for (int i = 0; i < 5; i++) ...[
                        Row(
                          children: [
                            CustomShimmer.rectangular(
                              width: 14.w,
                              height: 10.h,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: CustomShimmer.rectangular(
                                height: 6.h,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                            ),
                          ],
                        ),
                        if (i < 4) SizedBox(height: 6.h),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Review items skeleton
          for (int i = 0; i < 2; i++) ...[
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomShimmer.circular(size: 36.r),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomShimmer.rectangular(
                            width: 90.w,
                            height: 14.h,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          SizedBox(height: 4.h),
                          CustomShimmer.rectangular(
                            width: 60.w,
                            height: 10.h,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CustomShimmer.rectangular(
                        width: 50.w,
                        height: 12.h,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomShimmer.rectangular(
                    width: double.infinity,
                    height: 12.h,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  SizedBox(height: 4.h),
                  CustomShimmer.rectangular(
                    width: 180.w,
                    height: 12.h,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ],
              ),
            ),
          ],
        ]),
      ),
    );
  }
}
