import 'package:daily_meal_and_grocery_app/app/widgets/custom_back_button.dart';
import 'package:daily_meal_and_grocery_app/app/widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../widgets/review_item_card.dart';
import '../../widgets/review_order_shimmer.dart';
import '../../widgets/review_restaurant_card.dart';
import '../../widgets/step_indicator.dart';
import '../controllers/revieworder_controller.dart';

class RevieworderView extends GetView<RevieworderController> {
  const RevieworderView({super.key});

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
            child: Obx(() {
              if (controller.isLoading.value) {
                return const ReviewOrderShimmer();
              }

              if (controller.cartGroups.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No items to review',
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
                    return ReviewRestaurantCard(
                      restaurantImage: group.restaurantImage,
                      restaurantName: group.sellerName,
                      authorName: group.authorName,
                      timeText: group.prepTime,
                      totalPrice: group.totalPrice,
                      items: group.items.map((item) {
                        return ReviewItemCard(
                          imagePath: item.image,
                          title: item.name,
                          quantityText: '${item.quantity}x',
                          totalPrice: item.price * item.quantity,
                        );
                      }).toList(),
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
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
}
