import 'package:flutter/material.dart';
import 'explore_map_view.dart';

/// Backward-compatible wrapper delegating to ExploreMapView
class MockMapView extends StatelessWidget {
  const MockMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(
          0xFFF1F5E8,
        ), // Light greenish background mimicking a map base
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EBE5), width: 1),
      ),
      child: Stack(
        children: [
          // Background grid lines to look like a map
          CustomPaint(
            size: Size(double.infinity, 200.h),
            painter: MapGridPainter(),
          ),

          // Map Pins
          Positioned(
            top: 40.h,
            left: 50.w,
            child: _buildMapPin("Maria's Kitchen"),
          ),
          Positioned(
            top: 80.h,
            right: 60.w,
            child: _buildMapPin("Priya's Spice House"),
          ),
          Positioned(
            bottom: 60.h,
            left: 140.w,
            child: _buildMapPin("Chen's Dim Sum"),
          ),
          Positioned(
            bottom: 20.h,
            right: 100.w,
            child: _buildMapPin("Luca's Pasta Club"),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2EBE5)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
    return const ExploreMapView();
  }
}
