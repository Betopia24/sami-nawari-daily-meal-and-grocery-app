import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_strings.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../widgets/primary_button.dart';
import '../controllers/welcomeauth_controller.dart';

class WelcomeauthView extends GetView<WelcomeauthController> {
  const WelcomeauthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Top Image Section
          Expanded(
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    AppAssets.welcomeAuthImage,
                    fit: BoxFit.cover,
                  ),
                ),
                // Dark overlay to reduce brightness
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(
                      51,
                    ), // 20% opacity (0.2 * 255 ≈ 51)
                  ),
                ),
                // Safe Area overlay for top bar and pills
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top App Name Pill
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 16),
                          // ADJUST BOX SIZE HERE: Increase horizontal for width, vertical for height
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          // ADJUST IMAGE SCALE HERE: Increase scale to make logo bigger
                          child: Transform.scale(
                            scale: 6.9,
                            child: Image.asset(
                              AppAssets.titledLogoGreenGray,
                              height: 28,
                            ),
                          ),
                        ),
                      ),
                      // Bottom Stats Pills
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatPill(
                              AppStrings.recipesCount,
                              AppStrings.recipesLabel,
                              AppColors.primary,
                              const Color(0xFFEEF7F2),
                            ),
                            const SizedBox(width: 12),
                            _buildStatPill(
                              AppStrings.appRatingValue,
                              AppStrings.appRatingLabel,
                              const Color(0xFFD97706),
                              const Color(0xFFFFFBEB),
                            ),
                            const SizedBox(width: 12),
                            _buildStatPill(
                              AppStrings.usersCount,
                              AppStrings.usersLabel,
                              const Color(0xFFE8874A),
                              const Color(0xFFFEF3EA),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Content Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(color: AppColors.surface),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  AppStrings.welcomeTitle,
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.welcomeSubtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: AppStrings.signIn,
                  onPressed: () => Get.toNamed(Routes.signin),
                  showArrow: false,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: AppStrings.createAccount,
                  onPressed: controller.onCreateAccount,
                  isOutlined: true,
                  showArrow: false,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: controller.onContinueAsGuest,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text(AppStrings.continueAsGuest),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(
    String title,
    String subtitle,
    Color titleColor,
    Color backgroundColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                color: titleColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
