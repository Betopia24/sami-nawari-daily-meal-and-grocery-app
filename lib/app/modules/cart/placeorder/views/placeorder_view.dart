import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/custom_shimmer.dart';
import '../../../../widgets/primary_button.dart';
import '../../widgets/delivery_method_selector.dart';
import '../../widgets/delivery_option_card.dart';
import '../../widgets/order_summary_card.dart';
import '../../widgets/payment_shimmer.dart';
import '../../widgets/payment_summary_card.dart';
import '../../widgets/secure_payment_banner.dart';
import '../../widgets/step_indicator.dart';
import '../controllers/placeorder_controller.dart';

class PlaceorderView extends GetView<PlaceorderController> {
  const PlaceorderView({super.key});

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
          'Payment',
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
          const StepIndicator(currentStep: 3), // 3 = Payment (all steps green)
          const Divider(height: 1, thickness: 1, color: AppColors.borderGrey),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const PaymentShimmer();
              }

              if (controller.cartGroups.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No order items found',
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
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section: Order Summary
                      Text(
                        'Order Summary',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dynamic Order Summary Card for each restaurant group
                      ...controller.cartGroups.asMap().entries.map((entry) {
                        final index = entry.key;
                        final group = entry.value;
                        final isPickup = controller.isPickup(index);
                        final deliveryFee = controller.getDeliveryFeeForGroup(index);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: OrderSummaryCard(
                            restaurantImage: group.restaurantImage,
                            restaurantName: group.sellerName,
                            statusTag: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isPickup
                                    ? const Color(0xFFECFDF5) // Soft green
                                    : const Color(0xFFFFF7ED), // Soft orange
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isPickup
                                      ? const Color(0xFFA7F3D0)
                                      : const Color(0xFFFFEDD5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    isPickup
                                        ? AppAssets.pickupIcon
                                        : AppAssets.deliveryIcon,
                                    width: 16,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(
                                      isPickup
                                          ? const Color(0xFF059669)
                                          : const Color(0xFFEA580C),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isPickup ? 'Pickup' : 'Delivery',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isPickup
                                          ? const Color(0xFF059669)
                                          : const Color(0xFFEA580C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            items: [
                              ...group.items.map(
                                (item) => _buildSimpleItemRow(
                                  '${item.quantity}x ${item.name}',
                                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                ),
                              ),
                              _buildSimpleItemRow(
                                'Delivery Charge',
                                isPickup
                                    ? 'Free'
                                    : '+\$${deliveryFee.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 8),

                      // Section: Payment Summary
                      Text(
                        'Payment Summary',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PaymentSummaryCard(
                        itemsSubtotal: controller.itemsSubtotal,
                        deliveryFee: controller.totalDeliveryFee,
                        platformFee: controller.platformFee,
                      ),
                      const SizedBox(height: 24),

                      // Section: Payment Method Selector
                      DeliveryMethodSelector(
                        title: 'Payment Method',
                        subtitle: 'Choose how you want to pay for your food',
                        options: [
                          DeliveryOptionCard(
                            title: 'Pay Online',
                            subtitle:
                                'Pay securely through card, baksh, nagad, rocket or other methods',
                            priceText: '',
                            iconPath: AppAssets.onlinePayIcon,
                            isSelected:
                                controller.selectedPaymentMethod.value == 0,
                            onTap: () => controller.selectPaymentMethod(0),
                          ),
                          DeliveryOptionCard(
                            title: controller.allPickup
                                ? 'Cash on Pickup'
                                : 'Cash on Delivery',
                            subtitle: controller.allPickup
                                ? 'Pay when you collect your order'
                                : 'Pay when you receive your order',
                            priceText: '',
                            iconPath: AppAssets.cashOnDeliveryIcon,
                            isSelected:
                                controller.selectedPaymentMethod.value == 1,
                            onTap: () => controller.selectPaymentMethod(1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const SecurePaymentBanner(),
                    ],
                  ),
                ),
              );
            }),
          ),

          // Bottom Place Order Button
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
                    child: PrimaryButton(
                      text: controller.isSubmitting.value
                          ? 'Placing Order...'
                          : 'Place Order',
                      showArrow: false,
                      trailingText: controller.formattedTotalPayable,
                      isEnabled: !controller.isSubmitting.value &&
                          controller.cartGroups.isNotEmpty,
                      onPressed: controller.onPlaceOrder,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleItemRow(String title, String priceStr) {
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
          const SizedBox(width: 8),
          Text(
            priceStr,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
