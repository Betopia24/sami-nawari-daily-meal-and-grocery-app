import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodChipsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color themeColor;
  final Color chipBackgroundColor;
  final List<String> foods;

  const FoodChipsCard({
    super.key,
    required this.title,
    required this.icon,
    required this.themeColor,
    required this.chipBackgroundColor,
    required this.foods,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F1F1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: themeColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: themeColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 12.h,
            children: foods.map((food) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: chipBackgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  food,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: themeColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
