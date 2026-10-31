import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../widgets/restaurant_card.dart';
import '../../widgets/explore_sellers_shimmer.dart';
import '../controllers/exploreboard_controller.dart';
import '../widgets/explore_map_view.dart';

class ExploreboardView extends GetView<ExploreboardController> {
  const ExploreboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore',
                        style: GoogleFonts.outfit(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Discover food near you',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.mycarts);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFE2EBE5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.cartIcon,
                            width: 20.w,
                            height: 20.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Cart',
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.fetchNearbySellers,
                  color: AppColors.primary,
                  child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search and Filter row
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller.searchController,
                                  onChanged: controller.onSearchChanged,
                                  decoration: InputDecoration(
                                    hintText: 'Search restaurants, cuisines...',
                                    hintStyle: GoogleFonts.outfit(
                                      color: AppColors.textSecondary,
                                      fontSize: 14.sp,
                                    ),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: SvgPicture.asset(
                                        AppAssets.searchIcon,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.textSecondary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    suffixIcon: controller.searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              size: 18,
                                              color: AppColors.textSecondary,
                                            ),
                                            onPressed: controller.clearSearch,
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE2EBE5),
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE2EBE5),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 10.h,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              InkWell(
                                onTap: controller.openFilterBottomSheet,
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.tune,
                                        color: Colors.white,
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Obx(() {
                                        final count = controller.activeFilterCount;
                                        return Text(
                                          count > 0 ? 'Filter ($count)' : 'Filter',
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Active Filters Row
                          Obx(() {
                            final count = controller.activeFilterCount;
                            if (count == 0) return const SizedBox.shrink();

                            return Padding(
                              padding: EdgeInsets.only(top: 12.h),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if (controller.selectedCuisine.value.isNotEmpty)
                                      _buildActiveChip(
                                        label: controller.selectedCuisine.value.capitalizeFirst ??
                                            controller.selectedCuisine.value,
                                        onDeleted: () {
                                          controller.selectedCuisine.value = '';
                                          controller.fetchNearbySellers();
                                        },
                                      ),
                                    if (controller.filterDeliveryAvailable.value)
                                      _buildActiveChip(
                                        label: 'Delivery',
                                        onDeleted: () {
                                          controller.filterDeliveryAvailable.value = false;
                                          controller.fetchNearbySellers();
                                        },
                                      ),
                                    if (controller.filterPickupAvailable.value)
                                      _buildActiveChip(
                                        label: 'Pickup',
                                        onDeleted: () {
                                          controller.filterPickupAvailable.value = false;
                                          controller.fetchNearbySellers();
                                        },
                                      ),
                                    if (controller.filterByLocation.value)
                                      _buildActiveChip(
                                        label: '${controller.filterRadius.value.toInt()} km Radius',
                                        onDeleted: () {
                                          controller.filterByLocation.value = false;
                                          controller.fetchNearbySellers();
                                        },
                                      ),
                                    InkWell(
                                      onTap: controller.resetFilters,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                        child: Text(
                                          'Clear all',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          SizedBox(height: 20.h),

                          // Google Map with interactive markers and Current Location button
                          const ExploreMapView(),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),

                    // List of Restaurant Cards (Live API data)
                    Obx(() {
                      if (controller.isLoadingSellers.value) {
                        return const ExploreSellersShimmer();
                      }

                      if (controller.restaurants.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.storefront_outlined,
                                    size: 48.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'No kitchens found nearby',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final restaurant = controller.restaurants[index];
                          final String sId = (restaurant['sellerId'] ??
                                  restaurant['id'] ??
                                  restaurant['_id'] ??
                                  restaurant['userId'] ??
                                  '')
                              .toString();
                          final bool isBookmarked =
                              controller.bookmarkedSellerIds.contains(sId);

                          return RestaurantCard(
                            restaurant: restaurant,
                            isBookmarked: isBookmarked,
                            onBookmarkTap: () => controller.toggleSellerBookmark(
                              sId,
                              sellerName: restaurant['name']?.toString(),
                            ),
                          );
                        }, childCount: controller.restaurants.length),
                      );
                    }),

                    SliverToBoxAdapter(
                      child: SizedBox(height: 100.h),
                    ), // Bottom padding for navbar
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 4.w),
          InkWell(
            onTap: onDeleted,
            child: Icon(
              Icons.close,
              size: 14.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
