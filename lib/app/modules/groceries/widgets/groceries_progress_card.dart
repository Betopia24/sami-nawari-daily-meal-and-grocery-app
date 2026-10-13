import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';

class GroceriesProgressCard extends StatelessWidget {
  const GroceriesProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('3', 'Lists', 'assets/icons/list_icon.svg'),
              _buildStatCard('15', 'Pending', 'assets/icons/pending_icon.svg'),
              _buildStatCard('5', 'Completed', 'assets/icons/circle_tick.svg'),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Groceries Progress',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                '21%',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            height: 8.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.21,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '3 lists • 15 items pending',
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String count, String label, String iconAsset) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            iconAsset,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: 24.sp,
            width: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            count,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
