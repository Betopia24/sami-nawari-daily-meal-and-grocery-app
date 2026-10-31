import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/primary_button.dart';
import '../../widgets/order_placed_animation.dart';
import '../../widgets/order_placed_summary_card.dart';
import '../controllers/orderplaced_controller.dart';

class OrderplacedView extends GetView<OrderplacedController> {
  const OrderplacedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Slightly off-white background matching design
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // 1. Animation or Status Badge based on isSuccess
                    Obx(() {
                      if (controller.isSuccess.value) {
                        return const OrderPlacedAnimation();
                      } else {
                        return Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFF59E0B),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFD97706),
                            size: 44,
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 32),
                    
                    // 2. Status Texts
                    Obx(
                      () => Text(
                        controller.isSuccess.value
                            ? 'Order Placed!'
                            : 'Payment Incomplete',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: controller.isSuccess.value
                              ? AppColors.textPrimary
                              : const Color(0xFFD97706),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Text(
                        controller.isSuccess.value
                            ? 'Your order has been sent to the sellers.\nYou will receive a confirmation shortly.'
                            : 'Your order was created, but the payment was not completed.\nPlease retry payment to confirm your order.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // 3. The Order Summary Card
                    Obx(
                      () => OrderPlacedSummaryCard(
                        restaurantName: controller.restaurantName.value,
                        restaurantImage: controller.restaurantImage.value,
                        itemsCountText: controller.itemsCountText.value,
                        priceText: controller.priceText.value,
                        paymentMethodTitle: controller.paymentMethodTitle.value,
                        paymentMethodSubtitle:
                            controller.paymentMethodSubtitle.value,
                      ),
                    ),

                    // 4. Retry Payment CTA if payment failed or cancelled
                    Obx(() {
                      if (!controller.isSuccess.value && controller.isOnline.value) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF635BFF), // Stripe brand purple
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                              icon: controller.isRetrying.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.refresh_rounded, size: 20),
                              label: Text(
                                controller.isRetrying.value
                                    ? 'Generating Payment Link...'
                                    : 'Retry Payment (Stripe)',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: controller.isRetrying.value
                                  ? null
                                  : controller.retryPayment,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
            
            // 4. Bottom Buttons
            Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
              color: const Color(0xFFFAFAFA),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Track My Order',
                    showArrow: false,
                    onPressed: controller.onTrackMyOrder,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Back to Cart',
                    showArrow: false,
                    backgroundColor: const Color(0xFFF2EFE8), // Light beige/grey background
                    textColor: AppColors.textSecondary,
                    onPressed: controller.onBackToCart,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
