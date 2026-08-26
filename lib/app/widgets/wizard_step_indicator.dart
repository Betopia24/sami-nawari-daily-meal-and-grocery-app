import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/app_colors.dart';

class WizardStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const WizardStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        // Even indices are circles (0, 2, 4)
        // Odd indices are lines (1, 3)
        if (index % 2 == 0) {
          int stepIndex = (index / 2).floor() + 1;
          bool isActive = stepIndex <= currentStep;
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.primary : const Color(0xFFEFEFEF),
            ),
            child: Center(
              child: Text(
                stepIndex.toString(),
                style: GoogleFonts.outfit(
                  color: isActive ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        } else {
          int stepIndexBeforeLine = (index / 2).floor() + 1;
          bool isActive = stepIndexBeforeLine < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              color: isActive ? AppColors.primary : const Color(0xFFEFEFEF),
            ),
          );
        }
      }),
    );
  }
}
