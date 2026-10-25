import 'package:flutter/material.dart';
import 'package:daily_meal_and_grocery_app/app/widgets/custom_shimmer.dart';

/// Shimmer loading placeholder for recipe list screens
class RecipeListShimmer extends StatelessWidget {
  const RecipeListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              // Left Image Shimmer
              const ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: CustomShimmer.rectangular(
                  width: 120,
                  height: 120,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Right Content Shimmer
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tag pill shimmer
                      Row(
                        children: const [
                          CustomShimmer.rectangular(
                            width: 65,
                            height: 16,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          SizedBox(width: 6),
                          CustomShimmer.rectangular(
                            width: 55,
                            height: 16,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Title line
                      const CustomShimmer.rectangular(
                        width: 160,
                        height: 16,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      const SizedBox(height: 10),
                      // Meta line (time, kcal, rating)
                      Row(
                        children: const [
                          CustomShimmer.rectangular(width: 45, height: 12),
                          SizedBox(width: 8),
                          CustomShimmer.rectangular(width: 50, height: 12),
                          SizedBox(width: 8),
                          CustomShimmer.rectangular(width: 35, height: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
