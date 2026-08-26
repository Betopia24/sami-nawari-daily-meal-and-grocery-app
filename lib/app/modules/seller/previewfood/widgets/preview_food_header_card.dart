import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../foodgrid/widgets/food_badge.dart';

class PreviewFoodHeaderCard extends StatelessWidget {
  final String price;
  final String rating;
  final String reviewCount;
  final String time;
  final String mealType;

  const PreviewFoodHeaderCard({
    super.key,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.time,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.secondary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    reviewCount,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                FoodBadge(
                  text: time,
                  iconPath: AppAssets.clockIcon,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                FoodBadge(
                  text: mealType,
                  iconPath: AppAssets.serveIcon,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                const FoodBadge(
                  text: 'Pickup',
                  iconPath: AppAssets.pickupIcon,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                const FoodBadge(
                  text: 'Delivery',
                  iconPath: AppAssets.deliveryIcon,
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
