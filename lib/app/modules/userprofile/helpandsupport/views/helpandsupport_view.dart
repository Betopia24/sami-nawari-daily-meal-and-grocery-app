import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/custom_switch_tab.dart';
import '../../widgets/profile_app_bar.dart';
import '../controllers/helpandsupport_controller.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class HelpandsupportView extends GetView<HelpandsupportController> {
  const HelpandsupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: 'Help & Support'),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomSwitchTab(
              controller: controller.tabController,
              tabs: const ['FAQ', 'Contact Us'],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [_buildFaqTab(), _buildContactUsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        _buildFaqItem(
          'How do I share a grocery list?',
          'Open any grocery list, tap the share icon in the top right, and enter the email address of the person you want to share with.',
          initiallyExpanded: true,
        ),
        _buildFaqItem(
          'Can I add my own recipes?',
          'Yes, you can easily add your own recipes by tapping the "+" button on the Recipes tab and entering the ingredients and steps.',
        ),
        _buildFaqItem(
          'How does the nearby food feature work?',
          'We use your location to find top-rated restaurants and grocery stores near you, showing distance and estimated delivery times.',
        ),
        _buildFaqItem(
          'How do I change my dietary preferences?',
          'Navigate to Profile > System Preferences > Dietary Preferences. From there, you can update your allergies, intolerances, and diet type.',
        ),
        _buildFaqItem(
          'Is my payment information secure?',
          'Absolutely. We use bank-level encryption and partner with industry-leading payment processors like Stripe to ensure your data is always safe.',
        ),
      ],
    );
  }

  Widget _buildFaqItem(
    String title,
    String? content, {
    bool initiallyExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: initiallyExpanded,
            title: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            iconColor: Colors.grey.shade600,
            collapsedIconColor: Colors.grey.shade400,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            childrenPadding: EdgeInsets.zero,
            children: content != null
                ? [
                    const Divider(height: 1, color: AppColors.divider),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        content,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  Widget _buildContactUsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        _buildContactItem(
          emoji: '💬',
          title: 'Live Chat',
          subtitle: 'Avg. response under 2 minutes',
          actionText: 'Start Chat',
          onTap: () {},
        ),
        _buildContactItem(
          emoji: '📧',
          title: 'Email Support',
          subtitle: 'support@dailymeal.app',
          actionText: 'Send Email',
          onTap: () {},
        ),
        _buildContactItem(
          emoji: '🐛',
          title: 'Report a Bug',
          subtitle: 'Help us improve the app',
          actionText: 'Report',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required String emoji,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.backgroundTertiary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textGreen, // Green text
              ),
            ),
          ),
        ],
      ),
    );
  }
}
