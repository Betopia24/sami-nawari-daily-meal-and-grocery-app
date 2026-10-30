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
      appBar: const ProfileAppBar(
        title: 'Favorite Sellers',
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
              () {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (controller.favoriteSellers.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.fetchFavoriteSellers,
                    color: AppColors.primary,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 120),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.storefront_outlined,
                                size: 56,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No favorite sellers yet',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Bookmark sellers in Explore to see them here',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchFavoriteSellers,
                  color: AppColors.primary,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                        isBookmarked: true,
                        onBookmarkTap: () {
                          controller.toggleFavoriteSeller(index);
                        },
                        onViewMenuTap: () {
                          controller.viewSellerMenu(seller);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
