import 'package:flutter/material.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import 'custom_recipe_cover.dart';

class FloatingSeamSliverHeader extends StatelessWidget {
  final double expandedHeight;
  final double toolbarHeight;
  final double floatingCardOverhang;
  final String? imagePath;
  final Widget? imageWidget;
  final Widget titleWidget;
  final Widget floatingCard;
  final double titleBottomOffset;
  final double gradientHeight;

  const FloatingSeamSliverHeader({
    super.key,
    required this.expandedHeight,
    required this.toolbarHeight,
    required this.floatingCardOverhang,
    this.imagePath,
    this.imageWidget,
    required this.titleWidget,
    required this.floatingCard,
    this.titleBottomOffset = 45.0,
    this.gradientHeight = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight - MediaQuery.of(context).padding.top,
      toolbarHeight: toolbarHeight,
      pinned: true,
      backgroundColor: Colors.transparent, // Ensures overhang paints properly
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double safeAreaTop = MediaQuery.of(context).padding.top;
          final double top = constraints.maxHeight;

          final double scrollRange =
              expandedHeight - (toolbarHeight + safeAreaTop);
          final double expansionFraction = scrollRange > 0
              ? ((top - (toolbarHeight + safeAreaTop)) / scrollRange).clamp(
                  0.0,
                  1.0,
                )
              : 0.0;

          final double imageTop = top - expandedHeight;

          // Fade text out faster than the full scroll
          final double textOpacity =
              (expansionFraction - 0.3).clamp(0.0, 0.7) / 0.7;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Image
              Positioned(
                top: imageTop,
                left: 0,
                right: 0,
                height: expandedHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageWidget ?? _buildImage(imagePath ?? ''),
                    // Dark gradient at the bottom for text readability
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: gradientHeight,
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

              // Attached Title and Floating Card
              Positioned(
                bottom: -floatingCardOverhang,
                left: 24,
                right: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(opacity: textOpacity, child: titleWidget),
                    SizedBox(height: titleBottomOffset),
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

  Widget _buildImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            CustomRecipeCover(height: expandedHeight),
      );
    }
    return Image.asset(
      path.isNotEmpty ? path : AppAssets.homeRecipeCardImage1,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          CustomRecipeCover(height: expandedHeight),
    );
  }
}
