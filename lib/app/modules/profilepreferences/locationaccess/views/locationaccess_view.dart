import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/locationaccess_controller.dart';
import '../../widgets/preference_animated_header.dart';
import '../../widgets/preference_title_section.dart';
import '../../widgets/preference_option_card.dart';

class LocationaccessView extends GetView<LocationaccessController> {
  const LocationaccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PreferenceAnimatedHeader(bgSvgPath: AppAssets.locationAccessBg),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PreferenceTitleSection(
                          title: 'Find food near you',
                          subtitle:
                              'Allow location access to discover homemade food sellers, grocery stores, and regional recipes nearby.',
                        ),
                        const SizedBox(height: 24),

                        // Cards
                        const PreferenceOptionCard(
                          iconPath: AppAssets.storeEmojiIcon,
                          title: 'Nearby Homemade Sellers',
                          subtitle:
                              'Find authentic food within walking distance',
                        ),
                        const SizedBox(height: 16),
                        const PreferenceOptionCard(
                          iconPath: AppAssets.cartEmojiIcon,
                          title: 'Local Grocery Stores',
                          subtitle: 'Prices and availability near you',
                        ),
                        const SizedBox(height: 16),
                        const PreferenceOptionCard(
                          iconPath: AppAssets.locationEmojiIcon,
                          title: 'Personalized Recommendations',
                          subtitle: 'Recipes popular in your area',
                        ),
                      ],
                    ),
                  ),
                ),

                // Fixed Bottom Buttons
                Container(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 32.0,
                    top: 16.0,
                  ),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: 'Allow Location',
                        onPressed: controller.allowLocation,
                        showArrow: false,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: TextButton(
                          onPressed: controller.skip,
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.backgroundGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Not Now',
                            style: GoogleFonts.outfit(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
