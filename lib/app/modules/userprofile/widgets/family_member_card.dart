import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/widgets/profile_avatar.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';

enum FamilyMemberRole { owner, editor, viewer }

class FamilyMemberCard extends StatelessWidget {
  final String name;
  final String detail;
  final String? imageUrl;
  final FamilyMemberRole role;
  final VoidCallback onMoreTap;

  const FamilyMemberCard({
    super.key,
    required this.name,
    required this.detail,
    this.imageUrl,
    required this.role,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          ProfileAvatar(imageUrl: imageUrl, radius: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          _buildRoleBadge(),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onMoreTap,
            child: Icon(Icons.more_horiz, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge() {
    Color bgColor;
    Color textColor;
    Widget icon;
    String roleName;

    switch (role) {
      case FamilyMemberRole.owner:
        bgColor = AppColors.backgroundLightGreen;
        textColor = AppColors.primary;
        roleName = 'Owner';
        // The user said "use correct emoji from utils". I will use the app_assets.dart items if they exist.
        // Wait, for Owner I'll use a crown icon if there was one, else a star icon from material.
        icon = Icon(Icons.workspace_premium, color: textColor, size: 14);
        break;
      case FamilyMemberRole.editor:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        roleName = 'Editor';
        icon = SvgPicture.asset(
          AppAssets.editIcon,
          width: 14,
          height: 14,
          colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
        );
        break;
      case FamilyMemberRole.viewer:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        roleName = 'Viewer';
        icon = SvgPicture.asset(
          AppAssets.eyeIcon,
          width: 14,
          height: 14,
          colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 4),
          Text(
            roleName,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
