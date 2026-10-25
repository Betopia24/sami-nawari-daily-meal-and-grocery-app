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
import '../../widgets/auth_header.dart';
import '../../widgets/social_auth_button.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

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
                onTap: () => Get.back(),
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        // Header
                        const AuthHeader(
                          title: AppStrings.signupTitle,
                          subtitle: AppStrings.signupSubtitle,
                        ),
                        const SizedBox(height: 32),
                        // Full Name Field
                        CustomTextField(
                          label: AppStrings.fullNameLabel,
                          hint: AppStrings.fullNameHint,
                          prefixIcon: AppAssets.singlePersonIcon,
                          controller: controller.fullNameController,
                          keyboardType: TextInputType.name,
                          validator: controller.validateFullName,
                        ),
                        const SizedBox(height: 16),
                        // Email Field
                        CustomTextField(
                          label: AppStrings.emailLabel,
                          hint: AppStrings.emailHint,
                          prefixIcon: AppAssets.mailIcon,
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: controller.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        // Phone Number Field
                        CustomTextField(
                          label: AppStrings.phoneLabel,
                          hint: AppStrings.phoneHint,
                          prefixIcon: AppAssets.callIcon,
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          validator: controller.validatePhone,
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        Obx(
                          () => CustomTextField(
                            label: AppStrings.passwordLabel,
                            hint: AppStrings.passwordHint,
                            prefixIcon: AppAssets.lockIcon,
                            controller: controller.passwordController,
                            isPassword: true,
                            obscureText: controller.isPasswordHidden.value,
                            onToggleVisibility:
                                controller.togglePasswordVisibility,
                            validator: controller.validatePassword,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Confirm Password Field
                        Obx(
                          () => CustomTextField(
                            label: AppStrings.confirmPasswordLabel,
                            hint: AppStrings.confirmPasswordHint,
                            prefixIcon: AppAssets.lockIcon,
                            controller: controller.confirmPasswordController,
                            isPassword: true,
                            obscureText:
                                controller.isConfirmPasswordHidden.value,
                            onToggleVisibility:
                                controller.toggleConfirmPasswordVisibility,
                            validator: controller.validateConfirmPassword,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Sign Up Button
                        Obx(
                          () => PrimaryButton(
                            text: controller.isLoading.value
                                ? 'Creating Account...'
                                : AppStrings.signupButton,
                            onPressed: controller.signup,
                            isEnabled: !controller.isLoading.value,
                            showArrow: false,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Divider
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: Color(0xFFE5E7EB)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                AppStrings.orSignUpWith,
                                style: GoogleFonts.outfit(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Color(0xFFE5E7EB)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Social Buttons
                        Row(
                          children: [
                            Expanded(
                              child: SocialAuthButton(
                                iconPath: AppAssets.googleIcon,
                                text: AppStrings.google,
                                onPressed: controller.continueWithGoogle,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SocialAuthButton(
                                iconPath: AppAssets.appleIcon,
                                text: AppStrings.apple,
                                onPressed: controller.continueWithApple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Footer
                        AuthFooter(
                          text: AppStrings.alreadyHaveAccount,
                          actionText: AppStrings.signIn,
                          onActionPressed: controller.goToSignIn,
                        ),
                        const SizedBox(height: 32),
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
}
