import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:share_plus/share_plus.dart';

class ShareViaBottomSheet extends StatelessWidget {
  const ShareViaBottomSheet({super.key});

  void _share() {
    Get.back();
    Share.share(
      AppStrings.shareAppMessage,
      subject: AppStrings.shareAppSubject,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Share Via',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildShareOption(
                  icon: Icons.chat,
                  iconColor: AppColors.socialWhatsApp, // WhatsApp Green
                  title: 'WhatsApp',
                  onTap: _share,
                ),
                _buildDivider(),
                _buildShareOption(
                  icon: Icons.facebook,
                  iconColor: AppColors.socialFacebook, // Facebook Blue
                  title: 'Facebook',
                  onTap: _share,
                ),
                _buildDivider(),
                _buildShareOption(
                  icon: Icons.message,
                  iconColor: AppColors.socialiMessage, // iMessage Green
                  title: 'Messages',
                  onTap: _share,
                ),
                _buildDivider(),
                _buildShareOption(
                  icon: Icons.camera_alt,
                  iconColor: AppColors.socialInstagram, // Instagram Pink/Red
                  title: 'Instagram',
                  onTap: _share,
                ),
                _buildDivider(),
                _buildShareOption(
                  icon: Icons.email,
                  iconColor: AppColors.socialEmail, // Mail Blue
                  title: 'Email',
                  onTap: _share,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
      indent: 16,
      endIndent: 16,
    );
  }
}
