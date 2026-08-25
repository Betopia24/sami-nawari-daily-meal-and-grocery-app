import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/profile_avatar.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/permissionset_controller.dart';
import '../widgets/invitation_sent_widget.dart';

class PermissionSetView extends GetView<PermissionSetController> {
  const PermissionSetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Obx(() {
          if (controller.isSent.value) {
            return InvitationSentWidget();
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Set Permission',
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
                      Text(
                        'Set Access Level For Each Member',
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.borderLight, width: 1.w),
                        ),
                        child: Column(
                          children: controller.members.map((member) {
                            bool isLast = controller.members.last == member;
                            return Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
                              child: _buildMemberCard(member),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom Sticky Button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: PrimaryButton(
                  text: 'Send Invitation',
                  showArrow: false,
                  onPressed: () {
                    controller.sendInvitations();
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMemberCard(PermissionMember member) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight, width: 1.w),
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
                  member.permissionDescription,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Dropdown
          PopupMenuButton<String>(
            initialValue: member.accessLevel,
            onSelected: (String newValue) {
              controller.updateAccessLevel(member.id, newValue);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 4,
            offset: Offset(0, 36.h),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Can Edit',
                child: Text('Can Edit', style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: member.accessLevel == 'Can Edit' ? FontWeight.w600 : FontWeight.w400,
                  color: member.accessLevel == 'Can Edit' ? AppColors.primary : AppColors.textDark,
                )),
              ),
              PopupMenuItem<String>(
                value: 'View Only',
                child: Text('View Only', style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: member.accessLevel == 'View Only' ? FontWeight.w600 : FontWeight.w400,
                  color: member.accessLevel == 'View Only' ? AppColors.primary : AppColors.textDark,
                )),
              ),
            ],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColors.borderLight, width: 1.w),
              ),
              child: Row(
                children: [
                  Text(
                    member.accessLevel,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.keyboard_arrow_down, size: 16.sp, color: AppColors.textDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
