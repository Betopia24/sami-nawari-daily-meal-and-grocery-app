import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({super.key, this.currentStep = 0});

  @override
  Widget build(BuildContext context) {
    final steps = ['Review', 'Delivery', 'Address', 'Payment'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isCompleted = index <= currentStep;
          final color = isCompleted ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5);

          return Expanded(
            child: Column(
              children: [
                Text(
                  steps[index],
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w500,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 4,
                    right: index == steps.length - 1 ? 0 : 4,
                  ),
                  height: 3,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primary : AppColors.borderGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
