import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';

class StatSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitlePrefix;
  final String subtitleSuffix;
  final bool isPositive;

  const StatSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitlePrefix = '',
    required this.subtitleSuffix,
    this.isPositive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          if (subtitlePrefix.isNotEmpty)
            Row(
              children: [
                if (isPositive) ...[
                  const Icon(
                    Icons.arrow_upward,
                    color: AppColors.primary,
                    size: 12,
                  ),
                  const SizedBox(width: 2),
                ],
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: subtitlePrefix,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isPositive ? AppColors.primary : Colors.grey.shade500,
                      ),
                      children: [
                        if (subtitleSuffix.isNotEmpty)
                          TextSpan(
                            text: ' $subtitleSuffix',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            Text(
              subtitleSuffix,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
        ],
      ),
    );
  }
}
