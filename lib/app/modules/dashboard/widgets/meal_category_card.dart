import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MealCategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color? color;
  final Gradient? gradient;
  final VoidCallback onTap;

  const MealCategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.color,
    this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 104,
        padding: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E4DF)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                imagePath,
                width: 91,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
