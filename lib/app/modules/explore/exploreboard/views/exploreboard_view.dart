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
                              Container(
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
                                    Text(
                                      'Filter',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

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
                          return RestaurantCard(restaurant: restaurant);
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
}
