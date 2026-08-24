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
  final bool isEnabled;
  final IconData? prefixIcon;
  final String? svgPrefix;
  final String? trailingText;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.showArrow = true,
    this.isOutlined = false,
    this.isEnabled = true,
    this.prefixIcon,
    this.svgPrefix,
    this.trailingText,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 51.h,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: !isEnabled
              ? const Color(0xFFE0DFDB) // Disabled background color matching design
              : (backgroundColor ?? (isOutlined ? Colors.white : AppColors.primary)),
          foregroundColor: !isEnabled
              ? AppColors.textSecondary
              : (textColor ?? (isOutlined ? AppColors.primary : Colors.white)),
          disabledBackgroundColor: const Color(0xFFE0DFDB),
          disabledForegroundColor: AppColors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: isOutlined && isEnabled
                ? const BorderSide(color: AppColors.primary, width: 1.5)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: trailingText != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (prefixIcon != null) ...[
                          Icon(
                            prefixIcon,
                            size: 20.sp,
                            color: textColor ?? (isOutlined ? AppColors.primary : Colors.white),
                          ),
                          SizedBox(width: 8.w),
                        ],
                        if (svgPrefix != null) ...[
                          SvgPicture.asset(
                            svgPrefix!,
                            width: 20.sp,
                            height: 20.sp,
                            colorFilter: ColorFilter.mode(
                              textColor ?? (isOutlined ? AppColors.primary : Colors.white),
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
                            color: !isEnabled
                                ? AppColors.textSecondary
                                : (textColor ?? (isOutlined ? AppColors.primary : Colors.white)),
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
                    Text(
                      trailingText!,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: !isEnabled
                            ? AppColors.textSecondary
                            : (textColor ?? (isOutlined ? AppColors.primary : Colors.white)),
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      size: 20.sp,
                      color: textColor ?? (isOutlined ? AppColors.primary : Colors.white),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  if (svgPrefix != null) ...[
                    SvgPicture.asset(
                      svgPrefix!,
                      width: 20.sp,
                      height: 20.sp,
                      colorFilter: ColorFilter.mode(
                        textColor ?? (isOutlined ? AppColors.primary : Colors.white),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        text,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: !isEnabled
                              ? AppColors.textSecondary
                              : (textColor ?? (isOutlined ? AppColors.primary : Colors.white)),
                        ),
                      ),
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
