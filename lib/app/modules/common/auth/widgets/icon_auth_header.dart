import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';

class IconAuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? subtitleHighlight;

  const IconAuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitleHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Transform.scale(
              scale: 5,
              child: SvgPicture.asset(
                AppAssets.logoSvg,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (subtitleHighlight != null)
          RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                TextSpan(text: subtitle),
                TextSpan(
                  text: subtitleHighlight,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
      ],
    );
  }
}
