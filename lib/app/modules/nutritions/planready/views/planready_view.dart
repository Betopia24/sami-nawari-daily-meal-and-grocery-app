import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/primary_button.dart';

import '../controllers/planready_controller.dart';

class PlanreadyView extends GetView<PlanreadyController> {
  const PlanreadyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Slightly off-white background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 32.h),
              // Graphic with animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.1, end: 1.0),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: -0.05, end: 0.05),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOutSine,
                  builder: (context, rotation, child) {
                    return Transform.rotate(
                      angle: rotation,
                      child: child,
                    );
                  },
                  child: TweenAnimationBuilder<double>(
                     tween: Tween(begin: 0.0, end: 1.0),
                     duration: const Duration(milliseconds: 1500),
                     curve: Curves.easeInOutSine,
                     builder: (context, scale, child) {
                       // Breathing animation
                       return Transform.scale(
                         scale: 1.0 + (0.05 * (scale > 0.5 ? 1.0 - scale : scale)),
                         child: child,
                       );
                     },
                     onEnd: () {
                        // We would ideally loop the breathing animation, but since TweenAnimationBuilder
                        // only fires once, we can just use a simple scale up elastic as the main effect
                        // To loop, we'd need an AnimationController. For a simple modern effect, 
                        // the initial elastic pop + subtle float is good. 
                        // I will simplify the breathing below if it gets complex.
                     },
                     child: SvgPicture.asset(
                       'assets/graphics/planready_graphic.svg',
                       width: 140.w,
                     ),
                  ),
                ),
              ),
              
              SizedBox(height: 48.h),
              
              Text(
                'Your Plan is Ready!',
                style: GoogleFonts.outfit(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your personalized 1 week meal plan is ready.\nLet\'s start your healthy journey!',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // Details Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFF3F3F3)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Goal', controller.goal.value),
                    const Divider(height: 1, color: Color(0xFFF3F3F3)),
                    _buildInfoRow('Duration', '1 week'),
                    const Divider(height: 1, color: Color(0xFFF3F3F3)),
                    _buildInfoRow('Start Date', _getFormattedDate()),
                    const Divider(height: 1, color: Color(0xFFF3F3F3)),
                    _buildInfoRow('Currency', 'USD - US Dollar'),
                  ],
                ),
              ),
              
                    SizedBox(height: 32.h), // Replaces Expanded space
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              child: Column(
                children: [
                  PrimaryButton(
                    text: "View Today's Meal Plan",
                    onPressed: controller.onViewMealPlan,
                    showArrow: false,
                  ),
                  SizedBox(height: 16.h),
                  PrimaryButton(
                    text: "Go to Home",
                    isOutlined: true,
                    onPressed: controller.onGoHome,
                    showArrow: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
  }
}
