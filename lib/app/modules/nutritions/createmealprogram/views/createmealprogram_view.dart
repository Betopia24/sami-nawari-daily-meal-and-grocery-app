import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../controllers/createmealprogram_controller.dart';

class CreatemealprogramView extends GetView<CreatemealprogramController> {
  const CreatemealprogramView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(onTap: () => Get.back()),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    
                    // Animated Graphic
                    const _FloatingGraphic(),
                    
                    SizedBox(height: 32.h),
                    
                    // Titles
                    Text(
                      'Create Your\nMeal Plan',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Tell us a little about yourself so we can\ncreate a plan that fits you perfectly.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    
                    SizedBox(height: 48.h),
                    
                    // Features List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeatureItem(
                              iconPath: 'assets/icons/alarmclock_icon.svg',
                              text: 'Personalized 1 month plan',
                            ),
                            SizedBox(height: 24.h),
                            _buildFeatureItem(
                              iconPath: 'assets/icons/aienhance_icon.svg',
                              text: 'AI-powered meal suggestions',
                            ),
                            SizedBox(height: 24.h),
                            _buildFeatureItem(
                              iconPath: 'assets/icons/focused_icon.svg',
                              text: 'Goal-focused nutrition guidance',
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            ),
            
            // Get Started Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: ElevatedButton(
                onPressed: controller.onGetStarted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required String iconPath, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          width: 24.sp,
        ),
        SizedBox(width: 16.w),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _FloatingGraphic extends StatefulWidget {
  const _FloatingGraphic();

  @override
  State<_FloatingGraphic> createState() => _FloatingGraphicState();
}

class _FloatingGraphicState extends State<_FloatingGraphic>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We add an entry scale animation as well
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation.value),
                child: child,
              );
            },
            child: child,
          ),
        );
      },
      child: Image.asset(
        'assets/graphics/mealplan_graphic_extracted.png',
        height: 160.h,
        fit: BoxFit.contain,
      ),
    );
  }
}
