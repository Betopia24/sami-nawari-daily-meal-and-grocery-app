import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../../widgets/step_indicator.dart';
import '../controllers/deliveryaddress_controller.dart';

class DeliveryaddressView extends GetView<DeliveryaddressController> {
  const DeliveryaddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 24, top: 8, bottom: 8),
          child: CustomBackButton(),
        ),
        title: Text(
          'Delivery Address',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const StepIndicator(currentStep: 2), // 2 = Address
          const Divider(height: 1, thickness: 1, color: AppColors.borderGrey),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED), // Light orange
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFEDD5), // Subtle orange border
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.deliveryIcon,
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFEA580C), // Orange icon
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Delivery By Seller',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFEA580C), // Orange text
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your delivery address below. The seller will personally coordinate your order.',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Form Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderGrey),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'STREET ADDRESS *',
                          hint: 'e.g. 123 Main Street',
                          controller: controller.streetController,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'APT / UNIT (OPTIONAL)',
                          hint: 'e.g. Apt 4B',
                          controller: controller.aptController,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'CITY',
                          hint: 'e.g. San Francisco',
                          controller: controller.cityController,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'DELIVERY NOTES (OPTIONAL)',
                          hint: 'e.g. Ring doorbell, leave at door...',
                          controller: controller.notesController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Continue Button
          Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Obx(
              () => PrimaryButton(
                text: 'Continue',
                showArrow: false,
                isEnabled: controller.isFormValid.value,
                onPressed: controller.onContinue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
