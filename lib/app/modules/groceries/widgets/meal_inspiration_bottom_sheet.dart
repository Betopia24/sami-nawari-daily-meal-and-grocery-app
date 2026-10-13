import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../widgets/primary_button.dart';
import 'pantry_item_chip.dart';
import '../views/ai_meal_processing_view.dart';

class MealInspirationBottomSheet extends StatefulWidget {
  const MealInspirationBottomSheet({super.key});

  @override
  State<MealInspirationBottomSheet> createState() => _MealInspirationBottomSheetState();
}

class _MealInspirationBottomSheetState extends State<MealInspirationBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  
  // Sample data for demonstration
  final List<String> _currentItems = ['Cherry tomatoes', 'Free Range Eggs', 'Coconut Milk', 'Rice', 'Chicken', 'Bread'];
  final Set<String> _selectedItems = {'Cherry tomatoes', 'Free Range Eggs', 'Coconut Milk'};
  
  final List<String> _recentItems = ['Avocado', 'Sourdough bread', 'Salmon fillet'];

  void _toggleItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 60.h,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBF9), // Very light beige background matching screenshot
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SafeArea(
          bottom: false, // Bottom is handled by viewInsets
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.primary, size: 24.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Meal Inspiration',
                            style: GoogleFonts.outfit(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(Icons.close, color: AppColors.textSecondary, size: 24.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  
                  Text(
                    'What do you have in your pantry?',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Select the items you currently have. We'll use these items along with your recent purchases to suggest meals.",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Search Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.borderLight, width: 1.w),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.outfit(fontSize: 16.sp, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search Ingredients',
                        hintStyle: GoogleFonts.outfit(fontSize: 16.sp, color: AppColors.textSecondary.withValues(alpha: 0.7)),
                        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary.withValues(alpha: 0.7), size: 20.sp),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Current Items
                  Text(
                    'Your current items',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: _currentItems.map((item) {
                      final isSelected = _selectedItems.contains(item);
                      return PantryItemChip(
                        text: item,
                        isSelected: isSelected,
                        onTap: () => _toggleItem(item),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Add Pantry Item Button
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add, color: AppColors.primary, size: 20.sp),
                    label: Text(
                      'Add pantry item',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Recently Purchased
                  Text(
                    'Recently purchased',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: _recentItems.map((item) {
                      final isSelected = _selectedItems.contains(item);
                      return PantryItemChip(
                        text: item,
                        isSelected: isSelected,
                        onTap: () => _toggleItem(item),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 32.h),
                  
                  PrimaryButton(
                    text: 'Get Meal Ideas',
                    showArrow: false,
                    onPressed: () {
                      Get.back();
                      Get.to(() => const AiMealProcessingView());
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
