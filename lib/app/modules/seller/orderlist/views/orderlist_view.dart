import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../controllers/orderlist_controller.dart';
import '../widgets/order_list_item_card.dart';

class OrderlistView extends GetView<OrderlistController> {
  const OrderlistView({Key? key}) : super(key: key);

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
                    'Orders',
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
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: const [
                  OrderListItemCard(
                    orderId: '#DM-2026-1012',
                    status: 'New',
                    customerName: 'Emily Chen',
                    dateTime: 'Today, 12:30 PM',
                    itemsSummary: '2x Classic Mezze Platter',
                    itemsPrice: r'$13.00',
                    deliveryCharge: null,
                    deliveryType: 'Pickup',
                    paymentMethod: 'Cash on Pickup',
                  ),
                  SizedBox(height: 16),
                  OrderListItemCard(
                    orderId: '#DM-2026-1011',
                    status: 'Preparing',
                    customerName: 'Alex Johnson',
                    dateTime: 'Today, 12:30 PM',
                    itemsSummary: '1x Classic Mezze Platter',
                    itemsPrice: r'$6.50',
                    deliveryCharge: r'+$2.50',
                    deliveryType: 'Delivery',
                    paymentMethod: 'Cash on Delivery',
                  ),
                  SizedBox(height: 16),
                  OrderListItemCard(
                    orderId: '#DM-2026-1010',
                    status: 'Out for Delivery',
                    customerName: 'Sofia Ansari',
                    dateTime: 'Today, 12:30 PM',
                    itemsSummary: '1x Classic Mezze Platter',
                    itemsPrice: r'$13.00',
                    deliveryCharge: null,
                    deliveryType: 'Pickup',
                    paymentMethod: 'Online Payment',
                  ),
                  SizedBox(height: 16),
                  OrderListItemCard(
                    orderId: '#DM-2026-1009',
                    status: 'Delivered',
                    customerName: 'Angel Zara',
                    dateTime: 'Today, 12:30 PM',
                    itemsSummary: '2x Classic Mezze Platter',
                    itemsPrice: r'$13.00',
                    deliveryCharge: r'+$2.50',
                    deliveryType: 'Delivery',
                    paymentMethod: 'Cash on Delivery',
                  ),
                  SizedBox(height: 16),
                  OrderListItemCard(
                    orderId: '#DM-2026-1008',
                    status: 'Completed',
                    customerName: 'James Johnson',
                    dateTime: 'Today, 12:30 PM',
                    itemsSummary: '3x Classic Mezze Platter',
                    itemsPrice: r'$19.50',
                    deliveryCharge: r'+$2.50',
                    deliveryType: 'Delivery',
                    paymentMethod: 'Online Payment',
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
