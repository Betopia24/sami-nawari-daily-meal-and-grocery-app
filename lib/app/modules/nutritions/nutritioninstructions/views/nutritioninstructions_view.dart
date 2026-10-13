import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/ai_insight_card.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/focus_list_card.dart';
import '../../../../widgets/food_chips_card.dart';
import '../controllers/nutritioninstructions_controller.dart';

class NutritioninstructionsView extends GetView<NutritioninstructionsController> {
  const NutritioninstructionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final instruction = controller.instruction;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  CustomBackButton(onTap: () => Get.back()),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Insight',
                          style: GoogleFonts.outfit(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: const Color(0xFFE2EBE5)),
            
            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AiInsightCard(insightText: instruction.aiInsight),
                    SizedBox(height: 24.h),
                    
                    FocusListCard(
                      title: 'Why This Plan?',
                      items: instruction.whyThisPlanItems,
                    ),
                    SizedBox(height: 24.h),
                    
                    FocusListCard(
                      title: 'What to Focus on',
                      items: instruction.focusItems,
                    ),
                    SizedBox(height: 24.h),
                    
                    FoodChipsCard(
                      title: 'Foods to Eat',
                      icon: Icons.check_circle,
                      themeColor: AppColors.primary,
                      chipBackgroundColor: const Color(0xFFF4F9F6),
                      foods: instruction.foodsToEat,
                    ),
                    SizedBox(height: 24.h),
                    
                    FoodChipsCard(
                      title: 'Foods to Avoid',
                      icon: Icons.cancel_outlined,
                      themeColor: const Color(0xFFFF4B4B), // Red
                      chipBackgroundColor: const Color(0xFFFFF0F0),
                      foods: instruction.foodsToAvoid,
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
