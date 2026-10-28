import 'package:flutter/material.dart';
import 'package:daily_meal_and_grocery_app/app/widgets/custom_shimmer.dart';
import '../../../../core/utils/app_colors.dart';

/// Shimmer loading skeleton for RevieworderView during API loading
class ReviewOrderShimmer extends StatelessWidget {
  const ReviewOrderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        _buildRestaurantCardShimmer(itemCount: 1),
        _buildRestaurantCardShimmer(itemCount: 2),
      ],
    );
  }

  Widget _buildRestaurantCardShimmer({required int itemCount}) {
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
          const SizedBox(height: 20),

          // Items inside restaurant
          ...List.generate(
            itemCount,
            (index) => _buildItemCardShimmer(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCardShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EFE8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          CustomShimmer.card(
            width: 72,
            height: 72,
            radius: 16,
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CustomShimmer.rectangular(
                  width: 130,
                  height: 16,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                SizedBox(height: 6),
                CustomShimmer.rectangular(
                  width: 40,
                  height: 12,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          // Price
          const CustomShimmer.rectangular(
            width: 50,
            height: 16,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}
