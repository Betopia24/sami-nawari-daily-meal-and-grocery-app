import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/custom_shimmer.dart';
import '../../widgets/delivery_method_selector.dart';
import '../../widgets/delivery_option_card.dart';
import '../../widgets/delivery_selection_shimmer.dart';
import '../../widgets/review_restaurant_card.dart';
import '../../widgets/step_indicator.dart';
import '../controllers/deliveryselection_controller.dart';

class DeliveryselectionView extends GetView<DeliveryselectionController> {
  const DeliveryselectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 24, top: 8, bottom: 8),
          child: CustomBackButton(),
        ),
        title: Text(
          'Select Delivery',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const StepIndicator(currentStep: 1), // 1 = Delivery
          const Divider(height: 1, thickness: 1, color: AppColors.borderGrey),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const DeliverySelectionShimmer();
              }

              if (controller.cartGroups.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No delivery options available',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchCart,
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: controller.cartGroups.length,
                  itemBuilder: (context, index) {
                    final group = controller.cartGroups[index];
                    final isPickupOnly = group.hasPickup && group.deliveryFee <= 0;

                    return ReviewRestaurantCard(
                      restaurantImage: group.restaurantImage,
                      restaurantName: group.sellerName,
                      authorName: group.authorName,
                      timeText: group.prepTime,
                      totalPrice: group.totalPrice,
                      items: [
                        ...group.items.map(
                          (item) => _buildSimpleItemRow(
                            '${item.quantity}x ${item.name}',
                            item.price * item.quantity,
                          ),
                        ),
                        DeliveryMethodSelector(
                          noticeText: isPickupOnly
                              ? 'This kitchen offers pickup only'
                              : null,
                          options: [
                            if (group.hasPickup)
                              DeliveryOptionCard(
                                title: 'Pickup',
                                subtitle: 'Collect from the kitchen',
                                priceText: 'Free',
                                iconPath: AppAssets.pickupIcon,
                                isSelected: controller.selectedMethods[index] == 0,
                                onTap: () => controller.selectMethod(index, 0),
                              ),
                            if (group.deliveryFee > 0 || !group.hasPickup)
                              DeliveryOptionCard(
                                title: 'Delivery \$${group.deliveryFee.toStringAsFixed(2)}',
                                subtitle: 'Delivered by ${group.authorName}',
                                priceText: '\$${group.deliveryFee.toStringAsFixed(2)}',
                                iconPath: AppAssets.deliveryIcon,
                                isSelected: controller.selectedMethods[index] == 1,
                                onTap: () => controller.selectMethod(index, 1),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
          ),
          // Bottom Continue Button
          Obx(
            () => controller.isLoading.value
                ? Container(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 16,
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: CustomShimmer.card(
                      width: double.infinity,
                      height: 52,
                      radius: 16,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 16,
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: GestureDetector(
                      onTap: controller.onContinue,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleItemRow(String title, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
