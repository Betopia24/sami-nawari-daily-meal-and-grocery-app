import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../../core/utils/app_colors.dart';

class OrderListItemCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String customerName;
  final String dateTime;
  final String itemsSummary;
  final String itemsPrice;
  final String? deliveryCharge;
  final String deliveryType;
  final String paymentMethod;

  const OrderListItemCard({
    Key? key,
    required this.orderId,
    required this.status,
    required this.customerName,
    required this.dateTime,
    required this.itemsSummary,
    required this.itemsPrice,
    this.deliveryCharge,
    required this.deliveryType,
    required this.paymentMethod,
  }) : super(key: key);

  Color _getStatusBgColor() {
    switch (status) {
      case 'New':
      case 'Delivered':
        return AppColors.secondary.withOpacity(0.15);
      case 'Preparing':
        return const Color(0xFF3B82F6).withOpacity(0.15);
      case 'Out for Delivery':
        return const Color(0xFF8B5CF6).withOpacity(0.15);
      case 'Completed':
        return AppColors.primary.withOpacity(0.15);
      default:
        return AppColors.backgroundGrey;
    }
  }

  Color _getStatusTextColor() {
    switch (status) {
      case 'New':
      case 'Delivered':
        return AppColors.secondary;
      case 'Preparing':
        return const Color(0xFF3B82F6);
      case 'Out for Delivery':
        return const Color(0xFF8B5CF6);
      case 'Completed':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.orderdetails, arguments: {'status': status});
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderId,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getStatusTextColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  customerName,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  dateTime,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemsSummary,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  itemsPrice,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            if (deliveryCharge != null) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Charge',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    deliveryCharge!,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Text(
              '$deliveryType • $paymentMethod',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
