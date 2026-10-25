import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';

class RecipeIngredientItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String amount;

  const RecipeIngredientItem({
    super.key,
    required this.imagePath,
    required this.name,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F5F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildIcon(imagePath),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _defaultPlaceholder(),
        ),
      );
    }
    if (path.isNotEmpty) {
      return Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _defaultPlaceholder(),
      );
    }
    return _defaultPlaceholder();
  }

  Widget _defaultPlaceholder() {
    return Center(
      child: Image.asset(
        AppAssets.logoCropped,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.restaurant_menu,
          size: 20,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
