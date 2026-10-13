import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../widgets/custom_recipe_cover.dart';

class MealIdeaCard extends StatelessWidget {
  final String title;
  final String timeInfo;
  final String usageInfo;

  const MealIdeaCard({
    super.key,
    required this.title,
    required this.timeInfo,
    required this.usageInfo,
  });

  @override
  Widget build(BuildContext context) {
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
          // Image placeholder using existing widget
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CustomRecipeCover(height: 80.w, width: 80.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.bookmark_border,
                      color: AppColors.textPrimary,
                      size: 24.sp,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.schedule, color: AppColors.textSecondary, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      timeInfo,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F3EB),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    usageInfo,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
