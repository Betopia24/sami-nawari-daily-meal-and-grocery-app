import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../widgets/primary_button.dart';

enum OrderStatus { delivered, pickedUp, preparing }

enum OrderType { delivery, pickup }

class OrderCard extends StatelessWidget {
  final String title;
  final String restaurantName;
  final String timeAgo;
  final double price;
  final OrderStatus status;
  final OrderType type;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onChevronTap;

  const OrderCard({
    super.key,
    required this.title,
    required this.restaurantName,
    required this.timeAgo,
    required this.price,
    required this.status,
    required this.type,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.onChevronTap,
  });

  Color _getStatusColor() {
    switch (status) {
      case OrderStatus.delivered:
      case OrderStatus.pickedUp:
        return AppColors.primary;
      case OrderStatus.preparing:
        return AppColors.iconOrange;
    }
  }

  String _getStatusText() {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.preparing:
        return 'Preparing';
    }
  }

  String _getTypeText() {
    return type == OrderType.delivery ? 'Delivery' : 'Pickup';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurantName,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(),
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                timeAgo,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '·',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SvgPicture.asset(
                type == OrderType.delivery
                    ? AppAssets.deliveryIcon
                    : AppAssets.pickupIcon,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _getTypeText(),
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '·',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (status == OrderStatus.preparing)
                      Expanded(
                        child: PrimaryButton(
                          text: 'Track Order',
                          showArrow: false,
                          height: 40,
                          onPressed: onPrimaryAction ?? () {},
                        ),
                      )
                    else ...[
                      Expanded(
                        child: _buildActionButton(
                          'Reorder',
                          AppColors.textDark,
                          AppColors.backgroundToggle,
                          onPrimaryAction,
                        ),
                      ),
                      if (onSecondaryAction != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            'Review',
                            AppColors.iconOrange,
                            AppColors.iconOrange.withValues(alpha: 0.1),
                            onSecondaryAction,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onChevronTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundToggle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color textColor,
    Color bgColor,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
