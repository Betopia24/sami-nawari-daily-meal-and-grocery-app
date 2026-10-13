import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/profile_app_bar.dart';
import '../controllers/termandcondition_controller.dart';
import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';

class TermandconditionView extends GetView<TermandconditionController> {
  const TermandconditionView({super.key});

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
              'Terms & Conditions',
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
              'Welcome to Daily Meal & Grocery. By creating an account or using this application, you agree to the following Terms & Conditions. Please read them carefully before using the app.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('1. Acceptance of Terms'),
            _buildParagraph(
              'By accessing or using Daily Meal & Grocery, you agree to comply with these Terms & Conditions. If you do not agree with any part of these terms, please do not use the application.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('2. Account Responsibility'),
            _buildParagraph(
              'You are responsible for maintaining the confidentiality of your account information and password. You are also responsible for all activities that occur under your account.\nPlease ensure that the information you provide is accurate and up to date.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('3. Meal Planning & Recipes'),
            _buildParagraph(
              'The recipes, meal plans, cooking tips, and nutrition information provided within the app are for general informational purposes only.\nUsers are responsible for verifying ingredients, allergies, dietary restrictions, and cooking instructions before preparing or consuming any meal.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('4. Grocery Lists'),
            _buildParagraph(
              'The grocery list feature is designed to help users organize their shopping activities.\nUsers are responsible for reviewing quantities, measurements, and shopping lists before making any purchases.\nThe application is not responsible for missing, incorrect, or incomplete grocery lists created by users.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('5. Family Sharing'),
            _buildParagraph(
              'Users may share grocery lists with invited family members.\nThe account owner is responsible for managing invitations and permissions.\nShared members may edit grocery lists only if permission has been granted by the list owner.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('6. Homemade Food Marketplace'),
            _buildParagraph(
              'Daily Meal & Grocery provides a platform where local home cooks and buyers can connect.\nThe application does not prepare, inspect or guarantee the quality, safety, freshness, or legality of any food offered by sellers.\nBuyers are encouraged to review seller ratings, descriptions, and food details before placing an order.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('7. Orders & Payments'),
            _buildParagraph(
              'Users may choose one of the available payment methods, including:',
            ),
            const SizedBox(height: 8),
            _buildBulletList([
              'Online Payment',
              'Cash on Pickup',
              'Cash on Delivery (where available)',
            ]),
            const SizedBox(height: 12),
            _buildParagraph(
              'Orders cannot always be canceled after the seller has started preparing the food.\nPayment disputes between buyers and sellers should be resolved according to the platform\'s policies.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('8. Pickup & Delivery'),
            _buildParagraph(
              'Some sellers may offer self-pickup only, while others may provide local delivery.\nDelivery times are estimated and may vary depending on the seller\'s availability and circumstances.\nThe platform is not responsible for delays caused by weather, traffic, or unforeseen events.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('9. Seller Responsibilities'),
            _buildParagraph('Sellers are responsible for:'),
            const SizedBox(height: 8),
            _buildBulletList([
              'Providing accurate food descriptions',
              'Maintaining food quality and hygiene',
              'Preparing orders within the stated preparation time',
              'Updating order status promptly',
              'Delivering orders safely when delivery is offered',
            ]),
            const SizedBox(height: 24),

            _buildSectionTitle('10. Buyer Responsibilities'),
            _buildParagraph('Buyers agree to:'),
            const SizedBox(height: 8),
            _buildBulletList([
              'Provide accurate delivery or pickup information',
              'Arrive on time for self-pickup orders',
              'Treat sellers respectfully',
              'Complete payments as selected during checkout',
              'Leave honest reviews based on their experience',
            ]),
            const SizedBox(height: 24),

            _buildSectionTitle('11. Nutrition Information'),
            _buildParagraph(
              'Nutrition tips and educational content are provided for informational purposes only.\nThey should not be considered medical advice, diagnosis, or treatment.\nPlease consult a qualified healthcare professional before making significant dietary changes.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('12. User Conduct'),
            _buildParagraph('Users must not:'),
            const SizedBox(height: 8),
            _buildBulletList([
              'Upload false or misleading information',
              'Use offensive or abusive language',
              'Post inappropriate content',
              'Attempt fraudulent transactions',
              'Violate applicable laws',
              'Misuse the platform or other users',
            ]),
            const SizedBox(height: 12),
            _buildParagraph(
              'Accounts found violating these rules may be suspended or permanently removed.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('13. Ratings & Reviews'),
            _buildParagraph(
              'Users may leave reviews based on genuine experiences.\nFalse, abusive, or misleading reviews may be removed at the platform\'s discretion.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('14. Privacy'),
            _buildParagraph(
              'Your personal information is handled according to our Privacy Policy.\nWe do not sell your personal information to third parties.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('15. Limitation of Liability'),
            _buildParagraph(
              'Daily Meal & Grocery acts as a platform connecting buyers and home food sellers.\nWe are not responsible for food quality, allergies, health issues, or disputes arising from transactions between users.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('16. Changes to These Terms'),
            _buildParagraph(
              'We may update these Terms & Conditions from time to time.\nContinued use of the application after updates indicates your acceptance of the revised terms.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('17. Contact Us'),
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
