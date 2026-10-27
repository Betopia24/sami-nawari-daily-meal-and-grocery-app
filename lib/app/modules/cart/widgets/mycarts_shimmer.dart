import 'package:flutter/material.dart';
import 'package:daily_meal_and_grocery_app/app/widgets/custom_shimmer.dart';
import '../../../../core/utils/app_colors.dart';

/// Full-screen shimmering skeleton for the Cart tab in MycartsView
class MyCartsShimmer extends StatelessWidget {
  const MyCartsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        _buildRestaurantCardShimmer(itemCount: 1),
        _buildRestaurantCardShimmer(itemCount: 1),
      ],
    );
  }

  Widget _buildRestaurantCardShimmer({int itemCount = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Restaurant Info Shimmer
          Row(
            children: [
              const CustomShimmer.circular(size: 44),
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
                    SizedBox(height: 4),
                    CustomShimmer.rectangular(
                      width: 90,
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

          // Badges / Tags Shimmer
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              CustomShimmer.rectangular(
                width: 65,
                height: 28,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              CustomShimmer.rectangular(
                width: 60,
                height: 28,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              CustomShimmer.rectangular(
                width: 90,
                height: 28,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Cart Items Shimmer
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EFE8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Food Image Shimmer
          CustomShimmer.card(
            width: 72,
            height: 72,
            radius: 14,
          ),
          const SizedBox(width: 16),
          // Food Details Shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomShimmer.rectangular(
                  width: 120,
                  height: 16,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                const SizedBox(height: 4),
                const CustomShimmer.rectangular(
                  width: 65,
                  height: 12,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Stepper shimmer
                    CustomShimmer.card(
                      width: 80,
                      height: 30,
                      radius: 15,
                    ),
                    const SizedBox(width: 12),
                    // Item total shimmer
                    const CustomShimmer.rectangular(
                      width: 50,
                      height: 16,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    const Spacer(),
                    // Bookmark icon placeholder
                    const CustomShimmer.circular(size: 28),
                    const SizedBox(width: 8),
                    // Delete icon placeholder
                    const CustomShimmer.circular(size: 28),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for the floating CheckoutBottomBar in MycartsView
class CheckoutBottomBarShimmer extends StatelessWidget {
  const CheckoutBottomBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              CustomShimmer.rectangular(
                width: 100,
                height: 12,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              SizedBox(height: 6),
              CustomShimmer.rectangular(
                width: 75,
                height: 22,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          CustomShimmer.card(
            width: 130,
            height: 48,
            radius: 16,
          ),
        ],
      ),
    );
  }
}

/// Shimmer for the Active Orders tab
class ActiveOrdersShimmer extends StatelessWidget {
  const ActiveOrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Column(
        children: [
          // Order Card Shimmer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CustomShimmer.circular(size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          CustomShimmer.rectangular(
                            width: 130,
                            height: 18,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          SizedBox(height: 4),
                          CustomShimmer.rectangular(
                            width: 80,
                            height: 12,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ],
                      ),
                    ),
                    const CustomShimmer.rectangular(
                      width: 60,
                      height: 18,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const CustomShimmer.rectangular(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                const SizedBox(height: 8),
                const CustomShimmer.rectangular(
                  width: 200,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Timeline Card Shimmer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: const [
                      CustomShimmer.circular(size: 20),
                      SizedBox(width: 12),
                      CustomShimmer.rectangular(
                        width: 100,
                        height: 14,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      Spacer(),
                      CustomShimmer.rectangular(
                        width: 60,
                        height: 12,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ],
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
