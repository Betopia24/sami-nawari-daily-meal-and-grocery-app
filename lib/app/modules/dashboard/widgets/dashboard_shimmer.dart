import 'package:flutter/material.dart';
import 'package:daily_meal_and_grocery_app/app/widgets/custom_shimmer.dart';

/// Full-screen shimmering skeleton for DashboardView during data loading
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Header Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomShimmer.rectangular(
                      width: 90,
                      height: 12,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    SizedBox(height: 8),
                    CustomShimmer.rectangular(
                      width: 160,
                      height: 22,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ],
                ),
                const CustomShimmer.circular(size: 40),
              ],
            ),
          ),

          // Location Bar Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
            child: Row(
              children: const [
                CustomShimmer.circular(size: 16),
                SizedBox(width: 8),
                CustomShimmer.rectangular(
                  width: 140,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Search Bar Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CustomShimmer.card(
              height: 52,
              radius: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Category Section Header Shimmer
          _buildShimmerSectionHeader(titleWidth: 200, subtitleWidth: 240),
          const SizedBox(height: 12),

          // 4 Category Cards Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 3 ? 8.0 : 0),
                    child: CustomShimmer.card(
                      height: 85,
                      radius: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Meal Plan Banner Shimmer
          _buildShimmerSectionHeader(titleWidth: 160, subtitleWidth: 210),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CustomShimmer.card(
              height: 120,
              radius: 20,
            ),
          ),
          const SizedBox(height: 24),

          // Recommended Food Shimmer
          _buildShimmerSectionHeader(
            titleWidth: 180,
            subtitleWidth: 250,
            hasAction: true,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer.card(
                        height: 120,
                        radius: 20,
                      ),
                      const SizedBox(height: 12),
                      const CustomShimmer.rectangular(
                        width: 70,
                        height: 14,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      const SizedBox(height: 8),
                      const CustomShimmer.rectangular(
                        width: 160,
                        height: 18,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          CustomShimmer.rectangular(
                            width: 45,
                            height: 12,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          SizedBox(width: 12),
                          CustomShimmer.rectangular(
                            width: 55,
                            height: 12,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          SizedBox(width: 12),
                          CustomShimmer.rectangular(
                            width: 35,
                            height: 12,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Shared Grocery Shimmer
          _buildShimmerSectionHeader(titleWidth: 130, hasAction: true),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CustomShimmer.card(
              height: 110,
              radius: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Homemade Food Shimmer
          _buildShimmerSectionHeader(
            titleWidth: 210,
            subtitleWidth: 230,
            hasAction: true,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 330,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  width: 260,
                  margin: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer.card(
                        height: 140,
                        radius: 20,
                      ),
                      const SizedBox(height: 12),
                      const CustomShimmer.rectangular(
                        width: 180,
                        height: 18,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      const SizedBox(height: 6),
                      const CustomShimmer.rectangular(
                        width: 120,
                        height: 14,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      const SizedBox(height: 12),
                      const CustomShimmer.rectangular(
                        width: 100,
                        height: 14,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSectionHeader({
    required double titleWidth,
    double? subtitleWidth,
    bool hasAction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmer.rectangular(
                width: titleWidth,
                height: 18,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              if (subtitleWidth != null) ...[
                const SizedBox(height: 6),
                CustomShimmer.rectangular(
                  width: subtitleWidth,
                  height: 12,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ],
          ),
          if (hasAction)
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
