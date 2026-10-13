import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;

  const InfoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
