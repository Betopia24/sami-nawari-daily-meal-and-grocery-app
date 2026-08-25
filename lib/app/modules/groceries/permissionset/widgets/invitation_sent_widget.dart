import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/profile_avatar.dart';
import '../controllers/permissionset_controller.dart';

class InvitationSentWidget extends StatelessWidget {
  final PermissionSetController controller = Get.find();

  InvitationSentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  // Animated SVG Graphic
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/graphics/invitationsent_graphic.svg',
                      height: 120.h,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    'Invitations Sent!',
                    style: GoogleFonts.outfit(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Your invitations have been\nsent successfully.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'INVITED (${controller.members.length})',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

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
                          child: _buildInvitedMemberCard(member),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          PrimaryButton(
            text: 'Done',
            showArrow: false,
            onPressed: () {
              // Navigate back to Shared Members or Home
              Get.back(); // Close bottom sheet
              Get.back(); // Close permission set
              Get.back(); // Close member invite
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInvitedMemberCard(PermissionMember member) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                  'james@gmail.com', // Should ideally come from the model, mocking for now
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Pending',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.access_time, color: AppColors.textSecondary, size: 24.sp),
        ],
      ),
    );
  }
}
