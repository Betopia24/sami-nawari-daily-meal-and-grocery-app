import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/primary_button.dart';
import '../../widgets/profile_app_bar.dart';
import '../controllers/rateapp_controller.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class RateappView extends GetView<RateappController> {
  const RateappView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: 'Rate the App'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildAnimatedStar(
                        controller.star1Animation,
                        72,
                        rotation: -15,
                        paddingBottom: 16,
                      ),
                      const SizedBox(width: 4),
                      _buildAnimatedStar(
                        controller.star2Animation,
                        108,
                        rotation: 0,
                        paddingBottom: 32, // Elevate the center star
                      ),
                      const SizedBox(width: 4),
                      _buildAnimatedStar(
                        controller.star3Animation,
                        72,
                        rotation: 15,
                        paddingBottom: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Rate Our App',
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
                      'Your feedback help us to connect more effective. Would you take a moment to rate us?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ), // Push content further up from true center
                ],
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  PrimaryButton(
                    text: GetPlatform.isIOS
                        ? 'Rate on App Store'
                        : 'Rate on Play Store',
                    showArrow: false,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Maybe Later',
                    showArrow: false,
                    isOutlined: true,
                    onPressed: () => Get.back(),
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

  Widget _buildAnimatedStar(
    Animation<double> animation,
    double size, {
    required double rotation,
    required double paddingBottom,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Padding(
            padding: EdgeInsets.only(bottom: paddingBottom),
            child: Transform.rotate(
              angle: rotation * (math.pi / 180),
              child: Icon(
                Icons.star_rounded,
                size: size,
                color: const Color(
                  0xFFF3AF3D,
                ), // Matches the exact yellow in screenshot
              ),
            ),
          ),
        );
      },
    );
  }
}
