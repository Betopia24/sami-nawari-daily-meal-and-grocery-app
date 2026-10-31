import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../data/models/grocery_list_model.dart';
import '../../../routes/app_routes.dart';

class GroceriesSectionHeader extends StatelessWidget {
  final String title;
  final List<GroceryMemberModel> members;
  final VoidCallback? onTap;

  const GroceriesSectionHeader({
    super.key,
    required this.title,
    this.members = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: onTap ?? () => Get.toNamed(Routes.sharedmembers),
          child: _buildMembersWidget(),
        ),
      ],
    );
  }

  Widget _buildMembersWidget() {
    if (members.isEmpty) {
      return _buildInviteButton();
    }

    if (members.length == 1) {
      return SizedBox(
        width: 42.w,
        height: 24.w,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: _buildInviteButton(),
            ),
            Positioned(
              right: 14.w,
              child: _buildAvatar(members[0]),
            ),
          ],
        ),
      );
    }

    if (members.length == 2) {
      return SizedBox(
        width: 42.w,
        height: 24.w,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: _buildAvatar(members[1]),
            ),
            Positioned(
              right: 14.w,
              child: _buildAvatar(members[0]),
            ),
          ],
        ),
      );
    }

    // 3 or more members
    return SizedBox(
      width: 56.w,
      height: 24.w,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade400,
                border: Border.all(color: const Color(0xFFE8E4DF), width: 1.5.w),
              ),
              alignment: Alignment.center,
              child: Text(
                '+${members.length - 2}',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            right: 14.w,
            child: _buildAvatar(members[1]),
          ),
          Positioned(
            right: 28.w,
            child: _buildAvatar(members[0]),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(GroceryMemberModel member) {
    if (member.profilePicture != null && member.profilePicture!.trim().isNotEmpty) {
      return Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
          border: Border.all(color: const Color(0xFFE8E4DF), width: 1.5.w),
        ),
        child: ClipOval(
          child: Image.network(
            member.profilePicture!,
            width: 24.w,
            height: 24.w,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildInitialsAvatar(member.name),
          ),
        ),
      );
    }
    return _buildInitialsAvatar(member.name);
  }

  Widget _buildInitialsAvatar(String name) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.15),
        border: Border.all(color: const Color(0xFFE8E4DF), width: 1.5.w),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.outfit(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildInviteButton() {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8E4DF), width: 1.5.w),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.add,
        size: 14.sp,
        color: AppColors.primary,
      ),
    );
  }
}

