import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/profile_avatar.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../routes/app_routes.dart';
import 'package:daily_meal_and_grocery_app/app/data/models/grocery_invitation_model.dart';
import '../controllers/shared_members_controller.dart';

class SharedMembersView extends GetView<SharedMembersController> {
  const SharedMembersView({super.key});

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
                    'Shared Members',
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
                          SizedBox(width: 16.w),
                          SvgPicture.asset(
                            'assets/icons/search_icon.svg',
                            width: 20.w,
                            height: 20.w,
                            colorFilter: const ColorFilter.mode(AppColors.iconGrey, BlendMode.srcIn),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search family members...',
                                hintStyle: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Pending Invitations Section (API #2 & #3)
                    Obx(() {
                      if (controller.myInvitations.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INVITATIONS RECEIVED (${controller.myInvitations.length})',
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ...controller.myInvitations.map((inv) => _buildInvitationCard(inv)),
                          SizedBox(height: 24.h),
                        ],
                      );
                    }),

                    // Section Title
                    Text(
                      'Edit Access Level For Each Member',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Members List Container
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: AppColors.borderLight, width: 1.w),
                      ),
                      child: Obx(() {
                        if (controller.members.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Center(
                              child: Text(
                                'No shared members yet. Invite family members below!',
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: controller.members
                              .map((member) => _buildMemberRow(member))
                              .toList(),
                        );
                      }),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Button
            Padding(
              padding: EdgeInsets.all(20.w),
              child: PrimaryButton(
                text: 'Invite Member',
                showArrow: false,
                onPressed: () => Get.toNamed(
                  Routes.MEMBERINVITE,
                  arguments: {'listId': controller.activeGroceryListId},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvitationCard(GroceryInvitationModel inv) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Icon(Icons.mail_outline, color: AppColors.primary, size: 18.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inv.listName,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Invited by ${inv.inviterName} (${inv.role == "EDITOR" ? "Can Edit" : "View Only"})',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.respondToInvitation(inv, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'Decline',
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.respondToInvitation(inv, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'Accept',
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberRow(Member member) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
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
          // Dropdown or Owner badge
          if (member.accessLevel == 'Owner')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(color: AppColors.primary, width: 1.w),
              ),
              child: Text(
                'Owner',
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            PopupMenuButton<String>(
              initialValue: member.accessLevel,
              onSelected: (String newValue) {
                if (newValue == 'Remove') {
                  _confirmRemoveMember(member);
                } else {
                  controller.updateAccessLevel(member.memberId, newValue);
                }
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
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'Remove',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18.sp, color: Colors.redAccent),
                      SizedBox(width: 8.w),
                      Text('Remove Member', style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      )),
                    ],
                  ),
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

  void _confirmRemoveMember(Member member) {
    Get.defaultDialog(
      title: 'Remove Member',
      titleStyle: GoogleFonts.outfit(fontSize: 18.sp, fontWeight: FontWeight.w700),
      middleText: 'Are you sure you want to remove ${member.name} from this grocery list?',
      middleTextStyle: GoogleFonts.outfit(fontSize: 14.sp, color: AppColors.textSecondary),
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: AppColors.textDark,
      onConfirm: () {
        Get.back();
        controller.removeMember(member);
      },
    );
  }
}


