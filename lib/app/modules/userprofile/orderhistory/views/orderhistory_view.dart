import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_shimmer.dart';
import '../../widgets/custom_segmented_control.dart';
import '../../widgets/order_card.dart';
import '../../widgets/profile_app_bar.dart';
import '../controllers/orderhistory_controller.dart';

class OrderhistoryView extends GetView<OrderhistoryController> {
  const OrderhistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: 'Order History'),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(
              () => CustomSegmentedControl(
                options: controller.tabOptions,
                selectedIndex: controller.selectedTabIndex.value,
                onChanged: controller.onTabChanged,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.fetchOrders,
              color: AppColors.primary,
              child: Obx(() {
                if (controller.isLoading.value && controller.orders.isEmpty) {
                  return _buildShimmerList();
                }

                if (controller.filteredOrders.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredOrders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return OrderCard(
                      title: order.displayTitle,
                      restaurantName: order.displayRestaurantName,
                      timeAgo: order.timeAgo,
                      price: order.totalPrice,
                      status: OrderCard.statusFromString(order.status),
                      type: order.isDelivery
                          ? OrderType.delivery
                          : OrderType.pickup,
                      onPrimaryAction: () {
                        if (order.isActive) {
                          controller.trackOrder(order);
                        } else {
                          controller.reorder(order);
                        }
                      },
                      onSecondaryAction: order.isCompleted
                          ? () {
                              controller.reviewOrder(order);
                            }
                          : null,
                      onChevronTap: () {
                        controller.showOrderDetailsSheet(order);
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer.rectangular(
                        height: 18,
                        width: 160,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      CustomShimmer.rectangular(
                        height: 14,
                        width: 100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  CustomShimmer.rectangular(
                    height: 24,
                    width: 70,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomShimmer.rectangular(
                height: 14,
                width: 200,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomShimmer.rectangular(
                      height: 40,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomShimmer.rectangular(
                    height: 40,
                    width: 40,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Orders Found',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have no ${controller.tabOptions[controller.selectedTabIndex.value].toLowerCase()} orders at the moment.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
