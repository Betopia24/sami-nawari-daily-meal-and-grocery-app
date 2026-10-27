import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../controllers/success_controller.dart';

class SuccessView extends GetView<SuccessController> {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final title = Get.arguments != null && Get.arguments['title'] != null
        ? Get.arguments['title']
        : 'Account Created!';
    final subtitle = Get.arguments != null && Get.arguments['subtitle'] != null
        ? Get.arguments['subtitle']
        : 'Your account has been created\nsuccessfully.';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.successTick, width: 120, height: 120),
            const SizedBox(height: 32),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
