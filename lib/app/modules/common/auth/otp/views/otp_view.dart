import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_strings.dart';
import '../../../../../widgets/primary_button.dart';
import '../../widgets/icon_auth_header.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.outfit(
        fontSize: 24,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 16.0),
              child: GestureDetector(
                onTap: controller.goBack,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: SvgPicture.asset(
                    AppAssets.backArrowIcon,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          IconAuthHeader(
                            title: AppStrings.otpTitle,
                            subtitle: AppStrings.otpSubtitle,
                            subtitleHighlight: controller.maskedEmail,
                          ),
                          const SizedBox(height: 32),
                          // Pinput
                          Center(
                            child: Obx(
                              () => Column(
                                children: [
                                  Pinput(
                                    length: 6,
                                    controller: controller.pinController,
                                    focusNode: controller.focusNode,
                                    defaultPinTheme: defaultPinTheme,
                                    focusedPinTheme: focusedPinTheme,
                                    followingPinTheme: controller.hasError
                                        ? defaultPinTheme.copyDecorationWith(
                                            border: Border.all(
                                              color: AppColors.error,
                                            ),
                                          )
                                        : defaultPinTheme,
                                    separatorBuilder: (index) =>
                                        const SizedBox(width: 8),
                                    showCursor: true,
                                    onChanged: controller.onPinChanged,
                                    onCompleted: (pin) =>
                                        controller.verifyOtp(),
                                  ),
                                  if (controller.hasError) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Please enter the complete 6-digit code',
                                      style: GoogleFonts.outfit(
                                        color: AppColors.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Timer Text
                          Center(
                            child: Obx(
                              () => GestureDetector(
                                onTap: controller.timerValue == 0
                                    ? controller.resendCode
                                    : null,
                                child: controller.timerValue == 0
                                    ? Text(
                                        AppStrings.resendCode,
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            color: AppColors.textSecondary,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: AppStrings.resendCodeIn,
                                            ),
                                            TextSpan(
                                              text:
                                                  '0:${controller.timerValue.toString().padLeft(2, '0')}',
                                              style: const TextStyle(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 32),
                          // Verify Button
                          PrimaryButton(
                            text: AppStrings.verifyEmail,
                            onPressed: controller.verifyOtp,
                            showArrow: false,
                          ),
                          const SizedBox(height: 24),
                          // Footer text
                          Center(
                            child: Text(
                              AppStrings.checkSpam,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
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
