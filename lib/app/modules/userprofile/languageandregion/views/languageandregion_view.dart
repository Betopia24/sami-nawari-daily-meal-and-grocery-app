import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../widgets/profile_app_bar.dart';
import '../../widgets/profile_section_card.dart';
import '../../widgets/pill_toggle_group.dart';
import '../../widgets/profile_bottom_button.dart';
import '../../widgets/selection_dropdown.dart';
import '../controllers/languageandregion_controller.dart';

class LanguageandregionView extends GetView<LanguageandregionController> {
  const LanguageandregionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: 'Language & Region'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(
              () => SelectionDropdown(
                label: 'Language',
                value: controller.language.value,
                options: const [
                  'Select your language',
                  'English (US)',
                  'English (UK)',
                  'Español',
                  'Français',
                  'Deutsch',
                ],
                onChanged: (val) {
                  if (val != null) controller.setLanguage(val);
                },
              ),
            ),
            Obx(
              () => SelectionDropdown(
                label: 'Country',
                value: controller.country.value,
                options: const [
                  'Select your country',
                  'United States',
                  'United Kingdom',
                  'Canada',
                  'France',
                  'Australia',
                ],
                onChanged: (val) {
                  if (val != null) controller.setCountry(val);
                },
              ),
            ),
            Obx(
              () => SelectionDropdown(
                label: 'Time Zone',
                value: controller.timeZone.value,
                options: const [
                  'Select your time zone',
                  'America/New_York',
                  'America/Los_Angeles',
                  'Europe/London',
                  'Europe/Paris',
                  'Asia/Tokyo',
                  'Asia/Dubai',
                  'Australia/Sydney',
                ],
                onChanged: (val) {
                  if (val != null) controller.setTimeZone(val);
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'DISPLAY',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            ProfileSectionCard(
              children: [
                Obx(
                  () => PillToggleGroup(
                    label: 'Date Format',
                    options: const ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'],
                    selectedValue: controller.dateFormat.value,
                    onChanged: controller.setDateFormat,
                  ),
                ),
                Obx(
                  () => PillToggleGroup(
                    label: 'Time Format',
                    options: const ['12-hour (3:30 PM)', '24-hour (15:30)'],
                    selectedValue: controller.timeFormat.value,
                    onChanged: controller.setTimeFormat,
                  ),
                ),
                Obx(
                  () => PillToggleGroup(
                    label: 'Units',
                    options: const [
                      'Imperial (lb, oz, °F)',
                      'Metric (kg, g, °C)',
                    ],
                    selectedValue: controller.units.value,
                    onChanged: controller.setUnits,
                  ),
                ),
                Obx(
                  () => PillToggleGroup(
                    label: 'Currency',
                    options: const [
                      'USD (\$)',
                      'EUR (€)',
                      'GBP (£)',
                      'JPY (¥)',
                      'CAD (C\$)',
                      'AUD (A\$)',
                    ],
                    selectedValue: controller.currency.value,
                    onChanged: controller.setCurrency,
                    showBottomBorder: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProfileBottomButton(
        text: 'Save Changes',
        onPressed: controller.saveChanges,
      ),
    );
  }
}
