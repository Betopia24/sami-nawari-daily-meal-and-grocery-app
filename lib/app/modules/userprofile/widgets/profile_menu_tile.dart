import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/utils/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;
  final bool showBottomDivider;

  const ProfileMenuTile({
    super.key,
    required this.iconPath,
    required this.title,
    this.trailing,
    this.onTap,
    this.textColor,
    this.showBottomDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                iconPath.endsWith('.svg')
                    ? SvgPicture.asset(
                        iconPath,
                        width: 24,
                        height: 24,
                        colorFilter: textColor != null
                            ? ColorFilter.mode(textColor!, BlendMode.srcIn)
                            : null,
                      )
                    : Image.asset(
                        iconPath,
                        width: 24,
                        height: 24,
                        color: textColor,
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? AppColors.textPrimary,
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing!
                else
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.withValues(alpha: 0.5),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        if (showBottomDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.withValues(alpha: 0.15),
          ),
      ],
    );
  }
}
