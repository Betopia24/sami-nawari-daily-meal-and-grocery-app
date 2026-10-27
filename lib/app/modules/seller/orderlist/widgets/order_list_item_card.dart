import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/seller_order_model.dart';

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
  final VoidCallback? onTap;
  final SellerOrder? order;

  const OrderListItemCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.customerName,
    required this.dateTime,
    required this.itemsSummary,
    required this.itemsPrice,
    this.deliveryCharge,
    required this.deliveryType,
    required this.paymentMethod,
    this.onTap,
    this.order,
  });

  factory OrderListItemCard.fromOrder({
    Key? key,
    required SellerOrder order,
    VoidCallback? onTap,
  }) {
    final subTotal =
        order.sellerSubTotal > 0 ? order.sellerSubTotal : order.subTotal;
    return OrderListItemCard(
      key: key,
      orderId: order.displayOrderNumber,
      status: order.displayStatus,
      customerName: order.recipientName,
      dateTime: order.formattedDateTime,
      itemsSummary: order.itemsSummary,
      itemsPrice: '\$${subTotal.toStringAsFixed(2)}',
      deliveryCharge:
          order.deliveryFee > 0 ? '+\$${order.deliveryFee.toStringAsFixed(2)}' : null,
      deliveryType: order.deliveryType,
      paymentMethod: order.formattedPaymentMethod,
      order: order,
      onTap: onTap,
    );
  }

  Color _getStatusBgColor() {
    switch (status) {
      case 'New':
      case 'Confirmed':
      case 'Delivered':
        return AppColors.secondary.withValues(alpha: 0.15);
      case 'Preparing':
      case 'Accepted':
        return const Color(0xFF3B82F6).withValues(alpha: 0.15);
      case 'Out for Delivery':
        return const Color(0xFF8B5CF6).withValues(alpha: 0.15);
      case 'Completed':
        return AppColors.primary.withValues(alpha: 0.15);
      case 'Cancelled':
        return Colors.red.withValues(alpha: 0.15);
      default:
        return AppColors.backgroundGrey;
    }
  }

  Color _getStatusTextColor() {
    switch (status) {
      case 'New':
      case 'Confirmed':
      case 'Delivered':
        return AppColors.secondary;
      case 'Preparing':
      case 'Accepted':
        return const Color(0xFF3B82F6);
      case 'Out for Delivery':
        return const Color(0xFF8B5CF6);
      case 'Completed':
        return AppColors.primary;
      case 'Cancelled':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Get.toNamed(
              Routes.orderdetails,
              arguments: {
                'status': status,
                if (order != null) 'order': order,
              },
            );
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
                Expanded(
                  child: Text(
                    orderId,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
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
                Expanded(
                  child: Text(
                    customerName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
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
                Expanded(
                  child: Text(
                    itemsSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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

