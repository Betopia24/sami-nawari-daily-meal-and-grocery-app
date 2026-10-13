import 'package:daily_meal_and_grocery_app/app/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../widgets/review_item_card.dart';
import '../../widgets/review_restaurant_card.dart';
import '../../widgets/step_indicator.dart';
import '../controllers/revieworder_controller.dart';

class RevieworderView extends GetView<RevieworderController> {
  const RevieworderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .white, // assuming slightly off-white or white. Figma looks like white or very light gray. Let's use Color(0xFFFAFAFA) matching the overall app background.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 24, top: 8, bottom: 8),
          child: CustomBackButton(),
        ),
        title: Text(
          'Review Order',
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
          const StepIndicator(currentStep: 0),
          // A divider under the steps
          const Divider(height: 1, thickness: 1, color: AppColors.borderGrey),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ReviewRestaurantCard(
                  restaurantImage: AppAssets.homeRecipeCardImage1,
                  restaurantName: "Maria's Kitchen",
                  authorName: "Maria Santos",
                  timeText: '25 min',
                  totalPrice: 18.00,
                  items: [
                    ReviewItemCard(
                      imagePath: AppAssets.homeRecipeCardImage1,
                      title: "Classic Mezze Platter",
                      quantityText: "1x",
                      totalPrice: 18.00,
                    ),
                  ],
                ),
                ReviewRestaurantCard(
                  restaurantImage: AppAssets.homeRecipeCardImage2,
                  restaurantName: "Luca's Pasta Club",
                  authorName: "Luca Buanchi",
                  timeText: '20 min',
                  totalPrice: 27.00,
                  items: [
                    ReviewItemCard(
                      imagePath: AppAssets.homeRecipeCardImage2,
                      title: "Cacio e Pepe",
                      quantityText: "1x",
                      totalPrice: 13.00,
                    ),
                    ReviewItemCard(
                      imagePath: AppAssets.homeRecipeCardImage2,
                      title: "Tirasamu",
                      quantityText: "2x",
                      totalPrice: 14.00,
                    ),
                  ],
                ),
                ReviewRestaurantCard(
                  restaurantImage: AppAssets.homeRecipeCardImage3,
                  restaurantName: "Priya's Spice House",
                  authorName: "Priya Sharma",
                  timeText: '40 min',
                  totalPrice: 32.00,
                  items: [
                    ReviewItemCard(
                      imagePath: AppAssets.homeRecipeCardImage3,
                      title: "Chiken Biriyani",
                      quantityText: "1x",
                      totalPrice: 32.00,
                    ),
                  ],
                ),
              ],
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
              color: Colors.white, // Assuming white bg behind button
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
}
