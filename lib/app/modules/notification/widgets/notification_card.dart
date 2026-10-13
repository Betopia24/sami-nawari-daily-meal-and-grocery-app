import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String type;
  final String emoji;
  final bool isUnread;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    required this.emoji,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFEEF7F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF7F2),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isUnread) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isUnread ? Colors.white : const Color(0xFFF3F1ED),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Text(
                        type,
                        style: GoogleFonts.outfit(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      time,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFB0AAA4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

