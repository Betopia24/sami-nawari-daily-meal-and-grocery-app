import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/app_colors.dart';

class ToggleSettingCard extends StatelessWidget {
  final String title;
  final String? icon;
  final String? subtitle;
  final bool isToggled;
  final ValueChanged<bool> onChanged;
  final Widget? expandedChild;
  final bool hasBorder;

  const ToggleSettingCard({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    required this.isToggled,
    required this.onChanged,
    this.expandedChild,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hasBorder ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              crossAxisAlignment: subtitle != null || icon != null
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: icon!.endsWith('.svg')
                        ? SvgPicture.asset(icon!, width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn))
                        : Image.asset(icon!, width: 24, height: 24),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: isToggled,
                  onChanged: onChanged,
                  activeTrackColor: AppColors.primary,
                ),
              ],
            ),
          ),
          if (isToggled && expandedChild != null)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: expandedChild!,
            ),
        ],
      ),
    );
  }
}
