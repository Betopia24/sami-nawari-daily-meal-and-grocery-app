import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/seller_food_model.dart';
import '../../../../widgets/custom_recipe_cover.dart';

class SellerFoodCard extends StatelessWidget {
  final SellerFoodItem food;
  final VoidCallback? onTap;
  final void Function(SellerFoodItem)? onEdit;
  final void Function(SellerFoodItem)? onDelete;

  const SellerFoodCard({
    super.key,
    required this.food,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  Color _getStatusBgColor() {
    if (food.isPending) {
      return const Color(0xFFFEF3C7); // Warm amber
    } else if (food.isApproved) {
      return AppColors.primary.withValues(alpha: 0.12);
    } else if (food.isRejected) {
      return Colors.red.withValues(alpha: 0.12);
    }
    return AppColors.backgroundGrey;
  }

  Color _getStatusTextColor() {
    if (food.isPending) {
      return const Color(0xFFD97706); // Darker amber
    } else if (food.isApproved) {
      return AppColors.primary;
    } else if (food.isRejected) {
      return Colors.red;
    }
    return AppColors.textSecondary;
  }

  String _getStatusText() {
    if (food.isPending) return 'Pending';
    if (food.isApproved) return 'Approved';
    if (food.isRejected) return 'Rejected';
    return food.status;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image / Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 88,
                height: 88,
                child: food.firstImage.isNotEmpty
                    ? Image.network(
                        food.firstImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const CustomRecipeCover(
                          width: 88,
                          height: 88,
                        ),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const CustomRecipeCover(
                        width: 88,
                        height: 88,
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // Food details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Status badge + Action Menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          food.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusBgColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getStatusTextColor(),
                          ),
                        ),
                      ),
                      if (onEdit != null || onDelete != null) ...[
                        const SizedBox(width: 2),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: Colors.grey.shade600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (value) {
                              if (value == 'edit' && onEdit != null) {
                                onEdit!(food);
                              } else if (value == 'delete' && onDelete != null) {
                                onDelete!(food);
                              }
                            },
                            itemBuilder: (context) => [
                              if (onEdit != null)
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  height: 40,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Edit Food',
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (onDelete != null)
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  height: 40,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Delete Food',
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Category • Subcategory
                  if (food.categorySubtitle.isNotEmpty)
                    Text(
                      food.categorySubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Price and Prep Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        food.formattedPrice,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            food.preparationTime,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Delivery / Pickup info
                  Text(
                    food.deliveryFee > 0
                        ? '${food.deliveryText} • Fee \$${food.deliveryFee.toStringAsFixed(2)}'
                        : food.deliveryText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
