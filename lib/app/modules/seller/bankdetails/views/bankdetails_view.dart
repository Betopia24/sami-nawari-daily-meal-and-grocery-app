import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/bankdetails_controller.dart';

class BankdetailsView extends GetView<BankdetailsController> {
  const BankdetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFB),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: CustomBackButton(backgroundColor: Colors.white),
        ),
        title: Text(
          'Stripe Connect',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Stripe Connect Card
                    _buildHeroCard(),
                    SizedBox(height: 24.h),

                    // Status Card
                    _buildStatusCard(),
                    SizedBox(height: 24.h),

                    // Features & Benefits List
                    Text(
                      'Why Connect with Stripe?',
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureTile(
                      icon: Icons.flash_on_rounded,
                      iconColor: const Color(0xFF635BFF),
                      iconBg: const Color(0xFF635BFF).withValues(alpha: 0.1),
                      title: 'Fast Automated Payouts',
                      subtitle:
                          'Your customer meal earnings will be transferred directly to your bank account with low latency.',
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureTile(
                      icon: Icons.shield_outlined,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.primary.withValues(alpha: 0.1),
                      title: 'Bank-Grade Security',
                      subtitle:
                          'PCI-DSS compliant end-to-end encryption. Your banking credentials are held securely by Stripe.',
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureTile(
                      icon: Icons.account_balance_rounded,
                      iconColor: const Color(0xFFE8874A),
                      iconBg: const Color(0xFFE8874A).withValues(alpha: 0.1),
                      title: 'Direct Bank Deposits',
                      subtitle:
                          'Easily link any major local or international bank account and track payment histories effortlessly.',
                    ),
                    SizedBox(height: 24.h),

                    // Security Note
                    _buildSecurityNote(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  /// Top Hero Card
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF635BFF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: const Center(
                  child: Icon(
                    Icons.payments_rounded,
                    color: Color(0xFF635BFF),
                    size: 28,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLightGreen,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: AppColors.primary,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Stripe Verified',
                      style: GoogleFonts.outfit(
                        color: AppColors.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Receive Earnings with Stripe',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Connect your Stripe account to configure your bank payout preferences, manage deposits, and receive order payments smoothly.',
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// Status Card
  Widget _buildStatusCard() {
    return Obx(() {
      final isUrlAvailable = controller.stripeUrl.value.isNotEmpty;
      final accountId = controller.stripeAccountId.value;
      final isDone = controller.isCompleted.value;

      final Color statusColor = isDone
          ? AppColors.primary
          : (isUrlAvailable ? const Color(0xFF635BFF) : const Color(0xFFE8874A));

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: statusColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone
                    ? Icons.check_circle_rounded
                    : (isUrlAvailable
                        ? Icons.link_rounded
                        : Icons.info_outline_rounded),
                color: statusColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDone
                        ? 'Stripe Onboarding Complete'
                        : (isUrlAvailable
                            ? 'Onboarding Link Ready'
                            : 'Onboarding Required'),
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    isDone
                        ? 'Your Stripe account is connected. Future earnings will automatically transfer to your bank.'
                        : (isUrlAvailable
                            ? (accountId.isNotEmpty
                                ? 'Account ID: $accountId\nTap below to continue or complete setup in WebView.'
                                : 'Onboarding link created. Tap below to resume anytime.')
                            : 'You have not connected Stripe yet. Complete the quick onboarding to start accepting payouts.'),
                    style: GoogleFonts.outfit(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Feature / Benefit Tile
  Widget _buildFeatureTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Security Assurance
  Widget _buildSecurityNote() {
    return Row(
      children: [
        Icon(Icons.lock_outline_rounded,
            color: AppColors.textSecondary, size: 16.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            'Your financial details are securely managed by Stripe. We do not store sensitive bank account credentials.',
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// Bottom CTA Button
  Widget _buildBottomAction() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            width: double.infinity,
            height: 51.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

        final hasUrl = controller.stripeUrl.value.isNotEmpty;

        return PrimaryButton(
          text: hasUrl ? 'Continue to Stripe' : 'Connect with Stripe',
          showArrow: true,
          onPressed: () {
            if (hasUrl) {
              controller.openExistingStripeUrl();
            } else {
              controller.connectWithStripe();
            }
          },
        );
      }),
    );
  }
}
