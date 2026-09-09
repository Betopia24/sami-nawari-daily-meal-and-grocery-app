import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/startpage_controller.dart';
import '../../widgets/feature_list_tile.dart';

class StartpageView extends GetView<StartpageController> {
  const StartpageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: CustomBackButton(
            backgroundColor: Colors.white,
            hasBorder: true,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Illustration
                      Image.asset(
                        AppAssets.sellerHomeGraphic,
                        height: 120,
                      ),
                      const SizedBox(height: 32),
                      // Title
                      Text(
                        'Share Your Homemade\nFood with Your Community',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Features
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            FeatureListTile(
                              icon: Icons.groups_outlined,
                              svgIcon: AppAssets.connectIcon,
                              text: 'Reach more local customers',
                            ),
                            FeatureListTile(
                              icon: Icons.monetization_on_outlined,
                              svgIcon: AppAssets.earnIcon,
                              text: 'Earn from your cooking',
                            ),
                            FeatureListTile(
                              icon: Icons.access_time,
                              svgIcon: AppAssets.alarmClockIcon,
                              text: 'Set your own schedule',
                            ),
                            FeatureListTile(
                              icon: Icons.alt_route,
                              svgIcon: AppAssets.graphTreeIcon,
                              text: 'No delivery partner needed',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Action
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: PrimaryButton(
                  text: 'Start Seller Registration',
                  onPressed: controller.startRegistration,
                  showArrow: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'It only takes a few minutes',
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 12,
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

