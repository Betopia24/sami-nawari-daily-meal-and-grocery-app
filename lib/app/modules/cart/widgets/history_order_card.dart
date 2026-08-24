import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';

class HistoryOrderCard extends StatelessWidget {
  final String title;
  final String restaurantName;
  final String imagePath;
  final String status;
  final String timeAgo;
  final double price;
  final int quantity;
  final bool isReviewed;
  final int? reviewScore;
  final VoidCallback onReceipt;
  final VoidCallback onReview;
  final VoidCallback onReorder;

  const HistoryOrderCard({
    super.key,
    required this.title,
    required this.restaurantName,
    required this.imagePath,
    required this.status,
    required this.timeAgo,
    required this.price,
    required this.quantity,
    required this.isReviewed,
    this.reviewScore,
    required this.onReceipt,
    required this.onReview,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E4DF)),
      ),
      child: Column(
        children: [
          // Top section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurantName,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7A7570),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF5EF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              status,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3A8F5C),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeAgo,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7A7570),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '×$quantity',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7A7570),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8E4DF)),
          // Bottom section
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onReceipt,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Receipt',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7A7570),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: Color(0xFFE8E4DF), indent: 12, endIndent: 12),
                Expanded(
                  child: InkWell(
                    onTap: isReviewed ? null : onReview,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: isReviewed
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star, color: Color(0xFFFBBF24), size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$reviewScore/5 Reviewed',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF7A7570),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Leave Review',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE8874A),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: Color(0xFFE8E4DF), indent: 12, endIndent: 12),
                Expanded(
                  child: InkWell(
                    onTap: onReorder,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Reorder',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF3A8F5C),
                          ),
                        ),
                      ),
                    ),
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
