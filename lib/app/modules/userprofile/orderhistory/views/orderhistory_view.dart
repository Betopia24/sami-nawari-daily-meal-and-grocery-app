import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../widgets/profile_app_bar.dart';
import '../../widgets/custom_segmented_control.dart';
import '../../widgets/order_card.dart';
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
            child: Obx(
              () => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredOrders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final order = controller.filteredOrders[index];
                  return OrderCard(
                    title: order.title,
                    restaurantName: order.restaurantName,
                    timeAgo: order.timeAgo,
                    price: order.price,
                    status: order.status,
                    type: order.type,
                    onPrimaryAction: () {
                      // Trigger action (Reorder or Track Order)
                    },
                    onSecondaryAction:
                        order.status == OrderStatus.pickedUp ||
                            order.status == OrderStatus.delivered
                        ? () {
                            // Review action
                          }
                        : null,
                    onChevronTap: () {
                      // Navigate to details
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
