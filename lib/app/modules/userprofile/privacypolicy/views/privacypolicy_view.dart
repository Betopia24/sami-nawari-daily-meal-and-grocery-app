import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/profile_app_bar.dart';
import '../controllers/privacypolicy_controller.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class PrivacypolicyView extends GetView<PrivacypolicyController> {
  const PrivacypolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: const ProfileAppBar(title: ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Last Updated : August 2026',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'At Daily Meal & Grocery, we value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, store, and protect your information when you use our application.\n\nBy using the app, you agree to the practices described in this Privacy Policy.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('1. Information We Collect'),
            _buildParagraph(
              'To provide our services, we may collect the following information:',
            ),
            const SizedBox(height: 12),
            _buildSubSectionTitle('Personal Information:'),
            _buildBulletList([
              'Full Name',
              'Email Address',
              'Phone Number',
              'Profile Picture (Optional)',
              'Delivery Address',
              'Preferred Language',
              'Account Credentials',
              'Usage Information',
            ]),
            const SizedBox(height: 12),
            _buildParagraph('We may collect information such as:'),
            const SizedBox(height: 8),
            _buildBulletList([
              'Food Preferences',
              'Grocery Lists',
              'Saved Recipes',
              'Favorite Sellers',
              'Order History',
              'Nutrition Preferences',
              'Family Sharing Activities',
            ]),
            const SizedBox(height: 12),
            _buildParagraph(
              'This information helps us improve your experience within the application.',
            ),
            const SizedBox(height: 16),
            _buildSubSectionTitle('Location Information:'),
            _buildParagraph(
              'With your permission, we may access your device location to:',
            ),
            const SizedBox(height: 8),
            _buildBulletList([
              'Discover nearby homemade food sellers',
              'Show local food recommendations',
              'Improve delivery and find easy experiences',
            ]),
            const SizedBox(height: 12),
            _buildParagraph(
              'Location access is optional and can be disabled from your device settings.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('2. How We Use Your Information'),
            _buildParagraph('We use your information to:'),
            const SizedBox(height: 8),
            _buildBulletList([
              'Create and manage your account',
              'Process food orders',
              'Manage grocery lists',
              'Enable family grocery sharing',
              'Connect buyers with nearby home cooks',
              'Personalize recipes and recommendations',
              'Send important notifications',
              'Improve application performance',
              'Provide customer support',
            ]),
            const SizedBox(height: 24),

            _buildSectionTitle('3. Family Sharing'),
            _buildParagraph(
              'If you choose to share grocery lists with family members:',
            ),
            const SizedBox(height: 8),
            _buildBulletList([
              'Only invited members can access shared lists.',
              'You control who can view or edit your shared grocery lists.',
              'You may remove members at any time.',
            ]),
            const SizedBox(height: 12),
            _buildParagraph('We do not share your grocery lists publicly.'),
            const SizedBox(height: 24),

            _buildSectionTitle('4. Homemade Marketplace'),
            _buildParagraph(
              'If you register as a seller, the following information may be visible to buyers:',
            ),
            const SizedBox(height: 8),
            _buildBulletList([
              'Seller Name',
              'Kitchen Name',
              'Food Listings',
              'Ratings & Reviews',
              'Approximate Service Area',
              'Working Hours',
            ]),
            const SizedBox(height: 12),
            _buildParagraph(
              'Personal information such as your email address or phone number will not be publicly displayed unless you choose to share it.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('5. Payments'),
            _buildParagraph('The application may support:'),
            const SizedBox(height: 8),
            _buildBulletList([
              'Online Payments',
              'Cash on Pickup',
              'Cash on Delivery',
            ]),
            const SizedBox(height: 12),
            _buildParagraph(
              'Payment information is processed securely through trusted payment providers.\n\nDaily Meal & Grocery does not store your complete payment card details.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('6. Notifications'),
            _buildParagraph('We may send notifications related to:'),
            const SizedBox(height: 8),
            _buildBulletList([
              'Order Updates',
              'Grocery sharing',
              'Family Invitations',
              'Seller Updates',
              'Account Security',
              'Important Service Announcements',
            ]),
            const SizedBox(height: 12),
            _buildParagraph(
              'You can manage notification preferences from the Settings page.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('7. Data Security'),
            _buildParagraph(
              'We use appropriate security measures to protect your information against unauthorized access, loss, misuse, or disclosure.\n\nWhile we strive to protect your data, no internet-based system can be guaranteed to be 100% secure.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('8. Data Sharing'),
            _buildParagraph(
              'We do not sell your personal information.\n\nWe only share information when necessary to:',
            ),
            const SizedBox(height: 8),
            _buildBulletList([
              'Process your orders',
              'Connect buyers and sellers',
              'Enable family sharing',
              'Comply with legal obligations',
              'Improve platform functionality',
            ]),
            const SizedBox(height: 24),

            _buildSectionTitle('9. User Content'),
            _buildParagraph(
              'Any recipes, reviews, ratings, comments, or food listings you submit may be visible to other users based on the feature where they are posted.\n\nPlease avoid sharing sensitive personal information in public content.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('10. Children\'s Privacy'),
            _buildParagraph(
              'Daily Meal & Grocery is not intended for children under the age required by applicable law to create an account without parental consent.\n\nParents or guardians should supervise children\'s use of the application.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('11. Your Rights'),
            _buildParagraph('You may:'),
            const SizedBox(height: 8),
            _buildBulletList([
              'View your personal information',
              'Update your profile',
              'Change your password',
              'Manage your preferences',
              'Delete your account',
              'Request removal of your personal data where applicable',
            ]),
            const SizedBox(height: 24),

            _buildSectionTitle('12. Cookies & Analytics'),
            _buildParagraph(
              'To improve the user experience, we may use analytics and similar technologies to understand:',
            ),
            const SizedBox(height: 8),
            _buildBulletList([
              'App usage',
              'Feature performance',
              'Crash reports',
              'Device information',
            ]),
            const SizedBox(height: 12),
            _buildParagraph('These insights help us improve the application.'),
            const SizedBox(height: 24),

            _buildSectionTitle('13. Third-Party Services'),
            _buildParagraph(
              'The application may integrate trusted third-party services such as:',
            ),
            const SizedBox(height: 8),
            _buildBulletList([
              'Payment Providers',
              'Map Services',
              'Authentication Services',
              'Push Notification Services',
            ]),
            const SizedBox(height: 12),
            _buildParagraph(
              'These services have their own privacy policies governing how they handle your information.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('14. Changes to This Privacy Policy'),
            _buildParagraph(
              'We may update this Privacy Policy from time to time.\n\nAny significant changes will be communicated to you via the application.\n\nYour continued use of the app after updates means you accept the revised Privacy Policy.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('15. Contact Us'),
            _buildParagraph(
              'If you have any questions about this Privacy Policy or how your information is handled, please contact us through the Help & Support section within the application.',
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 13,
        color: Colors.grey.shade700,
        height: 1.5,
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
