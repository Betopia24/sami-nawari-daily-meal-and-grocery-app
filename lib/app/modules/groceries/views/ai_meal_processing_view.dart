import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../widgets/custom_back_button.dart';
import '../widgets/processing_checklist.dart';
import '../widgets/meal_idea_card.dart';
import 'inspirationmealdetails_view.dart';

class AiMealProcessingView extends StatefulWidget {
  const AiMealProcessingView({super.key});

  @override
  State<AiMealProcessingView> createState() => _AiMealProcessingViewState();
}

class _AiMealProcessingViewState extends State<AiMealProcessingView> {
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isProcessing ? _buildProcessingScreen() : _buildResultsScreen(),
        ),
      ),
    );
  }

  Widget _buildProcessingScreen() {
    return Container(
      key: const ValueKey('processing'),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: const BoxDecoration(
              color: Color(0xFFE5F3EB),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome, color: AppColors.primary, size: 40.sp),
          ),
          SizedBox(height: 32.h),
          Text(
            'Creating meal ideas for you...',
            style: GoogleFonts.outfit(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            "We're analyzing your pantry items and\nrecent purchases.",
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 48.h),
          const ProcessingChecklist(),
          SizedBox(height: 24.h),
          Text(
            "This may take a few seconds...",
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
    return Container(
      key: const ValueKey('results'),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Row(
            children: [
              const CustomBackButton(),
              SizedBox(width: 16.w),
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 24.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal Inspiration',
                      style: GoogleFonts.outfit(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Based on what you have and your\nrecent purchases',
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: ListView(
              children: [
                  GestureDetector(
                    onTap: () => Get.to(() => const InspirationmealdetailsView()),
                    child: const MealIdeaCard(
                      title: 'Creamy Tomato Pasta',
                      timeInfo: '20 min • Easy',
                      usageInfo: 'Uses 3 of your items',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const InspirationmealdetailsView()),
                    child: const MealIdeaCard(
                      title: 'Chicken Fried Rice',
                      timeInfo: '25 min • Easy',
                      usageInfo: 'Uses 5 of your items',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const InspirationmealdetailsView()),
                    child: const MealIdeaCard(
                      title: 'Egg & Avocado Toast',
                      timeInfo: '10 min • Easy',
                      usageInfo: 'Uses 3 of your items',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const InspirationmealdetailsView()),
                    child: const MealIdeaCard(
                      title: 'Coconut Chicken Curry',
                      timeInfo: '30 min • Medium',
                      usageInfo: 'Uses 4 of your items',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const InspirationmealdetailsView()),
                    child: const MealIdeaCard(
                      title: 'Salmon & Veggie Bowl',
                      timeInfo: '20 min • Medium',
                      usageInfo: 'Uses 4 of your items',
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
