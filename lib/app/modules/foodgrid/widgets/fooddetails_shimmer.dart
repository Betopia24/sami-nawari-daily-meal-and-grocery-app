import 'package:flutter/material.dart';
import 'package:daily_meal_and_grocery_app/app/widgets/custom_shimmer.dart';

/// Full-screen shimmering skeleton for FooddetailsView during API data loading
class FooddetailsShimmer extends StatelessWidget {
  const FooddetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Image & Floating Card Stack
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover Image Shimmer
              const CustomShimmer.rectangular(
                height: 360,
                width: double.infinity,
                borderRadius: BorderRadius.zero,
              ),

              // Title and Seller Subtitle Shimmer inside image gradient area
              Positioned(
                bottom: 80,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomShimmer.rectangular(
                      width: 220,
                      height: 24,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    SizedBox(height: 8),
                    CustomShimmer.rectangular(
                      width: 130,
                      height: 14,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              ),

              // Floating Card (overhanging 55px)
              Positioned(
                bottom: -55,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Price & Rating row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomShimmer.rectangular(
                            width: 90,
                            height: 28,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              CustomShimmer.rectangular(
                                width: 50,
                                height: 16,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              SizedBox(height: 4),
                              CustomShimmer.rectangular(
                                width: 65,
                                height: 12,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Badges row with FittedBox to prevent small-screen overflow
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: const [
                            CustomShimmer.rectangular(
                              width: 70,
                              height: 28,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            SizedBox(width: 8),
                            CustomShimmer.rectangular(
                              width: 65,
                              height: 28,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            SizedBox(width: 8),
                            CustomShimmer.rectangular(
                              width: 60,
                              height: 28,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            SizedBox(width: 8),
                            CustomShimmer.rectangular(
                              width: 65,
                              height: 28,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Spacing for the 55px card overhang
          const SizedBox(height: 72),

          // Tab Bar Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F2EE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const CustomShimmer.rectangular(
                        width: 60,
                        height: 14,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const CustomShimmer.rectangular(
                        width: 75,
                        height: 14,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tab Content (Details skeleton)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "DESCRIPTION" header shimmer
                const CustomShimmer.rectangular(
                  width: 90,
                  height: 12,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                const SizedBox(height: 12),
                // Description lines shimmer
                const CustomShimmer.rectangular(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 24),

                // "Popular Dishes" header shimmer
                const CustomShimmer.rectangular(
                  width: 120,
                  height: 16,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                const SizedBox(height: 16),

                // Popular Dishes Horizontal cards shimmer
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      _buildPopularDishCardShimmer(),
                      const SizedBox(width: 12),
                      _buildPopularDishCardShimmer(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Store Info Tile Shimmer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const CustomShimmer.circular(size: 48),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            CustomShimmer.rectangular(
                              width: 120,
                              height: 14,
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            SizedBox(height: 6),
                            CustomShimmer.rectangular(
                              width: 160,
                              height: 12,
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                          ],
                        ),
                      ),
                      const CustomShimmer.rectangular(
                        width: 60,
                        height: 12,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDishCardShimmer() {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmer.card(
            height: 100,
            radius: 16,
          ),
          const SizedBox(height: 10),
          const CustomShimmer.rectangular(
            width: 110,
            height: 14,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 8),
          const CustomShimmer.rectangular(
            width: 50,
            height: 14,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for StickyCartBottomBar during API loading
class FooddetailsBottomBarShimmer extends StatelessWidget {
  const FooddetailsBottomBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Quantity selector shimmer
              CustomShimmer.card(
                width: 100,
                height: 52,
                radius: 16,
              ),
              const SizedBox(width: 16),
              // Add to cart shimmer button
              Expanded(
                child: CustomShimmer.card(
                  height: 52,
                  radius: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // View Cart shimmer button
          CustomShimmer.card(
            width: double.infinity,
            height: 52,
            radius: 16,
          ),
        ],
      ),
    );
  }
}
