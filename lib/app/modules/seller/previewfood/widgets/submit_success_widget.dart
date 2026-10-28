import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/primary_button.dart';

class SubmitSuccessWidget extends StatefulWidget {
  const SubmitSuccessWidget({super.key});

  @override
  State<SubmitSuccessWidget> createState() => _SubmitSuccessWidgetState();
}

class _SubmitSuccessWidgetState extends State<SubmitSuccessWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _baseSlideAnimation;
  late final Animation<double> _tick1ScaleAnimation;
  late final Animation<double> _tick2ScaleAnimation;
  late final Animation<double> _tick3ScaleAnimation;
  late final Animation<double> _bigTickScaleAnimation;
  late final Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Graphic falls in place with a bounce
    _baseSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
    ));

    // Tick 1
    _tick1ScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.55, curve: Curves.elasticOut),
      ),
    );

    // Tick 2
    _tick2ScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.65, curve: Curves.elasticOut),
      ),
    );

    // Tick 3
    _tick3ScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.75, curve: Curves.elasticOut),
      ),
    );

    // Big Tick
    _bigTickScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 0.9, curve: Curves.elasticOut),
      ),
    );

    // Text and card fade in
    _contentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 120),
                      
                      // Animated SVG Group
                      SlideTransition(
                        position: _baseSlideAnimation,
                        child: FadeTransition(
                          // Simple fade-in tied to the first part of animation
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: const Interval(0.0, 0.2),
                            )
                          ),
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Stack(
                              children: [
                                SvgPicture.string(_svgBase, width: 120, height: 120),
                                ScaleTransition(
                                  scale: _tick1ScaleAnimation,
                                  child: SvgPicture.string(_svgTick1, width: 120, height: 120),
                                ),
                                ScaleTransition(
                                  scale: _tick2ScaleAnimation,
                                  child: SvgPicture.string(_svgTick2, width: 120, height: 120),
                                ),
                                ScaleTransition(
                                  scale: _tick3ScaleAnimation,
                                  child: SvgPicture.string(_svgTick3, width: 120, height: 120),
                                ),
                                ScaleTransition(
                                  scale: _bigTickScaleAnimation,
                                  child: SvgPicture.string(_svgBigTick, width: 120, height: 120),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      FadeTransition(
                        opacity: _contentFadeAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(_contentFadeAnimation),
                          child: Column(
                            children: [
                              Text(
                                'Food Submitted!',
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Your food listing has been submitted\nfor admin review.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'What happens next?',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildStepText('1.', 'Admin will review your food listing.'),
                                    const SizedBox(height: 12),
                                    _buildStepText('2.', 'You will get notified once it\'s approved.'),
                                    const SizedBox(height: 12),
                                    _buildStepText('3.', 'After Approved, it will be visible to customers.'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Button
            FadeTransition(
              opacity: _contentFadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(24),
                color: const Color(0xFFFAF9F8),
                child: PrimaryButton(
                  text: 'Back to Profile',
                  onPressed: () {
                    Get.offAllNamed(Routes.navbar, arguments: {'tab': 4});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepText(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// Split SVGs for sequential animation

const String _svgBase = '''
<svg width="96" height="96" viewBox="0 0 96 96" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M65.4921 87.7475H10.053C7.78485 87.7475 5.94629 85.9053 5.94629 83.6329V13.4565C5.94629 11.1841 7.78485 9.3418 10.053 9.3418H65.4921C67.7602 9.3418 69.5988 11.1841 69.5988 13.4565V83.6329C69.5988 85.9053 67.7602 87.7475 65.4921 87.7475Z" fill="white"/>
<path d="M13.1211 9.35451C13.1211 9.35 13.7362 9.34631 13.7364 9.3418H10.053C7.78506 9.3418 5.94629 11.1841 5.94629 13.4565V83.6329C5.94629 85.9053 7.78485 87.7475 10.053 87.7475H13.1211V9.35451Z" fill="white"/>
<path d="M51.1227 90.8244H10.0531C6.09312 90.8244 2.87158 87.5986 2.87158 83.6334V13.4568C2.87158 9.49168 6.09333 6.26562 10.0531 6.26562H14.0876V12.4187H10.0531C9.48409 12.4187 9.02133 12.8843 9.02133 13.4568V83.6332C9.02133 84.2055 9.48409 84.6712 10.0531 84.6712H51.1227V90.8244Z" fill="#3A8F5C"/>
<path d="M66.5239 47.7246H72.6737V53.204H66.5239V47.7246Z" fill="#3A8F5C"/>
<path d="M72.6737 43.0074H66.5239V13.4568C66.5239 12.8843 66.0611 12.4187 65.4921 12.4187H62.4076V6.26564H65.4921C69.4521 6.26564 72.6737 9.49149 72.6737 13.4568V43.0074ZM49.4825 0H26.0626C22.3325 0 19.2979 3.03631 19.2979 6.76821V11.7284C19.2979 15.4605 22.3325 18.4966 26.0626 18.4966H49.4825C53.2125 18.4966 56.2472 15.4603 56.2472 11.7284V6.76821C56.2474 3.03631 53.2127 0 49.4825 0ZM38.8047 50.1276H61.0043V56.2806H38.8047V50.1276ZM38.8047 31.6119H61.0043V37.7649H38.8047V31.6119Z" fill="#3A8F5C"/>
<path d="M56.9809 73.3355C55.4363 82.2803 61.4283 90.8352 70.3645 92.4434C79.3007 94.0516 87.7971 88.1043 89.3417 79.1595C90.8863 70.2147 84.8943 61.6598 75.9581 60.0516C67.0219 58.4434 58.5255 64.3907 56.9809 73.3355Z" fill="#3A8F5C"/>
<path d="M63.7456 73.3355C64.9175 66.5496 70.0915 61.4926 76.4219 60.1472C76.2675 60.1148 76.1142 60.0797 75.9581 60.0516C67.0219 58.4434 58.5255 64.3907 56.9809 73.3355C55.4363 82.2803 61.4283 90.8352 70.3643 92.4434C72.4509 92.8209 74.591 92.7885 76.6652 92.3478C67.9879 90.531 62.2279 82.1238 63.7456 73.3355Z" fill="#3A8F5C"/>
<path d="M73.3893 95.9993C62.5054 95.9993 53.6509 87.1607 53.6509 76.2965C53.6509 65.4323 62.5054 56.5938 73.3893 56.5938C84.2732 56.5938 93.1278 65.4325 93.1278 76.2965C93.1278 87.1605 84.2732 95.9993 73.3893 95.9993ZM73.3893 62.7468C65.8964 62.7468 59.8006 68.8251 59.8006 76.2965C59.8006 83.7679 65.8964 89.8463 73.3893 89.8463C80.8823 89.8463 86.9781 83.7679 86.9781 76.2965C86.9781 68.8251 80.8823 62.7468 73.3893 62.7468Z" fill="#3A8F5C"/>
<path d="M38.8049 68.6423H48.1752V74.7953H38.8049V68.6423Z" fill="#3A8F5C"/>
</svg>
''';

const String _svgTick1 = '''
<svg width="96" height="96" viewBox="0 0 96 96" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M19.5317 40.5826L13.5752 34.4936L17.9701 30.1896L21.6566 33.9582L30.51 24.3008L35.0423 28.46L23.9953 40.5104C22.6952 41.7923 21.3229 41.8126 19.5317 40.5826Z" fill="#3A8F5C"/>
</svg>
''';

const String _svgTick2 = '''
<svg width="96" height="96" viewBox="0 0 96 96" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M19.5317 59.2468L13.5752 53.1578L17.9701 48.854L21.6566 52.6226L30.51 42.9652L35.0423 47.1244L23.9953 59.1748C22.6952 60.4565 21.3229 60.4766 19.5317 59.2468Z" fill="#3A8F5C"/>
</svg>
''';

const String _svgTick3 = '''
<svg width="96" height="96" viewBox="0 0 96 96" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M19.5317 77.7057L13.5752 71.6167L17.9701 67.3127L21.6566 71.0813L30.51 61.4239L35.0423 65.583L23.9953 77.6335C22.6952 78.9153 21.3229 78.9357 19.5317 77.7057Z" fill="#3A8F5C"/>
</svg>
''';

const String _svgBigTick = '''
<svg width="96" height="96" viewBox="0 0 96 96" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M64 76L70 82L82 70" stroke="white" stroke-width="4" stroke-linejoin="round"/>
</svg>
''';
