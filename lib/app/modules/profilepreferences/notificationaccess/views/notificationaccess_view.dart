import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/notificationaccess_controller.dart';
import '../../widgets/animated_notification_header.dart';
import '../../widgets/preference_title_section.dart';
import '../../widgets/preference_option_card.dart';

class NotificationaccessView extends GetView<NotificationaccessController> {
  const NotificationaccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AnimatedNotificationHeader(),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PreferenceTitleSection(
                          title: 'Turn on notifications',
                          subtitle:
                              'We\'ll let you know when new meals are available, when your order is ready, and more.',
                        ),
                        const SizedBox(height: 24),

                        // Cards
                        ...controller.notificationOptions.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final option = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  index ==
                                      controller.notificationOptions.length - 1
                                  ? 0
                                  : 16.0,
                            ),
                            child: PreferenceOptionCard(
                              iconPath: option['iconPath']!,
                              title: option['title']!,
                              subtitle: option['subtitle']!,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),

                // Fixed Bottom Buttons
                Container(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 32.0,
                    top: 16.0,
                  ),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: 'Allow Notifications',
                        onPressed: controller.allowNotification,
                        showArrow: false,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: TextButton(
                          onPressed: controller.skip,
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.backgroundGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Not Now',
                            style: GoogleFonts.outfit(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
