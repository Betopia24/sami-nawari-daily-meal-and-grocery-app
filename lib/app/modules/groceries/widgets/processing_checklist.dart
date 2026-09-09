import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';

class ProcessingChecklist extends StatelessWidget {
  const ProcessingChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChecklistItem("Checking your pantry items"),
          SizedBox(height: 20.h),
          _buildChecklistItem("Looking at your recent purchases"),
          SizedBox(height: 20.h),
          _buildChecklistItem("Finding the best meal ideas"),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: AppColors.primary,
          size: 24.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
