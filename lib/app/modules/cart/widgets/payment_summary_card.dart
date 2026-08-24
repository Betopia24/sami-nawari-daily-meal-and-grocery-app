import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';

class PaymentSummaryCard extends StatelessWidget {
  final double itemsSubtotal;
  final double deliveryFee;
  final double platformFee;

  const PaymentSummaryCard({
    super.key,
    required this.itemsSubtotal,
    required this.deliveryFee,
    required this.platformFee,
  });

  double get totalPayable => itemsSubtotal + deliveryFee + platformFee;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Items Subtotal', '\$${itemsSubtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildRow('Delivery Fee', '+\$${deliveryFee.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildRow('Platform Fee', '\$${platformFee.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 1, color: AppColors.borderGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable Ammount', // Note: typo 'Ammount' kept to match design if desired, or fix to 'Amount'
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '\$${totalPayable.toStringAsFixed(2)}',
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
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
