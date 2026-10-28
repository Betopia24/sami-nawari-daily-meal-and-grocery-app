import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../controllers/groceries_controller.dart';
import 'search_grocery_item_bottom_sheet.dart';
import 'add_grocery_item_bottom_sheet.dart';

class FloatingSearchBar extends StatefulWidget {
  const FloatingSearchBar({super.key});

  @override
  State<FloatingSearchBar> createState() => _FloatingSearchBarState();
}

class _FloatingSearchBarState extends State<FloatingSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _expandAnimation;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isExpanded = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _textController.addListener(() {
      final has = _textController.text.trim().isNotEmpty;
      if (has != _hasText) {
        setState(() => _hasText = has);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _expand() {
    HapticFeedback.lightImpact();
    setState(() => _isExpanded = true);
    _animController.forward().then((_) {
      if (mounted && _isExpanded) {
        _focusNode.requestFocus();
      }
    });
  }

  void _collapse() {
    HapticFeedback.lightImpact();
    _focusNode.unfocus();
    _animController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isExpanded = false;
          _textController.clear();
        });
      }
    });
  }

  void _submitAdd() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.mediumImpact();
    final controller = Get.find<GroceriesController>();
    controller.addGroceryItem(name: text);
    _collapse();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fullWidth = screenWidth - 40.w;
    final double collapsedSize = 56.w;

    // 1. If completely collapsed, render ONLY the isolated bottom-right FAB
    if (!_isExpanded && !_animController.isAnimating) {
      return Positioned(
        right: 20.w,
        bottom: 0,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildFab(collapsedSize),
          ),
        ),
      );
    }

    // 2. When expanding or expanded, render full-screen stack with backdrop + animated bar
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _collapse();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Full-screen Backdrop: Tapping anywhere closes the search bar
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                final alphaVal = (_expandAnimation.value * 0.35).clamp(0.0, 0.35);
                return GestureDetector(
                  onTap: _collapse,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: Colors.black.withValues(alpha: alphaVal),
                  ),
                );
              },
            ),
          ),

          // Animated expanding dock from bottom-right to full width
          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: AnimatedBuilder(
                    animation: _expandAnimation,
                    builder: (context, child) {
                      final t = _expandAnimation.value;
                      final currentWidth =
                          collapsedSize + (fullWidth - collapsedSize) * t;

                      return Container(
                        width: currentWidth,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            AppColors.primary,
                            Colors.white,
                            t,
                          ),
                          borderRadius: BorderRadius.circular(28.r),
                          border: Border.all(
                            color: Color.lerp(
                              Colors.transparent,
                              AppColors.primary.withValues(alpha: 0.20),
                              t,
                            )!,
                            width: 1.2.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.lerp(
                                AppColors.primary.withValues(alpha: 0.35),
                                Colors.black.withValues(alpha: 0.12),
                                t,
                              )!,
                              blurRadius: 16 + 8 * t,
                              offset: Offset(0, 4 + 4 * t),
                            ),
                            if (t > 0.1)
                              BoxShadow(
                                color: AppColors.primary
                                    .withValues(alpha: 0.08 * t),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28.r),
                          child: t < 0.25
                              ? _buildCollapsedFabIcon()
                              : _buildExpandedContent(t),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Collapsed standalone FAB widget
  Widget _buildFab(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.38),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _expand,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.25),
          highlightColor: Colors.white.withValues(alpha: 0.12),
          child: Center(
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedFabIcon() {
    return Center(
      child: Icon(
        Icons.add_rounded,
        color: Colors.white,
        size: 32.sp,
      ),
    );
  }

  /// Expanded full content
  Widget _buildExpandedContent(double t) {
    final contentOpacity = ((t - 0.25) / 0.75).clamp(0.0, 1.0);

    return Opacity(
      opacity: contentOpacity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
        child: Row(
          children: [
            // Left: Search / Suggestions sheet trigger
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Get.bottomSheet(
                  const SearchGroceryItemBottomSheet(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
            ),

            SizedBox(width: 8.w),

            // Center: Inline Text Input
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submitAdd(),
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'I need... e.g. Milk, Apples',
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9E9E9E),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            ),

            // Clear icon when text is entered
            if (_hasText)
              GestureDetector(
                onTap: () => _textController.clear(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    Icons.close_rounded,
                    color: const Color(0xFFB0B0B0),
                    size: 18.sp,
                  ),
                ),
              ),

            SizedBox(width: 4.w),

            // Right Action:
            // When text typed -> "Add" primary button
            // When text empty -> Tune (full dialog) + Close (✕) button
            if (_hasText)
              GestureDetector(
                onTap: _submitAdd,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 44.w,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 17.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Add',
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Full detailed dialog (with quantity/unit/priority)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _collapse();
                      Get.bottomSheet(
                        const AddGroceryItemBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),

                  // Close button
                  GestureDetector(
                    onTap: _collapse,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.textSecondary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
