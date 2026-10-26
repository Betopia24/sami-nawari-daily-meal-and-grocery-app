import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_assets.dart';

class CartRestaurantCard extends StatelessWidget {
  final String restaurantImage;
  final String restaurantName;
  final String authorName;
  final double totalPrice;
  final String timeText;
  final bool hasPickup;
  final double? deliveryFee;
  final List<Widget> items;

  const CartRestaurantCard({
    super.key,
    required this.restaurantImage,
    required this.restaurantName,
    required this.authorName,
    required this.totalPrice,
    required this.timeText,
    this.hasPickup = true,
    this.deliveryFee,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Restaurant Info
          Row(
            children: [
              ClipOval(
                child: _buildAvatar(restaurantImage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'by $authorName',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(
                iconPath: AppAssets.clockIcon,
                text: timeText,
                backgroundColor: const Color(0xFFF2EFE8),
                textColor: AppColors.textSecondary,
                iconColor: AppColors.textSecondary,
              ),
              if (hasPickup)
                _buildTag(
                  iconPath: AppAssets.pickupIcon,
                  text: 'Pickup',
                  backgroundColor: AppColors.backgroundLightGreen,
                  textColor: AppColors.primary,
                  iconColor: AppColors.primary,
                ),
              if (deliveryFee != null)
                _buildTag(
                  iconPath: AppAssets.deliveryIcon,
                  text: 'Delivery \$${deliveryFee!.toStringAsFixed(2)}',
                  backgroundColor: const Color(0xFFFEF3EA), // backgroundNotification
                  textColor: AppColors.secondary,
                  iconColor: AppColors.secondary,
                ),
            ],
          ),
          const SizedBox(height: 24),
          // Items
          ...items,
        ],
      ),
    );
  }

  Widget _buildTag({
    required String iconPath,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppAssets.homeRecipeCardImage1,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      path.isNotEmpty ? path : AppAssets.homeRecipeCardImage1,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        AppAssets.homeRecipeCardImage1,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
    );
  }
}
