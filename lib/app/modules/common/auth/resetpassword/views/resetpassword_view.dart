import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_strings.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/primary_button.dart';
import '../../widgets/icon_auth_header.dart';
import '../controllers/resetpassword_controller.dart';

class ResetpasswordView extends GetView<ResetpasswordController> {
  const ResetpasswordView({super.key});

  @override
  Widget build(BuildContext context) {
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
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            IconAuthHeader(
                              title: AppStrings.resetPasswordTitle,
                              subtitle: AppStrings.resetPasswordSubtitle,
                              subtitleHighlight: controller.email,
                            ),
                            const SizedBox(height: 32),
                            // New Password Field
                            Obx(
                              () => CustomTextField(
                                label: AppStrings.newPasswordLabel,
                                hint: AppStrings
                                    .passwordHint, // Using existing "Min. 8 characters"
                                prefixIcon: AppAssets.lockIcon,
                                controller: controller.newPasswordController,
                                obscureText: !controller.isNewPasswordVisible,
                                validator: controller.validatePassword,
                                isPassword: true,
                                onToggleVisibility:
                                    controller.toggleNewPasswordVisibility,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Confirm Password Field
                            Obx(
                              () => CustomTextField(
                                label: AppStrings.confirmPasswordLabel,
                                hint: AppStrings.confirmPasswordHint,
                                prefixIcon: AppAssets.lockIcon,
                                controller:
                                    controller.confirmPasswordController,
                                obscureText:
                                    !controller.isConfirmPasswordVisible,
                                validator: controller.validateConfirmPassword,
                                isPassword: true,
                                onToggleVisibility:
                                    controller.toggleConfirmPasswordVisibility,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(height: 32),
                            // Reset Password Button
                            PrimaryButton(
                              text: AppStrings.resetPasswordButton,
                              onPressed: controller.resetPassword,
                              showArrow: false,
                            ),
                            const SizedBox(height: 32),
                          ],
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
    );
  }
}
