import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_assets.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool showArrow;

  final bool isOutlined;
  final IconData? prefixIcon;
  final String? svgPrefix;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.showArrow = true,
    this.isOutlined = false,
    this.prefixIcon,
    this.svgPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 51.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : AppColors.primary,
          foregroundColor: isOutlined ? AppColors.primary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: isOutlined
                ? const BorderSide(color: AppColors.primary, width: 1.5)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: 20.sp, color: isOutlined ? AppColors.primary : Colors.white),
              SizedBox(width: 8.w),
            ],
            if (svgPrefix != null) ...[
              SvgPicture.asset(
                svgPrefix!,
                width: 20.sp,
                height: 20.sp,
                colorFilter: ColorFilter.mode(
                  isOutlined ? AppColors.primary : Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: isOutlined ? AppColors.primary : Colors.white,
              ),
            ),
            if (showArrow) ...[
              SizedBox(width: 8.w),
              SvgPicture.asset(
                AppAssets.nextArrowIcon,
                width: 16.w,
                height: 16.w,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
