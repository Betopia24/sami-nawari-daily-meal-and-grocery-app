import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';

/// Floating info card displayed on the restaurant view menu page.
/// Shows owner avatar, name, specialty, rating, stats (distance, prep time,
/// min order), and service options (Pickup / Delivery).
class RestaurantInfoCard extends StatelessWidget {
  final String ownerName;
  final String specialty;
  final String? ownerImage;
  final double rating;
  final int reviews;
  final String distance;
  final String prepTime;
  final String minOrder;
  final bool hasPickup;
  final bool hasDelivery;

  const RestaurantInfoCard({
    super.key,
    required this.ownerName,
    required this.specialty,
    this.ownerImage,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.prepTime,
    required this.minOrder,
    this.hasPickup = true,
    this.hasDelivery = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Owner row
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: ownerImage != null
                    ? AssetImage(ownerImage!)
                    : null,
                child: ownerImage == null
                    ? Text(
                        ownerName.isNotEmpty ? ownerName[0] : '?',
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              // Name + specialty
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ownerName,
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      specialty,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xFFF5A623),
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        rating.toString(),
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$reviews reviews',
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Stats row
          Row(
            children: [
              _buildStatChip(
                icon: Icons.place_outlined,
                iconColor: const Color(0xFFFF6B6B),
                value: distance,
                label: 'away',
              ),
              SizedBox(width: 8.w),
              _buildStatChip(
                icon: Icons.access_time_outlined,
                iconColor: AppColors.textSecondary,
                value: prepTime,
                label: 'prep time',
              ),
              SizedBox(width: 8.w),
              _buildStatChip(
                icon: Icons.attach_money,
                iconColor: const Color(0xFFF5A623),
                value: minOrder,
                label: 'min order',
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Service chips
          Row(
            children: [
              if (hasPickup) _buildServiceChip('Pickup', true),
              if (hasPickup && hasDelivery) SizedBox(width: 10.w),
              if (hasDelivery) _buildServiceChip('Delivery', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F6),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 18.sp),
            SizedBox(height: 4.h),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            type,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
