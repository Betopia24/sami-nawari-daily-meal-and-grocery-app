import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/onboarding_controller.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // PageView for swiping content
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: const [
              OnboardingPageWidget(
                imagePath: AppAssets.obImage1,
                label: AppStrings.onboardingLabel1,
                title: AppStrings.onboardingTitle1,
                description: AppStrings.onboardingDesc1,
              ),
              OnboardingPageWidget(
                imagePath: AppAssets.obImage2,
                label: AppStrings.onboardingLabel2,
                title: AppStrings.onboardingTitle2,
                description: AppStrings.onboardingDesc2,
              ),
              OnboardingPageWidget(
                imagePath: AppAssets.obImage3,
                label: AppStrings.onboardingLabel3,
                title: AppStrings.onboardingTitle3,
                description: AppStrings.onboardingDesc3,
              ),
            ],
          ),

          // Top Navigation (Back & Skip)
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button (Hide on first page)
                  Obx(() {
                    if (controller.currentIndex.value == 0) {
                      return SizedBox(
                        width: 40.w,
                      ); // Placeholder to keep spacing
                    }
                    return GestureDetector(
                      onTap: controller.previous,
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.backArrowIcon,
                            width: 16.w,
                          ),
                        ),
                      ),
                    );
                  }),
                  // Skip Button
                  GestureDetector(
                    onTap: controller.skip,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        AppStrings.skip,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation (Dots and Next Button)
          Positioned(
            left: 24.w,
            right: 24.w,
            bottom: 40.h,
            child: Column(
              children: [
                // Dots
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => _buildDot(index)),
                  ),
                ),
                SizedBox(height: 24.h),
                // Button
                Obx(
                  () => PrimaryButton(
                    text: controller.currentIndex.value == 2
                        ? AppStrings.getStarted
                        : AppStrings.next,
                    onPressed: controller.next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 8.h,
      width: controller.currentIndex.value == index ? 24.w : 8.w,
      decoration: BoxDecoration(
        color: controller.currentIndex.value == index
            ? AppColors.primary
            : AppColors.dotInactive,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
