import 'package:flutter/material.dart';
import '../../../widgets/custom_shimmer.dart';

/// Shimmer skeleton for 2-column food grid views (such as RecommendedfoodView) during API data loading
class FoodGridShimmer extends StatelessWidget {
  final int itemCount;

  const FoodGridShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth = (constraints.maxWidth - 16) / 2;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(itemCount, (index) {
              return SizedBox(
                width: itemWidth,
                child: _buildCardShimmer(),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildCardShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image cover shimmer
          const CustomShimmer.rectangular(
            height: 120,
            width: double.infinity,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag pill shimmer
                const CustomShimmer.rectangular(
                  width: 80,
                  height: 18,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                const SizedBox(height: 8),

                // Title shimmer
                const CustomShimmer.rectangular(
                  width: 120,
                  height: 16,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                const SizedBox(height: 12),

                // Meta row (time, calories, rating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CustomShimmer.rectangular(
                      width: 40,
                      height: 12,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    CustomShimmer.rectangular(
                      width: 44,
                      height: 12,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    CustomShimmer.rectangular(
                      width: 28,
                      height: 12,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
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
