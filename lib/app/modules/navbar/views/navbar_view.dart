import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../userprofile/systempreference/views/systempreference_view.dart';
import '../../nutritions/nutritionboard/views/nutritionboard_view.dart';
import '../../groceries/views/groceries_board_view.dart';
import '../../explore/exploreboard/views/exploreboard_view.dart';
import '../controllers/navbar_controller.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex,
          children: [
            const DashboardView(),
            const GroceriesBoardView(),
            const ExploreboardView(),
            const NutritionboardView(),
            const SystempreferenceView(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          padding: const EdgeInsets.all(8),
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, AppAssets.homeIcon, 'Home'),
                _buildNavItem(1, AppAssets.storeIcon, 'Store'),
                _buildNavItem(2, AppAssets.compassIcon, 'Explore'),
                _buildNavItem(3, AppAssets.nutritionIcon, 'Nutrition'),
                _buildNavItem(4, AppAssets.singlePersonIcon, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    final isSelected = controller.currentIndex == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 8,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              child: iconPath.endsWith('.svg')
                  ? SvgPicture.asset(
                      iconPath,
                      colorFilter: ColorFilter.mode(
                        isSelected ? AppColors.primary : Colors.white,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    )
                  : Image.asset(
                      iconPath,
                      color: isSelected ? AppColors.primary : Colors.white,
                      width: 24,
                      height: 24,
                    ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              alignment: Alignment.centerLeft,
              child: isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          label,
                          maxLines: 1,
                          softWrap: false,
                          style: GoogleFonts.outfit(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
