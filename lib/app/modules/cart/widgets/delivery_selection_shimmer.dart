import 'package:flutter/material.dart';
import 'package:daily_meal_and_grocery_app/app/widgets/custom_shimmer.dart';
import '../../../../core/utils/app_colors.dart';

/// Shimmer skeleton for DeliveryselectionView during API data loading
class DeliverySelectionShimmer extends StatelessWidget {
  const DeliverySelectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        _buildRestaurantDeliveryShimmer(itemCount: 1),
        _buildRestaurantDeliveryShimmer(itemCount: 2),
      ],
    );
  }

  Widget _buildRestaurantDeliveryShimmer({required int itemCount}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Restaurant Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomShimmer.circular(size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomShimmer.rectangular(
                      width: 140,
                      height: 18,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    SizedBox(height: 6),
                    CustomShimmer.rectangular(
                      width: 150,
                      height: 12,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              ),
              const CustomShimmer.rectangular(
                width: 60,
                height: 20,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Simple item rows
          ...List.generate(
            itemCount,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomShimmer.rectangular(
                    width: 150,
                    height: 14,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  CustomShimmer.rectangular(
                    width: 50,
                    height: 14,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Delivery Method section title
          const CustomShimmer.rectangular(
            width: 120,
            height: 16,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 6),
          const CustomShimmer.rectangular(
            width: 200,
            height: 12,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 16),

          // Delivery Option Card 1 (Pickup)
          CustomShimmer.card(
            height: 72,
            radius: 16,
          ),
          const SizedBox(height: 12),

          // Delivery Option Card 2 (Delivery)
          CustomShimmer.card(
            height: 72,
            radius: 16,
          ),
        ],
      ),
    );
  }
}
