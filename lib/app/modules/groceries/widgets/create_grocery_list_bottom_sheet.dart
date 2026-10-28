import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/groceries_controller.dart';

class CreateGroceryListBottomSheet extends StatefulWidget {
  const CreateGroceryListBottomSheet({super.key});

  @override
  State<CreateGroceryListBottomSheet> createState() => _CreateGroceryListBottomSheetState();
}

class _CreateGroceryListBottomSheetState extends State<CreateGroceryListBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _shareWithFamily = false;
  int _selectedIconIndex = 0;

  final List<dynamic> _icons = [
    Icons.shopping_cart_outlined,
    Icons.ramen_dining_outlined,
    Icons.outdoor_grill_outlined,
    Icons.room_service_outlined,
    Icons.inventory_2_outlined,
    '🌙',
    '🎂',
    '⛺',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 24.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h, // Handle keyboard
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 48.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              'Create Grocery List',
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 16.h),

            // Preview Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.primary, width: 1.w),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: _buildIcon(_icons[_selectedIconIndex], size: 24.sp),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text.isNotEmpty ? _nameController.text : 'List Name',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _descController.text.isNotEmpty ? _descController.text : 'No description',
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Icon Section
            Text(
              'ICON',
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 48.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  bool isSelected = index == _selectedIconIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIconIndex = index;
                      });
                    },
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 1.w,
                        ),
                      ),
                      child: Center(
                        child: _buildIcon(_icons[index], size: 24.sp),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),

            // List Name Input
            Text(
              'LIST NAME',
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.borderLight, width: 1.w),
              ),
              child: TextField(
                controller: _nameController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'e.g. Weekly Grocery, BBQ Party...',
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Description Input
            Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.borderLight, width: 1.w),
              ),
              child: TextField(
                controller: _descController,
                onChanged: (value) => setState(() {}),
                maxLength: 36,
                decoration: InputDecoration(
                  hintText: 'Description (optional)',
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  counterText: '', // Hide the default character counter
                ),
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            SizedBox(height: 24.h),


            // Share Toggle
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.primary, width: 1.w), // Following mockup's green border
              ),
              child: Row(
                children: [
                  Icon(Icons.group_outlined, color: AppColors.textDark, size: 24.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share with Family',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Emma & James can view and edit',
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    value: _shareWithFamily,
                    activeTrackColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _shareWithFamily = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      backgroundColor: const Color(0xFFF3F3F3),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: PrimaryButton(
                    text: 'Create List',
                    showArrow: false,
                    onPressed: () async {
                      if (_nameController.text.trim().isEmpty) return;
                      
                      final controller = Get.find<GroceriesController>();
                      final success = await controller.createNewListApi(
                        name: _nameController.text.trim(),
                        description: _descController.text.trim(),
                        icon: _icons[_selectedIconIndex],
                      );
                      if (success) {
                        Get.back();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(dynamic iconData, {required double size}) {
    if (iconData is IconData) {
      return Icon(iconData, color: AppColors.textDark, size: size);
    } else if (iconData is String) {
      return Text(
        iconData,
        style: TextStyle(fontSize: size),
      );
    }
    return SizedBox();
  }
}
