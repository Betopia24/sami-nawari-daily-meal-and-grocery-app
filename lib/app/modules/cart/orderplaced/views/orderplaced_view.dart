import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
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
                    // 1. The Smooth Animation Widget
                    const OrderPlacedAnimation(),
                    const SizedBox(height: 40),
                    
                    // 2. Success Texts
                    Text(
                      'Order Placed!',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your order has been sent to the sellers.\nYou will receive a confirmation shortly.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // 3. The Order Summary Card
                    const OrderPlacedSummaryCard(
                      restaurantName: "Maria's Kitchen",
                      restaurantImage: AppAssets.homeRecipeCardImage1,
                      itemsCountText: '1 item',
                      priceText: '\$23.00',
                      paymentMethodTitle: 'Payment Method',
                      paymentMethodSubtitle: 'Cash on Delivery',
                    ),
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
