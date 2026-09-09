import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';

class GroceryItemCard extends StatelessWidget {
  final String title;
  final String iconAsset;
  final bool isCompleted;
  final String sizeInfo;
  final String tagInfo;
  final String addedBy;
  final String? completedAgo;
  final IconData? fallbackIcon;

  const GroceryItemCard({
    super.key,
    required this.title,
    required this.iconAsset,
    this.isCompleted = false,
    required this.sizeInfo,
    required this.tagInfo,
    required this.addedBy,
    this.completedAgo,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = isCompleted ? AppColors.backgroundGrey : Colors.white;
    Color borderColor = isCompleted ? AppColors.borderLight : AppColors.borderLight; // or transparent if needed
    Color titleColor = isCompleted ? AppColors.textGreen : AppColors.textDark;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          _buildIcon(),
          SizedBox(height: 4.h),
          
          // Title
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: titleColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          
          // Tags
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTag(sizeInfo, isCompleted ? Colors.white : AppColors.textSecondary, isCompleted ? AppColors.primary : AppColors.backgroundToggle, isCompleted),
                SizedBox(width: 4.w),
                _buildTag(tagInfo, isCompleted ? Colors.white : AppColors.iconOrange, isCompleted ? AppColors.primary : AppColors.backgroundNotification, isCompleted),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          
          // Footer
          Text(
            isCompleted ? 'Completed by $addedBy\n${completedAgo ?? ''}' : 'Added by $addedBy',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w400,
              fontSize: 8.sp,
              color: isCompleted ? AppColors.primary : AppColors.iconGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40.w,
      height: 40.w,
      alignment: Alignment.center,
      child: fallbackIcon != null
          ? Icon(fallbackIcon, size: 28.sp, color: isCompleted ? AppColors.primary : Colors.black)
          : Image.asset(iconAsset, width: 28.w, height: 28.w, color: isCompleted ? AppColors.primary : Colors.black),
    );
  }

  Widget _buildTag(String text, Color textColor, Color bgColor, bool isCompleted) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w500,
          fontSize: 10.sp,
          color: textColor,
        ),
      ),
    );
  }
}
