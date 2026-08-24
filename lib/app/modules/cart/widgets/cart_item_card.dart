import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import 'quantity_selector.dart';

class CartItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double pricePerItem;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onBookmark;
  final VoidCallback onDelete;

  const CartItemCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.pricePerItem,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onBookmark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final double totalPrice = pricePerItem * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EFE8), // Matches the soft beige from design
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${pricePerItem.toStringAsFixed(2)} each',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    QuantitySelector(
                      quantity: quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onBookmark,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_border, size: 18, color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppAssets.deleteIcon,
                    width: 16,
                    height: 16,
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
