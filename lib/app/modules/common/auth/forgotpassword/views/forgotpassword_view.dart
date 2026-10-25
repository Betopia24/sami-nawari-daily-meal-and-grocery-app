import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_strings.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/primary_button.dart';
import '../../widgets/auth_footer.dart';
import '../../widgets/icon_auth_header.dart';
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
                            IconAuthHeader(
                              title: AppStrings.forgotPasswordTitle,
                              subtitle: AppStrings.forgotPasswordSubtitle,
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
                            Obx(
                              () => PrimaryButton(
                                text: controller.isLoading.value
                                    ? 'Sending Code...'
                                    : AppStrings.sendResetLink,
                                onPressed: controller.sendResetLink,
                                isEnabled: !controller.isLoading.value,
                                showArrow: false,
                              ),
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
