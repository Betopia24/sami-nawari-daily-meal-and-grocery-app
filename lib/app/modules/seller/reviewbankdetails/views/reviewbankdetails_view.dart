import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/reviewbankdetails_controller.dart';

class ReviewbankdetailsView extends GetView<ReviewbankdetailsController> {
  const ReviewbankdetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: const SizedBox(), // No back button on this screen, but keeping space if needed
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const AnimatedSearchGraphic(),
                    const SizedBox(height: 32),
                    Text(
                      'Review Your Details',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please review your bank account information\nbefore adding.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF6B7280),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Bank Name', 'City Bank Limited', true),
                          _buildDetailRow('Account Holder Name', 'Rafiul Islam', true),
                          _buildDetailRow('Account Number', '1234 5678 9012 3456', true),
                          _buildDetailRow('Account Type', 'Savings Account', true),
                          _buildDetailRow('Currency', 'USD - US Dollar', false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: controller.editDetails,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Edit Details',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Add Bank Account',
                    onPressed: controller.addBankAccount,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool showBorder) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedSearchGraphic extends StatefulWidget {
  const AnimatedSearchGraphic({super.key});

  @override
  State<AnimatedSearchGraphic> createState() => _AnimatedSearchGraphicState();
}

class _AnimatedSearchGraphicState extends State<AnimatedSearchGraphic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // A subtle pulse: 1.0 to 1.05
          double scale = 1.0 + (0.05 * (0.5 - (_animation.value - 0.5).abs())); 
          // Scale peaks when _animation.value is 0.5 (middle of sweep)
          if (_animation.value < 0.0 || _animation.value > 1.0) {
             scale = 1.0;
          }

          return Transform.scale(
            scale: scale,
            child: Stack(
              children: [
                SvgPicture.asset(
                  AppAssets.reviewBankDetailsGraphic,
                  width: 120,
                  height: 120,
                ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              // _animation goes from -1.0 to 2.0. Let's map it to 0 to 120.
              // Actually let's just make it a simple 0 to 1 animation.
              double yPos = (_animation.value.clamp(0.0, 1.0)) * 120.0;
              return Positioned(
                top: yPos,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: (_animation.value >= 0.0 && _animation.value <= 1.0) ? 1.0 : 0.0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A8F5C), // Primary color
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3A8F5C).withValues(alpha: 0.5),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
              ],
            ),
          );
        },
      ),
    );
  }
}
