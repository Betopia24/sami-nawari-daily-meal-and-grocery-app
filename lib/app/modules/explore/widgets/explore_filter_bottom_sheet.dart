import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../widgets/primary_button.dart';
import '../exploreboard/controllers/exploreboard_controller.dart';

class ExploreFilterBottomSheet extends StatefulWidget {
  const ExploreFilterBottomSheet({super.key});

  @override
  State<ExploreFilterBottomSheet> createState() =>
      _ExploreFilterBottomSheetState();
}

class _ExploreFilterBottomSheetState extends State<ExploreFilterBottomSheet> {
  final ExploreboardController controller = Get.find<ExploreboardController>();

  late String _selectedCuisine;
  late bool _deliveryAvailable;
  late bool _pickupAvailable;
  late double _radius;
  late bool _useLocation;

  final List<Map<String, String>> _cuisines = [
    {'label': 'All', 'value': ''},
    {'label': 'Italian', 'value': 'ITALIAN', 'emoji': '🍕'},
    {'label': 'Mediterranean', 'value': 'MEDITERRANEAN', 'emoji': '🥗'},
    {'label': 'Mexican', 'value': 'MEXICAN', 'emoji': '🌮'},
    {'label': 'Indian', 'value': 'INDIAN', 'emoji': '🍛'},
    {'label': 'Chinese', 'value': 'CHINESE', 'emoji': '🍜'},
  ];

  final List<double> _radiusOptions = [1.0, 3.0, 5.0, 10.0, 25.0];

  @override
  void initState() {
    super.initState();
    _selectedCuisine = controller.selectedCuisine.value;
    _deliveryAvailable = controller.filterDeliveryAvailable.value;
    _pickupAvailable = controller.filterPickupAvailable.value;
    _radius = controller.filterRadius.value;
    _useLocation = controller.filterByLocation.value;
  }

  void _resetLocal() {
    setState(() {
      _selectedCuisine = '';
      _deliveryAvailable = false;
      _pickupAvailable = false;
      _radius = 10.0;
      _useLocation = false;
    });
  }

  void _apply() {
    controller.applyFilters(
      cuisine: _selectedCuisine,
      delivery: _deliveryAvailable,
      pickup: _pickupAvailable,
      radius: _radius,
      useLocation: _useLocation,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        top: 16.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2EBE5),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Kitchens',
                  style: GoogleFonts.outfit(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _resetLocal,
                      child: Text(
                        'Reset',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18.sp,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Section 1: Cuisine Types
            Text(
              'CUISINE TYPE',
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 10.h,
              children: _cuisines.map((c) {
                final isSelected = _selectedCuisine == c['value'];
                final label = c['label']!;
                final emoji = c['emoji'] != null ? '${c['emoji']} ' : '';
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCuisine = isSelected ? '' : (c['value'] ?? '');
                    });
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFE2EBE5),
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      '$emoji$label',
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24.h),

            // Section 2: Service / Delivery Mode
            Text(
              'SERVICE OPTIONS',
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildServiceOptionCard(
                    title: 'Delivery',
                    subtitle: 'Direct to your door',
                    icon: Icons.delivery_dining_rounded,
                    isSelected: _deliveryAvailable,
                    onTap: () {
                      setState(() {
                        _deliveryAvailable = !_deliveryAvailable;
                      });
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildServiceOptionCard(
                    title: 'Pickup',
                    subtitle: 'Takeaway from kitchen',
                    icon: Icons.shopping_bag_outlined,
                    isSelected: _pickupAvailable,
                    onTap: () {
                      setState(() {
                        _pickupAvailable = !_pickupAvailable;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Section 3: Distance / Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEARBY RADIUS',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _useLocation
                          ? 'Within ${_radius.toInt()} km of current location'
                          : 'Show kitchens everywhere',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: _useLocation
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: _useLocation,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _useLocation = val;
                    });
                  },
                ),
              ],
            ),
            if (_useLocation) ...[
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _radiusOptions.map((r) {
                  final isSelected = _radius == r;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _radius = r;
                      });
                    },
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFE2EBE5),
                        ),
                      ),
                      child: Text(
                        '${r.toInt()} km',
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color:
                              isSelected ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            SizedBox(height: 32.h),

            // Apply Button
            PrimaryButton(
              onPressed: _apply,
              text: 'Apply Filters',
              showArrow: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2EBE5),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 22.sp,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                Container(
                  width: 18.r,
                  height: 18.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12.sp,
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.textDark,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
