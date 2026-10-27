import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../widgets/preference_title_section.dart';
import '../../widgets/question_pref_card.dart';
import '../../widgets/step_progress_indicator.dart';
import '../controllers/questionprefs_controller.dart';

class QuestionprefsView extends GetView<QuestionprefsController> {
  const QuestionprefsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (controller.currentStep.value > 0) {
                        controller.pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Get.back();
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderGrey),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.backArrowIcon,
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Step Indicator and Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => StepProgressIndicator(
                        currentStep: controller.currentStep.value,
                        totalSteps: controller.questions.length,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: controller.skip,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.outfit(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                top: 12.0,
                bottom: 24.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Obx(
                  () => Text(
                    'STEP ${controller.currentStep.value + 1} OF ${controller.questions.length}',
                    style: GoogleFonts.outfit(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),

            // PageView for Questions
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable swipe, rely on taps
                onPageChanged: (index) => controller.currentStep.value = index,
                itemCount: controller.questions.length,
                itemBuilder: (context, index) {
                  final question = controller.questions[index];
                  final options =
                      question['options'] as List<Map<String, dynamic>>;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PreferenceTitleSection(
                          title: question['title'],
                          subtitle: question['subtitle'],
                        ),
                        const SizedBox(height: 32),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: question['crossAxisCount'],
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: question['childAspectRatio'],
                              ),
                          itemCount: options.length,
                          itemBuilder: (context, optionIndex) {
                            final option = options[optionIndex];
                            return Obx(() {
                              final isSelected =
                                  question['getSelected'](controller) ==
                                  option['id'];
                              return QuestionPrefCard(
                                iconPathOrEmoji: option['icon']!,
                                title: option['title']!,
                                subtitle: option['subtitle']!,
                                isSelected: isSelected,
                                onTap: () => controller.selectOption(
                                  index,
                                  option['id']!,
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom text
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Tap any option to continue automatically',
                style: GoogleFonts.outfit(
                  color: AppColors.iconGrey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
