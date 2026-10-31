import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/utils/app_colors.dart';
import '../controllers/exploreboard_controller.dart';

/// Real Google Map view for Explore screen with custom Current Location button
class ExploreMapView extends GetView<ExploreboardController> {
  const ExploreMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5E8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EBE5), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // 1. Interactive Google Map with Eager gesture handling for smooth pan/zoom
            Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.initialPosition.value,
                  zoom: 14.5,
                ),
                onMapCreated: controller.onMapCreated,
                markers: controller.markers.toSet(),
                myLocationEnabled: true,
                myLocationButtonEnabled: false, // We use custom styled button
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
              ),
            ),

            // 2. Placeholder while map engine initializes
            Obx(
              () => controller.isMapReady.value
                  ? const SizedBox.shrink()
                  : Container(
                      color: const Color(0xFFF1F5E8),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Loading map...',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            // 3. Floating Nearby Kitchens Badge
            Positioned(
              top: 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFE2EBE5),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Obx(
                      () => Text(
                        '${controller.restaurants.length} Kitchens Nearby',
                        style: GoogleFonts.outfit(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. Floating Current Location Button
            Positioned(
              bottom: 12.h,
              right: 12.w,
              child: Obx(
                () => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: controller.isGettingLocation.value
                        ? null
                        : controller.getCurrentLocation,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFE2EBE5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: controller.isGettingLocation.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              )
                            : Icon(
                                Icons.my_location,
                                color: AppColors.primary,
                                size: 22.sp,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
