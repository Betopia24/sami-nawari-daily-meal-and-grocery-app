import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/floating_seam_sliver_header.dart';
import '../../widgets/restaurant_info_card.dart';
import '../../widgets/popular_dish_horizontal_card.dart';
import '../../widgets/menu_dish_card.dart';
import '../../widgets/about_tab_widgets.dart';
import '../../widgets/review_tab_widgets.dart';
import '../../../../widgets/custom_switch_tab.dart';
import '../controllers/viewmenu_controller.dart';

class ViewmenuView extends GetView<ViewmenuController> {
  const ViewmenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = controller.restaurant;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F8),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero header with floating info card ──
              FloatingSeamSliverHeader(
                expandedHeight: 320,
                toolbarHeight: 150,
                floatingCardOverhang: 160,
                titleBottomOffset: 16,
                gradientHeight: 140,
                imagePath: r['image'] ?? 'assets/images/homelunchcardimage.png',
                titleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Open / Closed badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: (r['isOpen'] == true)
                            ? AppColors.primary
                            : const Color(0xFFFF4B4B),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            (r['isOpen'] == true) ? 'Open Now' : 'Closed',
                            style: GoogleFonts.outfit(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Restaurant name
                    Text(
                      r['name'] ?? '',
                      style: GoogleFonts.outfit(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${r['cuisine'] ?? 'Mediterranean'} · by ${r['owner'] ?? ''}',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
                floatingCard: RestaurantInfoCard(
                  ownerName: r['owner'] ?? '',
                  specialty: r['specialty'] ?? 'Mezze platters & fresh pita',
                  rating: (r['rating'] as num?)?.toDouble() ?? 4.7,
                  reviews: (r['reviews'] as num?)?.toInt() ?? 84,
                  distance: r['distance'] ?? '0.4 km',
                  prepTime: r['time'] ?? '25 min',
                  minOrder: r['minOrder'] ?? '\$12',
                  hasPickup: r['hasPickup'] ?? true,
                  hasDelivery: r['hasDelivery'] ?? true,
                ),
              ),

              // ── Spacer for overhang ──
              SliverToBoxAdapter(child: SizedBox(height: 180.h)),

              // ── Tab bar (Menu / About / Reviews) ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomSwitchTab(
                    controller: controller.tabController,
                    tabs: const ['Menu', 'About', 'Reviews'],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 24.h)),

              Obx(() {
                final tab = controller.selectedTab.value;
                if (tab == 1) {
                  return _buildAboutContent();
                } else if (tab == 2) {
                  return _buildReviewsContent();
                } else {
                  return _buildMenuContent();
                }
              }),

              // Bottom padding
              SliverToBoxAdapter(child: SizedBox(height: 40.h)),
            ],
          ),

          // ── Back button ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.textDark,
                  size: 20.sp,
                ),
              ),
            ),
          ),

          // ── Bookmark button ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                Icons.bookmark_border,
                color: AppColors.textDark,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuContent() {
    return SliverMainAxisGroup(
      slivers: [
        // ── Popular Dishes ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Popular Dishes',
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  height: 168.h,
                  child: Obx(
                    () => ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(right: 24.w),
                      itemCount: controller.popularDishes.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final dish = controller.popularDishes[index];
                        return PopularDishHorizontalCard(
                          name: dish['name'],
                          image: dish['image'],
                          price: (dish['price'] as num).toDouble(),
                          isPopular: dish['isPopular'] ?? false,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 20.h)),

        // ── Category filter chips ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(() => _buildCategoryChips()),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 20.h)),

        // ── Complete Menu title ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Complete Menu',
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 14.h)),

        // ── Menu items list ──
        Obx(
          () => SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = controller.filteredMenuItems[index];
                return MenuDishCard(
                  name: item['name'],
                  description: item['description'],
                  image: item['image'],
                  price: (item['price'] as num).toDouble(),
                  prepTime: item['prepTime'],
                  rating: (item['rating'] as num).toDouble(),
                  isPopular: item['isPopular'] ?? false,
                );
              }, childCount: controller.filteredMenuItems.length),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutContent() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final aboutData = controller.aboutData;
          if (aboutData.isEmpty) return const SizedBox();

          if (index == 0) {
            return Column(
              children: [
                ChefBioCard(
                  imagePath: aboutData['chefImage'],
                  name: aboutData['chefName'],
                  role: aboutData['chefRole'],
                  bio: aboutData['chefBio'],
                ),
                SizedBox(height: 16.h),
                WorkingHoursCard(
                  hours: Map<String, String>.from(aboutData['workingHours']),
                  isOpen: aboutData['isOpen'],
                ),
                SizedBox(height: 16.h),
                OrderingInfoCard(
                  minimumOrder: aboutData['orderingInfo']['minimumOrder'],
                  deliveryCharge: aboutData['orderingInfo']['deliveryCharge'],
                  pickupStatus: aboutData['orderingInfo']['pickupStatus'],
                  prepTime: aboutData['orderingInfo']['prepTime'],
                  distance: aboutData['orderingInfo']['distance'],
                ),
              ],
            );
          }
          return null;
        }, childCount: 1),
      ),
    );
  }

  Widget _buildReviewsContent() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final reviewsData = controller.reviewsData;
            if (reviewsData.isEmpty) return const SizedBox();

            if (index == 0) {
              return Column(
                children: [
                  ReviewSummaryCard(
                    rating: reviewsData['rating'],
                    totalReviews: reviewsData['totalReviews'],
                    ratingPercentages: Map<int, int>.from(
                      reviewsData['percentages'],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              );
            }

            final list = reviewsData['list'] as List;
            final itemIndex = index - 1;
            if (itemIndex < list.length) {
              final item = list[itemIndex];
              return ReviewItemCard(
                imagePath: item['image'],
                name: item['name'],
                timeAgo: item['timeAgo'],
                rating: item['rating'],
                text: item['text'],
              );
            }
            return null;
          },
          childCount: (controller.reviewsData.isEmpty
              ? 0
              : 1 + (controller.reviewsData['list'] as List).length),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: List.generate(controller.categories.length, (index) {
        final isSelected = controller.selectedCategory.value == index;
        return GestureDetector(
          onTap: () => controller.setCategory(index),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
              ),
            ),
            child: Text(
              controller.categories[index],
              style: GoogleFonts.outfit(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        );
      }),
    );
  }
}
