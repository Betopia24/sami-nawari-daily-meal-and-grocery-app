import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/primary_button.dart';
import '../../widgets/delivery_method_selector.dart';
import '../../widgets/delivery_option_card.dart';
import '../../widgets/order_summary_card.dart';
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OrderSummaryCard(
                    restaurantImage: AppAssets.homeRecipeCardImage1,
                    restaurantName: "Maria's Kitchen",
                    statusTag: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED), // Light orange
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFEDD5),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.deliveryIcon,
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFEA580C),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Delivery',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFEA580C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    items: [
                      _buildSimpleItemRow('1x Classic Mezze Platter', '\$18.00'),
                      _buildSimpleItemRow('Delivery Charge', '+\$2.50'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Payment Summary',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const PaymentSummaryCard(
                    itemsSubtotal: 18.00,
                    deliveryFee: 2.50,
                    platformFee: 0.00,
                  ),
                  
                  const SizedBox(height: 24),
                  // We reuse DeliveryMethodSelector for "Payment Method" as well!
                  Obx(
                    () => DeliveryMethodSelector(
                      options: [
                        DeliveryOptionCard(
                          title: 'Pay Online',
                          subtitle: 'Pay securely through card, baksh, nagad, rocket or other methods',
                          priceText: '',
                          iconPath: AppAssets.onlinePayIcon,
                          isSelected: controller.selectedPaymentMethod.value == 0,
                          onTap: () => controller.selectPaymentMethod(0),
                        ),
                        DeliveryOptionCard(
                          title: 'Cash on Delivery',
                          subtitle: 'Pay when you collect your order',
                          priceText: '\$2.50',
                          iconPath: AppAssets.cashOnDeliveryIcon,
                          isSelected: controller.selectedPaymentMethod.value == 1,
                          onTap: () => controller.selectPaymentMethod(1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SecurePaymentBanner(),
                ],
              ),
            ),
          ),
          // Bottom Continue Button
          Container(
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
              text: 'Place Order',
              showArrow: false,
              trailingText: '\$20.50',
              onPressed: controller.onPlaceOrder,
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
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
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
