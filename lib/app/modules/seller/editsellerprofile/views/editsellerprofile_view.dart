import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/toggle_setting_card.dart';
import '../../../../widgets/custom_time_dropdown.dart';
import '../../../../widgets/selectable_chip_group.dart';
import '../../../../widgets/primary_button.dart';
import '../../../userprofile/widgets/profile_app_bar.dart';
import '../../../userprofile/widgets/profile_section_card.dart';
import '../../../userprofile/widgets/profile_text_field.dart';
import '../../../userprofile/widgets/profile_bottom_button.dart';
import '../controllers/editsellerprofile_controller.dart';

class EditsellerprofileView extends GetView<EditsellerprofileController> {
  const EditsellerprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPhotoSection(),
            const SizedBox(height: 32),
            _buildSectionTitle('BASIC INFO'),
            const SizedBox(height: 12),
            ProfileSectionCard(
              children: [
                ProfileTextField(
                  label: 'Kitchen/Business Name',
                  controller: controller.kitchenNameController,
                ),
                ProfileTextField(
                  label: 'Your Name',
                  controller: controller.fullNameController,
                ),
                ProfileTextField(
                  label: 'Brief Description',
                  controller: controller.descriptionController,
                  showBottomDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('CUISINE TYPE'),
            const SizedBox(height: 12),
            ProfileSectionCard(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() => Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          ...controller.selectedCuisines.map((cuisine) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    cuisine,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      final updated = Set<String>.from(controller.selectedCuisines);
                                      updated.remove(cuisine);
                                      controller.onCuisinesChanged(updated.toList());
                                    },
                                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () => _openCuisineSelector(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                '+ Add More',
                                style: GoogleFonts.outfit(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('CONTACT INFO'),
            const SizedBox(height: 12),
            ProfileSectionCard(
              children: [
                ProfileTextField(
                  label: 'Email',
                  controller: controller.emailController,
                ),
                ProfileTextField(
                  label: 'Phone',
                  controller: controller.phoneController,
                  showBottomDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('LOCATION INFO'),
            const SizedBox(height: 12),
            ProfileSectionCard(
              children: [
                ProfileTextField(
                  label: 'Address',
                  controller: controller.locationController,
                  showBottomDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('WORKING HOURS'),
            const SizedBox(height: 12),
            Obx(() => ToggleSettingCard(
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
            )),
            const SizedBox(height: 12),
            Obx(() => ToggleSettingCard(
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
            )),
            const SizedBox(height: 12),
            Obx(() => ToggleSettingCard(
              title: 'Sunday',
              isToggled: controller.sundayEnabled.value,
              onChanged: (val) => controller.sundayEnabled.value = val,
            )),
            const SizedBox(height: 24),
            _buildSectionTitle('DELIVERY METHOD'),
            const SizedBox(height: 12),
            Obx(() => ToggleSettingCard(
              title: 'Pickup Available',
              subtitle: 'Customers can pick up from your location',
              icon: AppAssets.pickupIcon,
              isToggled: controller.pickupSupportEnabled.value,
              onChanged: (val) => controller.pickupSupportEnabled.value = val,
            )),
            const SizedBox(height: 12),
            Obx(() => ToggleSettingCard(
              title: 'Delivery Available',
              subtitle: 'You deliver to customers directly',
              icon: AppAssets.deliveryIcon,
              isToggled: controller.deliverySupportEnabled.value,
              onChanged: (val) => controller.deliverySupportEnabled.value = val,
            )),
            const SizedBox(height: 120), // Bottom padding for button
          ],
        ),
      ),
      bottomSheet: ProfileBottomButton(
        text: 'Save Changes',
        onPressed: controller.saveChanges,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Center(
      child: GestureDetector(
        onTap: controller.pickImage,
        child: Column(
          children: [
            Stack(
              children: [
                Obx(
                  () {
                    ImageProvider? provider;
                    if (controller.selectedImage.value != null) {
                      provider = FileImage(controller.selectedImage.value!);
                    } else if (controller.existingImageUrl.value.isNotEmpty) {
                      provider = NetworkImage(controller.existingImageUrl.value);
                    }

                    return CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      backgroundImage: provider,
                      child: provider == null
                          ? const Icon(
                              Icons.store,
                              size: 40,
                              color: AppColors.primary,
                            )
                          : null,
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Change Photo',
              style: GoogleFonts.outfit(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCuisineSelector(BuildContext context) {
    final customCuisineController = TextEditingController();

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Cuisines',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Get.back(),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Choose all cuisines that best describe your kitchen dishes.',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              // Add custom cuisine row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      child: TextField(
                        controller: customCuisineController,
                        decoration: InputDecoration(
                          hintText: 'Add new cuisine (e.g. Turkish)',
                          hintStyle: GoogleFonts.outfit(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        style: GoogleFonts.outfit(fontSize: 14),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            controller.addCustomCuisine(value);
                            customCuisineController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final val = customCuisineController.text.trim();
                      if (val.isNotEmpty) {
                        controller.addCustomCuisine(val);
                        customCuisineController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Obx(() => SelectableChipGroup(
                    options: controller.availableCuisines,
                    selectedOptions: controller.selectedCuisines.toList(),
                    onChanged: controller.onCuisinesChanged,
                  )),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Done',
                onPressed: () => Get.back(),
                showArrow: false,
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
