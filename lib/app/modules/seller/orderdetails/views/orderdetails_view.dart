import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../controllers/orderdetails_controller.dart';
import '../widgets/customer_info_card.dart';
import '../widgets/info_card.dart';
import '../widgets/order_status_tracker.dart';
import '../widgets/order_summary_section.dart';

class OrderdetailsView extends GetView<OrderdetailsController> {
  const OrderdetailsView({super.key});

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'New':
      case 'Delivered':
        return AppColors.secondary.withValues(alpha: 0.15);
      case 'Preparing':
      case 'Accepted':
        return const Color(0xFF3B82F6).withValues(alpha: 0.15);
      case 'Out for Delivery':
        return const Color(0xFF8B5CF6).withValues(alpha: 0.15);
      case 'Completed':
        return AppColors.primary.withValues(alpha: 0.15);
      default:
        return AppColors.backgroundGrey;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'New':
      case 'Delivered':
        return AppColors.secondary;
      case 'Preparing':
      case 'Accepted':
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
    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 16),
                  Text(
                    'Order Details',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Obx(() => Row(
                children: controller.filters.map((filter) {
                  final isSelected = controller.selectedFilter.value == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () => controller.setFilter(filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.borderGrey,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                final status = controller.status.value;
                final isNew = status == 'New' || status == 'Confirmed';
                final ord = controller.order.value;

                final displayOrderId =
                    ord?.displayOrderNumber ?? '#DM-2026-1012';
                final displayDate = ord != null
                    ? (ord.formattedDateTime.isNotEmpty
                        ? ord.formattedDateTime
                        : 'Today, 12:30 PM')
                    : 'Today, 12:30 PM';
                final customerName = ord?.recipientName ?? 'Emily Chen';
                final customerPhone =
                    (ord?.contactPhone != null && ord!.contactPhone.isNotEmpty)
                        ? ord.contactPhone
                        : '+880 1234 567891';
                final items = (ord != null && ord.items.isNotEmpty)
                    ? ord.items
                        .map((i) => {
                              'name': '${i.quantity}x ${i.foodName}',
                              'price': '\$${i.subtotal.toStringAsFixed(2)}',
                            })
                        .toList()
                    : [
                        {
                          'name': '2x Classic Mezze Platter',
                          'price': r'$13.00'
                        },
                      ];
                final deliveryOrPickupCost = ord != null
                    ? (ord.deliveryFee > 0
                        ? '+\$${ord.deliveryFee.toStringAsFixed(2)}'
                        : 'Free')
                    : 'Free';
                final totalCost = ord != null
                    ? '\$${ord.totalPrice.toStringAsFixed(2)}'
                    : r'$13.00';
                final orderType = ord?.deliveryType ?? 'Pickup';
                final paymentMethod =
                    ord?.formattedPaymentMethod ?? 'Cash on Pickup';
                final addressTitle = orderType == 'Delivery'
                    ? 'Delivery Address'
                    : 'Pickup Address';
                final addressSubtitle = (ord?.deliveryAddress != null &&
                        ord!.deliveryAddress!.fullAddress.isNotEmpty)
                    ? ord.deliveryAddress!.fullAddress
                    : '123 Market St, San Francisco, CA';
                final orderTypeIcon = orderType == 'Delivery'
                    ? AppAssets.deliveryIcon
                    : AppAssets.pickupIcon;

                return Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              displayOrderId,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusBgColor(status),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                status,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusTextColor(status),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayDate,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (!isNew) ...[
                          Obx(
                            () => OrderStatusTracker(
                              currentStatus: controller.status.value,
                              isLoading: controller.isUpdatingStatus.value,
                              onConfirm: (newStatus) {
                                controller.updateOrderStatus(newStatus);
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        CustomerInfoCard(
                          name: customerName,
                          phone: customerPhone,
                          imageUrl:
                              'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                        ),
                        const SizedBox(height: 24),
                        OrderSummarySection(
                          items: items,
                          pickupCost: deliveryOrPickupCost,
                          totalCost: totalCost,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: InfoCard(
                                title: 'Order Type',
                                subtitle: orderType,
                                iconPath: orderTypeIcon,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InfoCard(
                                title: 'Payment Method',
                                subtitle: paymentMethod,
                                iconPath: AppAssets.cashOnDeliveryIcon,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        InfoCard(
                          title: addressTitle,
                          subtitle: addressSubtitle,
                          iconPath: AppAssets.locationIcon,
                        ),
                        if (ord?.note != null && ord!.note!.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          InfoCard(
                            title: 'Customer Note',
                            subtitle: ord.note!,
                            iconPath: AppAssets.tipsIcon,
                          ),
                        ],
                        const SizedBox(height: 40),
                      ],
                    ),
                    if (isNew)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundOffWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 54,
                                  child: Obx(
                                    () => ElevatedButton(
                                      onPressed:
                                          controller.isUpdatingStatus.value
                                              ? null
                                              : controller.acceptOrder,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: controller.isUpdatingStatus.value
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              'Accept',
                                              style: GoogleFonts.outfit(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SizedBox(
                                  height: 54,
                                  child: OutlinedButton(
                                    onPressed: controller.declineOrder,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFFFF4B4B)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Decline',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFF4B4B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
