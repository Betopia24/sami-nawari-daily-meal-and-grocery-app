import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/groceries_controller.dart';
import 'create_grocery_list_bottom_sheet.dart';

class GroceriesTabBar extends GetView<GroceriesController> {
  final bool isBackground;
  
  const GroceriesTabBar({super.key, this.isBackground = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      width: double.infinity,
      child: Obx(() {
        final lists = controller.groceryLists;
        final int maxLists = lists.length > 3 ? 3 : lists.length;
        
        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (isBackground) ...[
              // The Add Tab (Always bottom-most)
              _buildTabLayer(
                width: 134.w + (maxLists * 66.w),
                isBaseLayer: true,
                child: Positioned(
                  left: 136.w + ((maxLists - 1).clamp(0, 3) * 66.w),
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          const CreateGroceryListBottomSheet(),
                          isScrollControlled: true,
                        );
                      },
                      child: CustomPaint(
                        painter: _DashedRectPainter(),
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: Center(
                            child: Icon(Icons.add, color: AppColors.primary, size: 12.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Layer 3 (List index 2)
              if (maxLists >= 3)
                _buildTabLayer(
                  width: 266.w,
                  child: Positioned(
                    left: 202.w,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _buildSolidIcon(
                        _buildDynamicIcon(lists[2].icon),
                      ),
                    ),
                  ),
                  onTap: () => controller.setActiveList(2),
                ),
                
              // Layer 2 (List index 1)
              if (maxLists >= 2)
                _buildTabLayer(
                  width: 200.w,
                  child: Positioned(
                    left: 136.w,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _buildSolidIcon(
                        _buildDynamicIcon(lists[1].icon),
                      ),
                    ),
                  ),
                  onTap: () => controller.setActiveList(1),
                ),
            ],
            
            if (!isBackground && maxLists >= 1) ...[
              // Layer 1 (Top-most, narrowest) - Active tab (List index 0)
              _buildTabLayer(
                width: 134.w,
                child: Positioned(
                  left: 16.w, 
                  top: 0,
                  bottom: 0,
                  child: Row(
                    children: [
                      _buildSolidIcon(_buildDynamicIcon(lists[0].icon, color: AppColors.textPrimary)),
                      SizedBox(width: 4.w),
                      SizedBox(
                        width: 50.w,
                        child: Text(
                          lists[0].name.length > 10 ? "${lists[0].name.substring(0, 10)}..." : lists[0].name,
                          style: GoogleFonts.outfit(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildDynamicIcon(dynamic iconData, {Color? color}) {
    if (iconData is IconData) {
      return Icon(iconData, size: 12.sp, color: color ?? AppColors.textPrimary);
    } else if (iconData is String) {
      return Text(iconData, style: TextStyle(fontSize: 12.sp));
    }
    return SizedBox(width: 12.sp, height: 12.sp);
  }

  Widget _buildTabLayer({
    required double width,
    bool isBaseLayer = false,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Positioned(
      left: 0,
      bottom: 0,
      top: 0,
      child: GestureDetector(
        onTap: onTap ?? () {
          debugPrint("Tapped tab area ending at $width");
        },
        child: CustomPaint(
          painter: _TabPainter(isBaseLayer: isBaseLayer),
          child: SizedBox(
            width: width,
            height: 42.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [child],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSolidIcon(Widget icon) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(child: icon),
    );
  }
}

class _TabPainter extends CustomPainter {
  final bool isBaseLayer;
  
  _TabPainter({this.isBaseLayer = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    final path = Path();
    final topLeftRadius = 24.0;
    final topRightRadius = 8.0;
    final slant = 32.0;
    
    path.moveTo(0, size.height);
    path.lineTo(0, topLeftRadius);
    path.quadraticBezierTo(0, 0, topLeftRadius, 0); 
    
    path.lineTo(size.width - slant - topRightRadius, 0); 
    path.quadraticBezierTo(size.width - slant, 0, size.width - slant + 4, 4); 
    
    path.lineTo(size.width - 6, size.height - 8); 
    path.quadraticBezierTo(size.width, size.height, size.width + 16, size.height); 
    
    path.lineTo(0, size.height);
    
    canvas.save();
    if (isBaseLayer) {
      canvas.clipRect(Rect.fromLTRB(-30, -30, size.width + 30, size.height));
    } else {
      canvas.clipRect(Rect.fromLTRB(size.width - 50, 0, size.width + 30, size.height));
    }
    
    canvas.drawShadow(path, Colors.black, 10.0, false);
    canvas.restore();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TabPainter oldDelegate) => false;
}

class _DashedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
      
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), 
        Radius.circular(6.r),
      ));
      
    Path dashPath = Path();
    double dashWidth = 5.0;
    double dashSpace = 4.0;
    double distance = 0.0;
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0.0; 
    }
    
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
