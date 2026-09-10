import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_time_dropdown.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/selectable_chip_group.dart';
import '../../../../widgets/step_progress_indicator.dart';
import '../../../../widgets/toggle_setting_card.dart';
import '../../../../widgets/dashed_upload_area.dart';
import '../controllers/sellerregistration_controller.dart';

class SellerregistrationView extends GetView<SellerregistrationController> {
  const SellerregistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: CustomBackButton(
            backgroundColor: Colors.white,
            hasBorder: true,
            onTap: controller.previousStep,
          ),
        ),
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.currentStep.value == 3
                  ? 'Verify Your Identity'
                  : controller.currentStep.value == 4
                      ? 'Review & Submit'
                      : 'Seller Registration',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (controller.currentStep.value == 3 || controller.currentStep.value == 4)
              Text(
                controller.currentStep.value == 3
                    ? 'Add documents to build trust'
                    : 'Review your information before submitting',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        )),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: StepProgressIndicator(
                    currentStep: controller.currentStep.value,
                    totalSteps: 4,
                  ),
                )),
            const Divider(color: Color(0xFFE5E7EB), height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Form(
                  key: controller.formKey,
                  child: Obx(() {
                    if (controller.currentStep.value == 1) {
                      return _buildStep1();
                    } else if (controller.currentStep.value == 2) {
                      return _buildStep2();
                    } else if (controller.currentStep.value == 3) {
                      return _buildStep3();
                    } else if (controller.currentStep.value == 4) {
                      return _buildStep4();
                    }
                    return Container(); // Placeholder for future steps
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Obx(() => PrimaryButton(
                text: controller.currentStep.value == 4 ? 'Submit Application' : 'Continue',
                onPressed: controller.continueToNextStep,
                showArrow: false,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kitchen Info',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tell us about your home kitchen or business.',
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        CustomTextField(
          label: 'KITCHEN / BUSINESS NAME',
          hint: 'e.g. Maria\'s Kitchen',
          controller: controller.kitchenNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter kitchen/business name';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'YOUR NAME',
          hint: 'Full name',
          controller: controller.fullNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'PHONE NUMBER',
          hint: '+63 9XX XXX XXXX',
          controller: controller.phoneNumberController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        RichText(
          text: TextSpan(
            text: 'KITCHEN IMAGES',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: '*',
                style: GoogleFonts.outfit(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' (minimum 5)',
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.kitchenImages.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.kitchenImages.length) {
                  return GestureDetector(
                    onTap: () {
                      controller.pickKitchenImage();
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                        image: DecorationImage(
                          image: FileImage(File(controller.kitchenImages[index])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => controller.removeKitchenImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'CUISINE TYPE',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => SelectableChipGroup(
              options: controller.availableCuisines,
              selectedOptions: controller.selectedCuisines.toList(),
              onChanged: controller.onCuisinesChanged,
            )),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'BRIEF DESCRIPTION',
          hint: 'Tell customers about your cooking style, specialties, and story...',
          controller: controller.descriptionController,
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'LOCATION',
          hint: '123 Market St, San Francisco, CA',
          controller: controller.locationController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter location';
            }
            return null;
          },
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WORKING HOURS',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ToggleSettingCard(
          title: 'Mon - Fri',
          isToggled: controller.monToFriEnabled.value,
          onChanged: (val) => controller.monToFriEnabled.value = val,
          expandedChild: Row(
            children: [
              Expanded(
                child: CustomTimeDropdown(
                  value: controller.monToFriStartTime.value,
                  items: controller.timeOptions,
                  onChanged: (val) => controller.monToFriStartTime.value = val!,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('to', style: TextStyle(color: Colors.black54)),
              ),
              Expanded(
                child: CustomTimeDropdown(
                  value: controller.monToFriEndTime.value,
                  items: controller.timeOptions,
                  onChanged: (val) => controller.monToFriEndTime.value = val!,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ToggleSettingCard(
          title: 'Saturday',
          isToggled: controller.saturdayEnabled.value,
          onChanged: (val) => controller.saturdayEnabled.value = val,
          expandedChild: Row(
            children: [
              Expanded(
                child: CustomTimeDropdown(
                  value: controller.saturdayStartTime.value,
                  items: controller.timeOptions,
                  onChanged: (val) => controller.saturdayStartTime.value = val!,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('to', style: TextStyle(color: Colors.black54)),
              ),
              Expanded(
                child: CustomTimeDropdown(
                  value: controller.saturdayEndTime.value,
                  items: controller.timeOptions,
                  onChanged: (val) => controller.saturdayEndTime.value = val!,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ToggleSettingCard(
          title: 'Sunday',
          isToggled: controller.sundayEnabled.value,
          onChanged: (val) => controller.sundayEnabled.value = val,
          expandedChild: Row(
            children: [
              Expanded(
                child: CustomTimeDropdown(
                  value: controller.sundayStartTime.value,
                  items: controller.timeOptions,
                  onChanged: (val) => controller.sundayStartTime.value = val!,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('to', style: TextStyle(color: Colors.black54)),
              ),
              Expanded(
                child: CustomTimeDropdown(
                  value: controller.sundayEndTime.value,
                  items: controller.timeOptions,
                  onChanged: (val) => controller.sundayEndTime.value = val!,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'DELIVERY METHOD',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ToggleSettingCard(
          title: 'Pickup Available',
          subtitle: 'Customers can pick up from\\nyour location',
          icon: AppAssets.pickupIcon,
          isToggled: controller.pickupAvailable.value,
          onChanged: (val) => controller.pickupAvailable.value = val,
        ),
        const SizedBox(height: 12),
        ToggleSettingCard(
          title: 'Delivery Available',
          subtitle: 'You deliver to customers directly',
          icon: AppAssets.deliveryIcon,
          isToggled: controller.deliveryAvailable.value,
          onChanged: (val) => controller.deliveryAvailable.value = val,
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GOVERNMENT ID',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'National ID, Passport or Driving License',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        DashedUploadArea(
          title: 'Choose a file from your device',
          subtitle: 'Maximum 500 KB file size',
          onUpload: () {
            // TODO: Implement file picking logic
          },
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReviewCard(
          title: 'KITCHEN INFO',
          children: [
            _buildInfoRow('Kitchen Name', _getVal(controller.kitchenNameController.text)),
            const SizedBox(height: 12),
            _buildInfoRow('Owner', _getVal(controller.fullNameController.text)),
            const SizedBox(height: 12),
            _buildInfoRow('Phone', _getVal(controller.phoneNumberController.text)),
            const SizedBox(height: 12),
            _buildInfoRow('Cuisine', controller.selectedCuisines.isEmpty ? '—' : controller.selectedCuisines.join(', ')),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: 'OPERATING DETAILS',
          children: [
            _buildInfoRow('Mon - Fri', controller.monToFriEnabled.value ? '${controller.monToFriStartTime.value} - ${controller.monToFriEndTime.value}' : 'Closed', valueBold: true),
            const SizedBox(height: 12),
            _buildInfoRow('Saturday', controller.saturdayEnabled.value ? '${controller.saturdayStartTime.value} - ${controller.saturdayEndTime.value}' : 'Closed', valueBold: true),
            const SizedBox(height: 12),
            _buildInfoRow('Sunday', controller.sundayEnabled.value ? '${controller.sundayStartTime.value} - ${controller.sundayEndTime.value}' : 'Closed', valueBold: true),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(color: Color(0xFFE5E7EB), height: 1),
            ),
            _buildInfoRow('Pickup', controller.pickupAvailable.value ? 'Available' : 'Not available', valueColor: controller.pickupAvailable.value ? AppColors.primary : Colors.grey.shade600, valueBold: true),
            const SizedBox(height: 12),
            _buildInfoRow('Delivery', controller.deliveryAvailable.value ? 'Available' : 'Not available', valueColor: controller.deliveryAvailable.value ? AppColors.primary : Colors.grey.shade600, valueBold: true),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.priority_high, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Notice',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: 'Your kitchen will be reviewed by our team within '),
                          TextSpan(text: '2-3 business days', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          const TextSpan(text: '. You\'ll receive a notification once approved to start selling.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  String _getVal(String value) {
    return value.trim().isEmpty ? '—' : value.trim();
  }

  Widget _buildReviewCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool valueBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: valueBold ? FontWeight.w600 : FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

