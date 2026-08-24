import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../widgets/primary_button.dart';

class LeaveReviewCard extends StatelessWidget {
  final int selectedRating;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;

  const LeaveReviewCard({
    super.key,
    required this.selectedRating,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leave a review',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              final rating = index + 1;
              final isSelected = rating <= selectedRating;
              return GestureDetector(
                onTap: () => onRatingChanged(rating),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : const Color(0xFFE5E5E5),
                    ),
                  ),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    size: 20,
                    color: isSelected ? AppColors.primary : const Color(0xFF9CA3AF),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'How was the food and the handover?',
                hintStyle: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Submit Review',
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
