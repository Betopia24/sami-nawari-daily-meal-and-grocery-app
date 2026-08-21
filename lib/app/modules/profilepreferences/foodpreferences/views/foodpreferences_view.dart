import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/primary_button.dart';
import '../../widgets/food_preference_card.dart';
import '../../widgets/preference_title_section.dart';
import '../controllers/foodpreferences_controller.dart';

class FoodpreferencesView extends GetView<FoodpreferencesController> {
  const FoodpreferencesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors
          .background, // Slightly off-white background based on screenshots
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderGrey),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.backArrowIcon,
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Title and grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PreferenceTitleSection(
                      title: 'Your food preferences',
                      subtitle:
                          'We\'ll personalize your recipe recommendations.\nSelect all that apply.',
                    ),
                    const SizedBox(height: 32),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                                0.70, // Slightly taller to fit text
                          ),
                      itemCount: controller.foodOptions.length,
                      itemBuilder: (context, index) {
                        final option = controller.foodOptions[index];
                        return Obx(() {
                          final isSelected = controller.selectedPreferences
                              .contains(option['id']);
                          return FoodPreferenceCard(
                            iconPathOrEmoji: option['icon']!,
                            title: option['title']!,
                            subtitle: option['subtitle']!,
                            isSelected: isSelected,
                            onTap: () =>
                                controller.togglePreference(option['id']!),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom section
            Container(
              padding: const EdgeInsets.all(24.0),
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    final count = controller.selectedPreferences.length;
                    if (count > 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          '$count preferences selected',
                          style: GoogleFonts.outfit(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  PrimaryButton(
                    text: 'Continue',
                    onPressed: controller.proceed,
                    showArrow: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
