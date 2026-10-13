import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/utils/app_colors.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String imagePath;
  final String label;
  final String title;
  final String description;

  const OnboardingPageWidget({
    super.key,
    required this.imagePath,
    required this.label,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Image Section
        Expanded(
          flex: 65,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              // Dark overlay
              Container(color: Colors.black.withOpacity(0.5)),
              // Label and Title overlay
              Positioned(
                left: 24.w,
                bottom: 32.h,
                right: 24.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.labelBackground,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        label,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Bottom Description Section
        Expanded(
          flex: 35,
          child: Container(
            color: AppColors.background,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
            child: Text(
              description,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w400,
                fontSize: 18.sp,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
