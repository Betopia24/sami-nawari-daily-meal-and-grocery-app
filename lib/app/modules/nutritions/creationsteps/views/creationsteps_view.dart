import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../widgets/custom_back_button.dart';
import '../../../../widgets/wizard_step_indicator.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/single_selection_card.dart';
import '../../../../widgets/multi_selection_card.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_dropdown_field.dart';

import '../controllers/creationsteps_controller.dart';

class CreationstepsView extends GetView<CreationstepsController> {
  const CreationstepsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Area
            Container(
              color: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomBackButton(
                        onTap: controller.previousStep,
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        'Create Meal Plan',
                        style: GoogleFonts.outfit(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Obx(() => WizardStepIndicator(
                        currentStep: controller.currentStep.value,
                        totalSteps: 4,
                      )),
                ],
              ),
            ),
            
            // Divider line
            Container(
              height: 1,
              width: double.infinity,
              color: const Color(0xFFEFEFEF),
            ),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Obx(() {
                  switch (controller.currentStep.value) {
                    case 1:
                      return _buildStep1();
                    case 2:
                      return _buildStep2();
                    case 3:
                      return _buildStep3();
                    case 4:
                      return _buildStep4();
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ),
            ),

            // Bottom Sticky Button
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.background,
              ),
              child: PrimaryButton(
                text: 'Continue',
                onPressed: controller.nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who is this meal plan for?',
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Choose who you\'re planning meals for.',
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32.h),
        
        SingleSelectionCard(
          title: 'Myself',
          subtitle: 'A plan for me',
          svgIcon: 'assets/icons/person_icon.svg',
          isSelected: controller.selectedPerson.value == 'Myself',
          onTap: () => controller.setPerson('Myself'),
        ),
        SizedBox(height: 16.h),
        SingleSelectionCard(
          title: 'My Child',
          subtitle: 'A plan for my child',
          svgIcon: 'assets/icons/children_icon.svg',
          isSelected: controller.selectedPerson.value == 'My Child',
          onTap: () => controller.setPerson('My Child'),
        ),
        SizedBox(height: 16.h),
        SingleSelectionCard(
          title: 'My Family',
          subtitle: 'A plan for my family',
          svgIcon: 'assets/icons/family_icon.svg',
          isSelected: controller.selectedPerson.value == 'My Family',
          onTap: () => controller.setPerson('My Family'),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell us about you',
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'This helps us personalize your plan better.',
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32.h),
        
        CustomTextField(
          label: 'Age*',
          hint: '25 Years',
          controller: controller.ageController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 24.h),
        
        CustomDropdownField<String>(
          label: 'Gender*',
          value: controller.selectedGender.value,
          items: controller.genderOptions.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e, style: GoogleFonts.outfit(fontSize: 16.sp)),
          )).toList(),
          onChanged: (val) {
            if (val != null) controller.setGender(val);
          },
        ),
        SizedBox(height: 32.h),
        
        Row(
          children: [
            Text(
              'Activity Level ',
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            Text(
              '(optional)',
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        
        SingleSelectionCard(
          title: 'Lightly Active',
          subtitle: 'Light exercise 1-3 days/week.',
          isSelected: controller.selectedActivity.value == 'Lightly Active',
          onTap: () => controller.setActivity('Lightly Active'),
        ),
        SizedBox(height: 16.h),
        SingleSelectionCard(
          title: 'Moderately Active',
          subtitle: 'Exercise 3-5 days/week.',
          isSelected: controller.selectedActivity.value == 'Moderately Active',
          onTap: () => controller.setActivity('Moderately Active'),
        ),
        SizedBox(height: 16.h),
        SingleSelectionCard(
          title: 'Very Active',
          subtitle: 'Hard exercise 6-7 days/week.',
          isSelected: controller.selectedActivity.value == 'Very Active',
          onTap: () => controller.setActivity('Very Active'),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your goal?',
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Select the goal you want to achieve',
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32.h),
        
        SingleSelectionCard(
          title: 'Lose Weight',
          subtitle: 'Support healthy weight loss',
          icon: Icons.monitor_weight_outlined,
          isSelected: controller.selectedGoal.value == 'Lose Weight',
          onTap: () => controller.setGoal('Lose Weight'),
        ),
        SizedBox(height: 16.h),
        SingleSelectionCard(
          title: 'Gain Weight',
          subtitle: 'Build muscle & healthy weight',
          icon: Icons.fitness_center_outlined,
          isSelected: controller.selectedGoal.value == 'Gain Weight',
          onTap: () => controller.setGoal('Gain Weight'),
        ),
        SizedBox(height: 16.h),
        SingleSelectionCard(
          title: 'Maintain Weight',
          subtitle: 'Stay fit & maintain weight',
          svgIcon: 'assets/icons/maintainweight_icon.svg',
          isSelected: controller.selectedGoal.value == 'Maintain Weight',
          onTap: () => controller.setGoal('Maintain Weight'),
        ),
        SizedBox(height: 16.h),
        SingleSelectionCard(
          title: 'Eat Healthier',
          subtitle: 'Build better eating habits',
          icon: Icons.restaurant_menu_outlined,
          isSelected: controller.selectedGoal.value == 'Eat Healthier',
          onTap: () => controller.setGoal('Eat Healthier'),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What kind of meals do you need?',
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Select all that apply',
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32.h),
        
        MultiSelectionCard(
          title: 'Everyday Meals',
          subtitle: 'Balanced meals for daily life',
          isSelected: controller.selectedMeals.contains('Everyday Meals'),
          onTap: () => controller.toggleMeal('Everyday Meals'),
        ),
        SizedBox(height: 16.h),
        MultiSelectionCard(
          title: 'Workday Meals',
          subtitle: 'Meals for work days',
          isSelected: controller.selectedMeals.contains('Workday Meals'),
          onTap: () => controller.toggleMeal('Workday Meals'),
        ),
        SizedBox(height: 16.h),
        MultiSelectionCard(
          title: 'Lunch Box',
          subtitle: 'Meals for tiffin/lunch box',
          isSelected: controller.selectedMeals.contains('Lunch Box'),
          onTap: () => controller.toggleMeal('Lunch Box'),
        ),
        SizedBox(height: 16.h),
        MultiSelectionCard(
          title: 'Child Friendly Meals',
          subtitle: 'Healthy meals for kids',
          isSelected: controller.selectedMeals.contains('Child Friendly Meals'),
          onTap: () => controller.toggleMeal('Child Friendly Meals'),
        ),
        SizedBox(height: 16.h),
        MultiSelectionCard(
          title: 'Quick & Easy Meals',
          subtitle: 'Simple & quick recipes',
          isSelected: controller.selectedMeals.contains('Quick & Easy Meals'),
          onTap: () => controller.toggleMeal('Quick & Easy Meals'),
        ),
        SizedBox(height: 16.h),
        MultiSelectionCard(
          title: 'Family Meals',
          subtitle: 'Meals for the whole family',
          isSelected: controller.selectedMeals.contains('Family Meals'),
          onTap: () => controller.toggleMeal('Family Meals'),
        ),
      ],
    );
  }
}
