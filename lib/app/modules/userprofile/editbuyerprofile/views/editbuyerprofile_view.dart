import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../widgets/gender_selection.dart';
import '../../widgets/profile_app_bar.dart';
import '../../widgets/profile_section_card.dart';
import '../../widgets/profile_text_field.dart';
import '../../widgets/profile_bottom_button.dart';
import '../controllers/editbuyerprofile_controller.dart';

class EditbuyerprofileView extends GetView<EditbuyerprofileController> {
  const EditbuyerprofileView({super.key});

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
                  label: 'Full Name',
                  controller: controller.fullNameController,
                ),
                ProfileTextField(
                  label: 'Username',
                  controller: controller.usernameController,
                ),
                ProfileTextField(
                  label: 'Bio',
                  controller: controller.bioController,
                  showBottomDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('CONTACT INFO'),
            const SizedBox(height: 12),
            ProfileSectionCard(
              children: [
                ProfileTextField(
                  label: 'Phone',
                  controller: controller.phoneController,
                  showBottomDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('PERSONAL'),
            const SizedBox(height: 12),
            ProfileSectionCard(
              children: [
                ProfileTextField(
                  label: 'Birthday',
                  hintText: 'YYYY-MM-DD',
                  controller: controller.birthdayController,
                  readOnly: true,
                  onTap: () => controller.pickBirthday(context),
                  trailing: SvgPicture.asset(
                    AppAssets.calendarIcon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Colors.grey.shade600,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Obx(
                  () => ProfileTextField(
                    label: 'Gender',
                    customInput: GenderSelection(
                      selectedGender: controller.selectedGender.value,
                      onChanged: controller.setGender,
                    ),
                  ),
                ),
                ProfileTextField(
                  label: 'Address',
                  controller: controller.addressController,
                  showBottomDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 130), // Space for bottom button
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => ProfileBottomButton(
          text: 'Save Changes',
          isLoading: controller.isLoading.value,
          onPressed: controller.saveChanges,
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
                    if (controller.profileImagePath.value != null) {
                      provider =
                          FileImage(File(controller.profileImagePath.value!));
                    } else if (controller.networkProfileImageUrl.value != null &&
                        controller
                            .networkProfileImageUrl.value!.trim().isNotEmpty) {
                      provider = NetworkImage(
                          controller.networkProfileImageUrl.value!);
                    }

                    return CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      backgroundImage: provider,
                      child: provider == null
                          ? SvgPicture.asset(
                              AppAssets.singlePersonIcon,
                              width: 40,
                              height: 40,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            )
                          : null,
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Change Photo',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade500,
        letterSpacing: 1.2,
      ),
    );
  }
}
