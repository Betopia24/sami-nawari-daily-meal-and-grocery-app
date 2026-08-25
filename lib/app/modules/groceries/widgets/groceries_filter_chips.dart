import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';

class GroceriesFilterChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  const GroceriesFilterChips({
    super.key,
    this.selectedIndex = 0,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(0, "All (10)"),
          SizedBox(width: 8.w),
          _buildChip(1, "Pending (7)"),
          SizedBox(width: 8.w),
          _buildChip(2, "Completed (3)"),
        ],
      ),
    );
  }

  Widget _buildChip(int index, String label) {
    bool isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () {
        if (onSelected != null) {
          onSelected!(index);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.backgroundToggle,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected
              ? null
              : Border.all(color: AppColors.borderLight, width: 1.w),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
