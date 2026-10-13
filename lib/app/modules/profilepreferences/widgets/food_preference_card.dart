import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';

class FoodPreferenceCard extends StatelessWidget {
  final String iconPathOrEmoji;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const FoodPreferenceCard({
    Key? key,
    required this.iconPathOrEmoji,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  bool get _isAsset =>
      iconPathOrEmoji.endsWith('.png') || iconPathOrEmoji.endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.backgroundLightGreen : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.backgroundGrey,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.5)
                    : AppColors.backgroundOffWhite,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _isAsset
                    ? Image.asset(iconPathOrEmoji, width: 24, height: 24)
                    : Text(
                        iconPathOrEmoji,
                        style: const TextStyle(fontSize: 24),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: GoogleFonts.outfit(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
