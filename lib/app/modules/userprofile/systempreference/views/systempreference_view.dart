
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
import '../../widgets/subscription_plan_card.dart';
import '../controllers/systempreference_controller.dart';
import '../../../../data/network/local_storage.dart';

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
              child: Obx(() => Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsRow(),
                ],
              )),
            ),
            Expanded(
              child: Container(
                color: AppColors.backgroundSecondary,
                child: RefreshIndicator(
                  onRefresh: controller.fetchUserProfile,
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!controller.isSellerMode.value) ...[
                            SubscriptionPlanCard(
                              planName: 'Free / Basic',
                              description: 'Upgrade for more features and a better experience',
                              onViewPlans: () {
                                Get.toNamed(Routes.chooseyourplan);
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                          _buildBecomeSellerBanner(),
                          const SizedBox(height: 24),
                          _buildSectionTitle(controller.isSellerMode.value ? 'MANAGE' : 'MARKETPLACE'),
                          const SizedBox(height: 12),
                          controller.isSellerMode.value ? _buildSellerManageSection() : _buildBuyerMarketplaceSection(),
                          const SizedBox(height: 24),
                          _buildSectionTitle('ACCOUNT'),
                          const SizedBox(height: 12),
                          _buildAccountSection(),
                          if (controller.isSellerMode.value) ...[
                            const SizedBox(height: 24),
                            _buildSectionTitle('PAYMENT METHOD'),
                            const SizedBox(height: 12),
                            _buildSellerPaymentSection(),
                          ],
                          const SizedBox(height: 24),
                          _buildSectionTitle('PRIVACY & SECURITY'),
                          const SizedBox(height: 12),
                          _buildPrivacySecuritySection(),
                          const SizedBox(height: 32),
                          _buildSignOutButton(),
                          const SizedBox(height: 140), // Space for bottom navbar
                        ],
                      )),
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
    final user = controller.user.value;
    final hasImage = user?.hasProfilePicture ?? false;
    final displayName = controller.isSellerMode.value
        ? (user?.name != null ? "${user!.name}'s Kitchen" : "Rafi's Kitchen")
        : (user?.displayName ?? 'Rafiul Islam');
    final displaySubtitle = controller.isSellerMode.value
        ? (user?.name != null ? 'by ${user!.name}' : 'by Rafiul Islam')
        : (user?.displayEmail.isNotEmpty == true ? user!.displayEmail : 'rafi@email.com');
    final displayRole = controller.isSellerMode.value ? 'Seller' : 'Buyer';

    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: hasImage
                    ? Image.network(
                        user!.profilePicture!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
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
                displayName,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                displaySubtitle,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                displayRole,
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
          onTap: () {
            if (controller.isSellerMode.value) {
              Get.toNamed('/editsellerprofile');
            } else {
              Get.toNamed('/editbuyerprofile');
            }
          },
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

  Widget _buildDefaultAvatar() {
    return Center(
      child: SvgPicture.asset(
        AppAssets.singlePersonIcon,
        width: 40,
        height: 40,
        colorFilter: const ColorFilter.mode(
          AppColors.primary,
          BlendMode.srcIn,
        ),
      ),
    );
  }


  Widget _buildStatsRow() {
    if (controller.isSellerMode.value) {
      return Row(
        children: [
          _buildStatItem('5', 'Orders'),
          _buildVerticalDivider(),
          _buildStatItem('2', 'Pending'),
          _buildVerticalDivider(),
          _buildStatItem('12', 'Completed'),
        ],
      );
    }
    final currentUser = controller.user.value;
    final recipesCount = currentUser?.recipesSaved.toString() ?? '0';
    final mealsCount = currentUser?.mealsCooked.toString() ?? '0';
    final groceryCount = currentUser?.groceryLists.toString() ?? '0';

    return Row(
      children: [
        _buildStatItem(recipesCount, 'Recipes Saved'),
        _buildVerticalDivider(),
        _buildStatItem(mealsCount, 'Meals Cooked'),
        _buildVerticalDivider(),
        _buildStatItem(groceryCount, 'Grocery Lists'),
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
    final isApproved = controller.isRegisteredSeller.value;
    final isPending = controller.hasPendingSellerRequest.value;
    final isSwitching = controller.isSwitchingRole.value;

    return InkWell(
      onTap: isSwitching
          ? null
          : () {
              if (isApproved) {
                // If already approved, toggle modes
                controller.toggleSellerMode();
              } else if (isPending) {
                // If waiting for admin approval, show pending dialog
                controller.showPendingApprovalDialog();
              } else {
                // If not registered, navigate to the start page
                Get.toNamed(Routes.SELLER_STARTPAGE);
              }
            },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPending && !isApproved
              ? const Color(0xFFD97706) // Warm amber for pending review
              : AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            isApproved
                ? const Icon(Icons.sync, color: Colors.white, size: 28)
                : (isPending
                    ? const Icon(Icons.hourglass_top_rounded, color: Colors.white, size: 28)
                    : SvgPicture.asset(
                        AppAssets.sellerStoreIcon,
                        width: 32,
                        height: 32,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      )),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isApproved
                        ? (controller.isSellerMode.value ? 'Switch to Buyer' : 'Switch to Seller')
                        : (isPending ? 'Seller Request Pending' : 'Become a Seller'),
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSwitching
                        ? (controller.isSellerMode.value
                            ? 'Switching to Buyer mode...'
                            : 'Switching to Seller mode...')
                        : (isApproved
                            ? (controller.isSellerMode.value
                                ? 'Switch back to customer mode'
                                : 'Switch to manage your kitchen')
                            : (isPending
                                ? 'Waiting for admin approval'
                                : 'Share your homemade food')),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            if (isSwitching)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.2,
                ),
              )
            else
              const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
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
      onTap: () async {
        await LocalStorage.clearAuthData();
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
  Widget _buildBuyerMarketplaceSection() {
    return ProfileSectionCard(
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
    );
  }

  Widget _buildSellerManageSection() {
    return ProfileSectionCard(
      children: [
        ProfileMenuTile(
          iconPath: AppAssets.addFoodIcon,
          title: 'Add Food',
          onTap: () => Get.toNamed(Routes.addnewfood),
        ),
        ProfileMenuTile(
          iconPath: AppAssets.myFoodIcon,
          title: 'My Food',
          onTap: () {},
        ),
        ProfileMenuTile(
          iconPath: AppAssets.orderHistoryIcon,
          title: 'Orders',
          onTap: () => Get.toNamed(Routes.orderlist),
        ),
        ProfileMenuTile(
          iconPath: AppAssets.earning2Icon,
          title: 'Earnings',
          onTap: () => Get.toNamed(Routes.earnings),
          showBottomDivider: false,
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return ProfileSectionCard(
      children: [
        Obx(
          () => ProfileMenuTile(
            iconPath: AppAssets.notification1Icon,
            title: 'Notifications',
            trailing: CupertinoSwitch(
              value: controller.notificationsEnabled.value,
              activeTrackColor: AppColors.primary,
              onChanged: controller.toggleNotifications,
            ),
          ),
        ),
        ProfileMenuTile(
          iconPath: AppAssets.languageIcon,
          title: 'Language & Region',
          trailing: _buildTrailingText('English (US)'),
          onTap: () => Get.toNamed(Routes.languageandregion),
        ),
        ProfileMenuTile(
          iconPath: AppAssets.lockIcon,
          title: 'Update Password',
          onTap: () => Get.toNamed(Routes.updatepassword),
          showBottomDivider: !controller.isSellerMode.value, // Hide if it's the last item in seller mode
        ),
        if (!controller.isSellerMode.value) ...[
          ProfileMenuTile(
            iconPath: AppAssets.inviteFamilyIcon,
            title: 'Invite Family',
            onTap: () => Get.toNamed(Routes.familyinvite),
            trailing: _buildTrailingText('3 members'),
          ),
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
            onTap: () => Get.toNamed(Routes.alergiesandintolerence),
            showBottomDivider: false,
          ),
        ]
      ],
    );
  }

  Widget _buildSellerPaymentSection() {
    return ProfileSectionCard(
      children: [
        ProfileMenuTile(
          iconPath: AppAssets.bankDetailsIcon,
          title: 'Bank Details',
          onTap: () => Get.toNamed(Routes.BANKDETAILS),
        ),
        ProfileMenuTile(
          iconPath: AppAssets.paymentInformationIcon,
          title: 'Payment Information',
          onTap: () {
            Get.toNamed(Routes.paymentinformation);
          },
          showBottomDivider: false,
        ),
      ],
    );
  }

  Widget _buildPrivacySecuritySection() {
    return ProfileSectionCard(
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
    );
  }
}
