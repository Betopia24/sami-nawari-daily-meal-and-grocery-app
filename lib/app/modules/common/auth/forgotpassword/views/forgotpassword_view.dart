import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_strings.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/primary_button.dart';
import '../../widgets/auth_footer.dart';
import '../controllers/forgotpassword_controller.dart';

class ForgotpasswordView extends GetView<ForgotpasswordController> {
  const ForgotpasswordView({super.key});

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
                onTap: controller.goBackToSignIn,
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
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Transform.scale(
                                  scale: 5,
                                  child: SvgPicture.asset(
                                    AppAssets.logoSvg,
                                    width: 24,
                                    height: 24,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              AppStrings.forgotPasswordTitle,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.forgotPasswordSubtitle,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Email Field
                            CustomTextField(
                              label: AppStrings.emailLabel,
                              hint: AppStrings.emailHint,
                              prefixIcon: AppAssets.mailIcon,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: controller.validateEmail,
                            ),
                            const Spacer(),
                            const SizedBox(height: 32),
                            // Send Reset Link Button
                            PrimaryButton(
                              text: AppStrings.sendResetLink,
                              onPressed: controller.sendResetLink,
                              showArrow: false,
                            ),
                            const SizedBox(height: 24),
                            // Back to Sign In
                            AuthFooter(
                              text: AppStrings.backtoText,
                              actionText: AppStrings.signIn,
                              onActionPressed: controller.goBackToSignIn,
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
