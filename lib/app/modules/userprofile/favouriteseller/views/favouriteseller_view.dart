import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../widgets/profile_app_bar.dart';
import '../../widgets/seller_card.dart';
import '../controllers/favouriteseller_controller.dart';

class FavouritesellerView extends GetView<FavouritesellerController> {
  const FavouritesellerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: ProfileAppBar(
        title: 'Favorite Sellers',
        // Optional action or subtitle can be added here if ProfileAppBar supported it,
        // but for now, we'll put the subtitle below the app bar.
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Obx(
              () => Text(
                '${controller.favoriteSellers.length} saved',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                itemCount: controller.favoriteSellers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final seller = controller.favoriteSellers[index];
                  return SellerCard(
                    imagePath: seller.imagePath,
                    isOpen: seller.isOpen,
                    title: seller.title,
                    ownerName: seller.ownerName,
                    rating: seller.rating,
                    reviewCount: seller.reviewCount,
                    distance: seller.distance,
                    tags: seller.tags,
                    hasPickup: seller.hasPickup,
                    hasDelivery: seller.hasDelivery,
                    description: seller.description,
                    onBookmarkTap: () {
                      controller.unsaveSeller(index);
                    },
                    onViewMenuTap: () {
                      // Navigate to seller menu
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
