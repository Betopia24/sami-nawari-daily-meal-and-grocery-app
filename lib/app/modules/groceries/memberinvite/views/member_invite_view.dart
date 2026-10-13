import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/profile_avatar.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/member_invite_controller.dart';

class MemberInviteView extends GetView<MemberInviteController> {
  const MemberInviteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                children: [
                  CustomBackButton(
                    onTap: () => Get.back(),
                    backgroundColor: Colors.white,
                    iconColor: Colors.black,
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Invite Members',
                    style: GoogleFonts.outfit(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.borderLight, width: 1.w),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: SvgPicture.asset(
                              AppAssets.searchIcon,
                              colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
                              width: 20.sp,
                              height: 20.sp,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search family members...',
                                hintStyle: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 4.h),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Family Members Section
                    Text(
                      'FAMILY MEMBERS',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    
                    Obx(() => Column(
                      children: controller.familyMembers.map((member) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildMemberCard(member),
                        );
                      }).toList(),
                    )),

                    SizedBox(height: 24.h),

                    // Other Options Section
                    Text(
                      'OTHER OPTIONS',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Invite by Email Card
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.borderLight, width: 1.w),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.mail_outline, color: AppColors.textDark, size: 24.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Invite by Email',
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 24.sp),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 32.h), // Bottom padding
                  ],
                ),
              ),
            ),
            
            // Bottom Sticky Button
            Padding(
              padding: EdgeInsets.all(20.w),
              child: PrimaryButton(
                text: 'Continue',
                showArrow: false,
                onPressed: () {
                  if (controller.familyMembers.any((m) => m.isSelected)) {
                    Get.toNamed(Routes.PERMISSIONSET);
                  } else {
                    Get.snackbar(
                      'No Member Selected',
                      'Please select at least one family member to invite.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                      margin: EdgeInsets.all(20.w),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(FamilyMember member) {
    return GestureDetector(
      onTap: () => controller.toggleSelection(member.id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: member.isSelected ? const Color(0xFFE8F5EE) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: member.isSelected ? AppColors.primary : AppColors.borderLight,
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            ProfileAvatar(
              radius: 20.r,
              imageUrl: member.avatarPath,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    member.email,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: member.isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: member.isSelected ? AppColors.primary : AppColors.borderLight,
                  width: 1.w,
                ),
              ),
              child: member.isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
