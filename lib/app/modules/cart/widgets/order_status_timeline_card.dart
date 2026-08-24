import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';

class OrderStatusStep {
  final String title;
  final String time;
  final bool isCompleted;

  OrderStatusStep({
    required this.title,
    required this.time,
    this.isCompleted = false,
  });
}

class OrderStatusTimelineCard extends StatelessWidget {
  final List<OrderStatusStep> steps;
  final Widget? bottomActions;

  const OrderStatusTimelineCard({
    super.key,
    required this.steps,
    this.bottomActions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Order Status',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.borderGrey),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: List.generate(steps.length, (index) {
                final step = steps[index];
                final isLast = index == steps.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 4),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: step.isCompleted
                                ? AppColors.primary
                                : const Color(0xFFA1C6AD), // Light green for pending
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 1,
                            height: 40,
                            color: const Color(0xFFE5E5E5), // Faint grey line
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            step.time,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (!isLast) const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          if (bottomActions != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 4),
              child: bottomActions!,
            ),
          ],
        ],
      ),
    );
  }
}
