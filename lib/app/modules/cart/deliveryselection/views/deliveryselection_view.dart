import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../widgets/delivery_method_selector.dart';
import '../../widgets/delivery_option_card.dart';
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
            child: Obx(
              () => ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Restaurant 1: Maria's Kitchen
                  ReviewRestaurantCard(
                    restaurantImage: AppAssets.homeRecipeCardImage1,
                    restaurantName: "Maria's Kitchen",
                    authorName: "Maria Santos",
                    timeText: '25 min',
                    totalPrice: 18.00,
                    items: [
                      _buildSimpleItemRow('1x Classic Mezze Platter', 18.00),
                      DeliveryMethodSelector(
                        options: [
                          DeliveryOptionCard(
                            title: 'Pickup',
                            subtitle: 'Collect from the kitchen',
                            priceText: 'Free',
                            iconPath: AppAssets.pickupIcon,
                            isSelected: controller.selectedMethods[0] == 0,
                            onTap: () => controller.selectMethod(0, 0),
                          ),
                          DeliveryOptionCard(
                            title: 'Delivery \$2.50',
                            subtitle: 'Delivered by Maria Santos',
                            priceText: '\$2.50',
                            iconPath: AppAssets.deliveryIcon,
                            isSelected: controller.selectedMethods[0] == 1,
                            onTap: () => controller.selectMethod(0, 1),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Restaurant 2: Luca's Pasta Club
                  ReviewRestaurantCard(
                    restaurantImage: AppAssets.homeRecipeCardImage2,
                    restaurantName: "Luca's Pasta Club",
                    authorName: "Luca Buanchi",
                    timeText: '20 min',
                    totalPrice: 27.00,
                    items: [
                      _buildSimpleItemRow('1x Cacio e Pepe', 13.00),
                      _buildSimpleItemRow('2x Tirasamu', 14.00),
                      DeliveryMethodSelector(
                        noticeText: 'This kitchen offers pickup only',
                        options: [
                          DeliveryOptionCard(
                            title: 'Pickup',
                            subtitle: 'Collect from the kitchen',
                            priceText: 'Free',
                            iconPath: AppAssets.pickupIcon,
                            isSelected: controller.selectedMethods[1] == 0, // Always selected
                            onTap: () {}, // No op
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Restaurant 3: Priya's Spice House
                  ReviewRestaurantCard(
                    restaurantImage: AppAssets.homeRecipeCardImage3,
                    restaurantName: "Priya's Spice House",
                    authorName: "Priya Sharma",
                    timeText: '40 min',
                    totalPrice: 32.00,
                    items: [
                      _buildSimpleItemRow('2x Chiken Biriyani', 32.00),
                      DeliveryMethodSelector(
                        options: [
                          DeliveryOptionCard(
                            title: 'Pickup',
                            subtitle: 'Collect from the kitchen',
                            priceText: 'Free',
                            iconPath: AppAssets.pickupIcon,
                            isSelected: controller.selectedMethods[2] == 0,
                            onTap: () => controller.selectMethod(2, 0),
                          ),
                          DeliveryOptionCard(
                            title: 'Delivery \$3.00',
                            subtitle: 'Delivered by Priya Sharma',
                            priceText: '\$3.00',
                            iconPath: AppAssets.deliveryIcon,
                            isSelected: controller.selectedMethods[2] == 1,
                            onTap: () => controller.selectMethod(2, 1),
                          ),
                        ],
                      ),
                    ],
                  ),
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
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
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
