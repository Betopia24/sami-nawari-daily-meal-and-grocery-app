import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';
import '../exploreboard/controllers/exploreboard_controller.dart';

class RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final bool? isBookmarked;
  final VoidCallback? onBookmarkTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.isBookmarked,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: _buildImage(restaurant['image']),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: _buildStatusBadge(restaurant['isOpen'] == true),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  restaurant['name'],
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2.h),

                // Owner
                Text(
                  restaurant['owner'],
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 6.h),

                // Rating and Distance
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: const Color(0xFFF5A623),
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${restaurant['rating']} ',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF5A623),
                      ),
                    ),
                    Text(
                      '(${restaurant['reviews']})',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '•  ${restaurant['distance']}',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Time & Delivery Fee Chips
                Row(
                  children: [
                    _buildGreyChip(restaurant['time']),
                    SizedBox(width: 8.w),
                    _buildGreyChip(restaurant['deliveryFee']),
                  ],
                ),
                SizedBox(height: 8.h),

                // Order Options
                Row(
                  children: [
                    if (restaurant['hasPickup'] == true)
                      _buildServiceChip('Pickup', true),
                    if (restaurant['hasPickup'] == true &&
                        restaurant['hasDelivery'] == true)
                      SizedBox(width: 8.w),
                    if (restaurant['hasDelivery'] == true)
                      _buildServiceChip('Delivery', false),
                  ],
                ),
                SizedBox(height: 12.h),

                // Description
                Text(
                  restaurant['description'],
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),

                // Footer (Bookmark & View Menu)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) {
                        final exploreCtrl = Get.isRegistered<ExploreboardController>()
                            ? Get.find<ExploreboardController>()
                            : null;
                        final String sellerId = (restaurant['sellerId'] ??
                                restaurant['id'] ??
                                restaurant['_id'] ??
                                restaurant['userId'] ??
                                '')
                            .toString();
                        final String sellerName =
                            restaurant['name']?.toString() ?? 'Seller';
                        final bool bookmarked = isBookmarked ??
                            (exploreCtrl != null &&
                                exploreCtrl.bookmarkedSellerIds.contains(sellerId));

                        return GestureDetector(
                          onTap: onBookmarkTap ??
                              () {
                                if (exploreCtrl != null) {
                                  exploreCtrl.toggleSellerBookmark(
                                    sellerId,
                                    sellerName: sellerName,
                                  );
                                }
                              },
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            child: Icon(
                              bookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: bookmarked
                                  ? AppColors.primary
                                  : AppColors.textDark,
                              size: 24.sp,
                            ),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.viewmenu, arguments: restaurant);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'View Menu',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildStatusBadge(bool isOpen) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: isOpen ? AppColors.primary : const Color(0xFFFF4B4B),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            isOpen ? 'Open' : 'Closed',
            style: GoogleFonts.outfit(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: isOpen ? AppColors.primary : const Color(0xFFFF4B4B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreyChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildServiceChip(String type, bool isPickup) {
    final color = isPickup ? AppColors.primary : const Color(0xFFF5A623);
    final bgColor = isPickup
        ? const Color(0xFFF4F9F6)
        : const Color(0xFFFFF7ED);
    final icon = isPickup ? Icons.inventory_2_outlined : Icons.moped_outlined;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            type,
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(dynamic imagePath) {
    final String path = imagePath?.toString() ?? '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        height: 140.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Image.asset(
          'assets/images/homelunchcardimage.png',
          height: 140.h,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      path.isNotEmpty ? path : 'assets/images/homelunchcardimage.png',
      height: 140.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Image.asset(
        'assets/images/homelunchcardimage.png',
        height: 140.h,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
