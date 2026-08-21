import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../widgets/profile_menu_tile.dart';
import '../../widgets/profile_section_card.dart';
import '../controllers/systempreference_controller.dart';

class SystempreferenceView extends GetView<SystempreferenceController> {
  const SystempreferenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsRow(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: AppColors.backgroundSecondary,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBecomeSellerBanner(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('MARKETPLACE'),
                        const SizedBox(height: 12),
                        ProfileSectionCard(
                          children: [
                            ProfileMenuTile(
                              iconPath: AppAssets.orderHistoryIcon,
                              title: 'Order History',
                              onTap: () => Get.toNamed(Routes.orderhistory),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.bookmarkFilledIcon,
                              title: 'Saved Recipes',
                              onTap: () => Get.toNamed(Routes.savedreceipe),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.shareIcon,
                              title: 'Share App',
                              onTap: () => Get.toNamed(Routes.appsharing),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.storeIcon,
                              title: 'Favorite Sellers',
                              textColor: AppColors.textPrimary,
                              onTap: () => Get.toNamed(Routes.favouriteseller),
                              showBottomDivider: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('ACCOUNT'),
                        const SizedBox(height: 12),
                        ProfileSectionCard(
                          children: [
                            Obx(
                              () => ProfileMenuTile(
                                iconPath: AppAssets.notification1Icon,
                                title: 'Notifications',
                                trailing: CupertinoSwitch(
                                  value: controller.notificationsEnabled.value,
                                  activeColor: AppColors.primary,
                                  onChanged: controller.toggleNotifications,
                                ),
                              ),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.languageIcon,
                              title: 'Language & Region',
                              trailing: _buildTrailingText('English (US)'),
                              onTap: () =>
                                  Get.toNamed(Routes.languageandregion),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.lockIcon,
                              title: 'Update Password',
                              onTap: () => Get.toNamed(Routes.updatepassword),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.inviteFamilyIcon,
                              title: 'Invite Family',
                              onTap: () => Get.toNamed(Routes.familyinvite),
                              trailing: _buildTrailingText('3 members'),
                              showBottomDivider: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('PREFERENCES'),
                        const SizedBox(height: 12),
                        ProfileSectionCard(
                          children: [
                            ProfileMenuTile(
                              iconPath: AppAssets.dietaryPrefIcon,
                              title: 'Dietary Preferences',
                              trailing: _buildTrailingText('No Preference'),
                              onTap: () => Get.toNamed(Routes.dietarypref),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.allergiesAndIntoleranceIcon,
                              title: 'Allergies & Intolerances',
                              trailing: _buildTrailingText('None set'),
                              onTap: () =>
                                  Get.toNamed(Routes.alergiesandintolerence),
                              showBottomDivider: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('PRIVACY & SECURITY'),
                        const SizedBox(height: 12),
                        ProfileSectionCard(
                          children: [
                            ProfileMenuTile(
                              iconPath: AppAssets.privacyPolicyIcon,
                              title: 'Privacy Policy',
                              onTap: () => Get.toNamed(Routes.privacypolicy),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.helpAndSupportIcon,
                              title: 'Help & Support',
                              onTap: () => Get.toNamed(Routes.helpandsupport),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.rateTheAppIcon,
                              title: 'Rate the App',
                              onTap: () => Get.toNamed(Routes.rateapp),
                            ),
                            ProfileMenuTile(
                              iconPath: AppAssets.termsAndConditionIcon,
                              title: 'Terms & Conditions',
                              onTap: () => Get.toNamed(Routes.termandcondition),
                              showBottomDivider: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildSignOutButton(),
                        const SizedBox(height: 140), // Space for bottom navbar
                      ],
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

  Widget _buildHeader() {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: SvgPicture.asset(
                AppAssets.singlePersonIcon,
                width: 40,
                height: 40,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rafiul Islam',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'rafi@email.com',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Buyer',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => Get.toNamed('/editbuyerprofile'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              AppAssets.editIcon,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem('3', 'Recipes Saved'),
        _buildVerticalDivider(),
        _buildStatItem('47', 'Meals Cooked'),
        _buildVerticalDivider(),
        _buildStatItem('12', 'Grocery Lists'),
      ],
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.2),
    );
  }

  Widget _buildBecomeSellerBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.sellerStoreIcon,
            width: 32,
            height: 32,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Become a Seller',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Share your homemade food',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade500,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTrailingText(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.chevron_right,
          color: Colors.grey.withValues(alpha: 0.5),
          size: 20,
        ),
      ],
    );
  }

  Widget _buildSignOutButton() {
    return InkWell(
      onTap: () {
        Get.offAllNamed(Routes.signin);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.signedOutIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text(
              'Sign Out',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
