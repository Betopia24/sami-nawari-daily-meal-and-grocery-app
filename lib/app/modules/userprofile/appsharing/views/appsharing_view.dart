import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../widgets/primary_button.dart';
import '../../widgets/profile_app_bar.dart';
import '../../widgets/share_via_bottom_sheet.dart';
import '../controllers/appsharing_controller.dart';

class AppsharingView extends GetView<AppsharingController> {
  const AppsharingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: AppStrings.shareAppTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (context, child) {
                      return RotationTransition(
                        turns: controller.rotationAnimation,
                        child: ScaleTransition(
                          scale: controller.scaleAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      AppAssets.shareGraphic,
                      width: 90, // Reduced size
                      height: 90,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.inviteYourPeople,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppStrings.shareAppDescription,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: QrImageView(
                      data: controller.appDownloadUrl,
                      version: QrVersions.auto,
                      size: 160,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.primary,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.primary,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.scanToJoin,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  PrimaryButton(
                    text: AppStrings.shareButton,
                    showArrow: false,
                    onPressed: () {
                      Get.bottomSheet(
                        const ShareViaBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (btnContext) {
                      return PrimaryButton(
                        text: AppStrings.copyLinkButton,
                        showArrow: false,
                        isOutlined: true,
                        prefixIcon: Icons.link,
                        onPressed: () {
                          final box = btnContext.findRenderObject() as RenderBox?;
                          final origin = box != null
                              ? box.localToGlobal(Offset.zero) & box.size
                              : null;
                          controller.copyLink(sharePositionOrigin: origin);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
