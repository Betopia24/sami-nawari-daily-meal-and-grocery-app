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
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

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
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = isCompleted ? const Color(0xFFF8FAF8) : AppColors.backgroundGrey;
    Color borderColor = isCompleted ? const Color(0xFFE2E8E2) : AppColors.borderLight;
    Color titleColor = isCompleted ? const Color(0xFF7E8A7E) : AppColors.textGreen;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
              decoration: BoxDecoration(
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
                  if (sizeInfo.isNotEmpty || tagInfo.isNotEmpty)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (sizeInfo.isNotEmpty)
                            _buildTag(
                              sizeInfo,
                              isCompleted ? const Color(0xFF6B756B) : Colors.white,
                              isCompleted ? const Color(0xFFE2E7E2) : AppColors.primary,
                              isCompleted,
                            ),
                          if (sizeInfo.isNotEmpty && tagInfo.isNotEmpty)
                            SizedBox(width: 4.w),
                          if (tagInfo.isNotEmpty)
                            _buildTag(
                              tagInfo,
                              isCompleted ? const Color(0xFF6B756B) : Colors.white,
                              isCompleted ? const Color(0xFFE2E7E2) : AppColors.primary,
                              isCompleted,
                            ),
                        ],
                      ),
                    ),
                  if (sizeInfo.isNotEmpty || tagInfo.isNotEmpty)
                    SizedBox(height: 2.h),

                  // Footer
                  Text(
                    isCompleted
                        ? 'Completed by $addedBy\n${completedAgo ?? ''}'
                        : 'Added by $addedBy',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w400,
                      fontSize: 8.sp,
                      color: isCompleted ? const Color(0xFF8A948A) : AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (isCompleted)
              Positioned(
                top: 6.h,
                right: 6.w,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 11.sp,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final iconColor = isCompleted
        ? AppColors.primary.withValues(alpha: 0.45)
        : AppColors.primary;

    return Container(
      width: 40.w,
      height: 40.w,
      alignment: Alignment.center,
      child: fallbackIcon != null
          ? Icon(fallbackIcon, size: 28.sp, color: iconColor)
          : Image.asset(
              iconAsset,
              width: 28.w,
              height: 28.w,
              color: iconColor,
            ),
    );
  }

  Widget _buildTag(
    String text,
    Color textColor,
    Color bgColor,
    bool isCompleted,
  ) {
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
