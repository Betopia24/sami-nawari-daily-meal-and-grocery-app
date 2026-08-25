import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/app_colors.dart';

class GroceriesSearchBar extends StatelessWidget {
  final String hintText;
  
  const GroceriesSearchBar({
    super.key,
    this.hintText = 'Search list or items...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight, width: 1.w),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/search_icon.svg',
            width: 20.sp,
            height: 20.sp,
            colorFilter: ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              hintText,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
