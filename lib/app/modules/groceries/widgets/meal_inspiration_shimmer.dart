import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/custom_shimmer.dart';

class MealInspirationShimmer extends StatelessWidget {
  final int count;
  const MealInspirationShimmer({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmer.card(
                width: 80.w,
                height: 80.w,
                radius: 12.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomShimmer.rectangular(
                          height: 16.h,
                          width: 140.w,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        CustomShimmer.circular(size: 20.sp),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        CustomShimmer.circular(size: 14.sp),
                        SizedBox(width: 6.w),
                        CustomShimmer.rectangular(
                          height: 14.h,
                          width: 80.w,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    CustomShimmer.rectangular(
                      height: 22.h,
                      width: 120.w,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
