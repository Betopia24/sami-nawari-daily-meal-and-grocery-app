import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/dashed_border_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../../widgets/profile_app_bar.dart';
import '../../widgets/profile_bottom_button.dart';
import '../../widgets/allergy_grid_card.dart';
import '../controllers/alergiesandintolerence_controller.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class AlergiesandintolerenceView
    extends GetView<AlergiesandintolerenceController> {
  const AlergiesandintolerenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: 'Allergies & Intolerances'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select everything that applies',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.allAllergies.length,
                itemBuilder: (context, index) {
                  final allergy = controller.allAllergies[index];
                  return Obx(() {
                    final isSelected = controller.selectedAllergies
                        .toList()
                        .contains(allergy.id);
                    return AllergyGridCard(
                      title: allergy.title,
                      emoji: allergy.emoji,
                      severity: allergy.severity,
                      isSelected: isSelected,
                      onTap: () => controller.toggleAllergy(allergy.id),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'CUSTOM ALLERGENS',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            DashedBorderButton(
              text: 'Add custom allergen',
              onTap: () => _showAddCustomBottomSheet(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: ProfileBottomButton(
        text: 'Save Allergies',
        onPressed: controller.saveAllergies,
      ),
    );
  }

  void _showAddCustomBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Custom Allergen',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: controller.customNameController,
                label: 'Allergen Name',
                hint: 'e.g. Strawberry',
                prefixIcon: AppAssets.searchIcon,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.customEmojiController,
                label: 'Emoji',
                hint: 'e.g. 🍓',
                prefixIcon: AppAssets.searchIcon,
              ),
              const SizedBox(height: 8),
              Text(
                'Tolerance Level',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Common', 'Moderate', 'Severe'].map((level) {
                    final isSelected = controller.customSeverity.value == level;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.customSeverity.value = level,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE8F5E9)
                                : Colors.grey.shade100,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF4CAF50)
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            level,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFF2E7D32)
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Add Allergen',
                onPressed: controller.addCustomAllergen,
                showArrow: false,
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
