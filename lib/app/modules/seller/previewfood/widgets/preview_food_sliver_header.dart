import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/app_colors.dart';

class PreviewFoodSliverHeader extends StatelessWidget {
  final double expandedHeight;
  final double collapsedHeight;
  final double floatingCardOverhang;
  final String imagePath;
  final String foodName;
  final String restaurantName;
  final Widget floatingCard;

  const PreviewFoodSliverHeader({
    super.key,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.floatingCardOverhang,
    required this.imagePath,
    required this.foodName,
    required this.restaurantName,
    required this.floatingCard,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      toolbarHeight: collapsedHeight,
      pinned: true,
      backgroundColor: const Color(0xFFFAF9F8), // Match Scaffold background to hide content scrolling under
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double top = constraints.maxHeight;
          final double scrollRange = expandedHeight - collapsedHeight;
          final double expansionFraction = scrollRange > 0
              ? ((top - collapsedHeight) / scrollRange).clamp(0.0, 1.0)
              : 0.0;

          // Fade out text inside image as we scroll up
          final double textOpacity =
              (expansionFraction - 0.3).clamp(0.0, 0.7) / 0.7;
              
          // Ensure image doesn't overflow when shrinking
          final double imageTop = top - expandedHeight;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Image Container with rounded corners
              Positioned(
                top: imageTop + 16,
                bottom: floatingCardOverhang,
                left: 24,
                right: 24,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(imagePath, fit: BoxFit.cover),
                        // Dark gradient for text readability
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 160,
                          child: Opacity(
                            opacity: textOpacity,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    AppColors.textPrimary.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Title and Floating Card inside a Column to prevent overlap
              Positioned(
                bottom: 0,
                left: 24,
                right: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Opacity(
                      opacity: textOpacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              foodName,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurantName,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    floatingCard,
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
