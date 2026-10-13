import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class GroceriesSectionHeader extends StatelessWidget {
  final String title;
  final int peopleCount;

  const GroceriesSectionHeader({
    super.key,
    required this.title,
    this.peopleCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.sharedmembers),
          child: _buildStackedAvatars(),
        ),
      ],
    );
  }

  Widget _buildStackedAvatars() {
    return SizedBox(
      width: 60.w,
      height: 24.w,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: _buildAvatar(color: Colors.grey.shade300, child: Text('+$peopleCount', style: TextStyle(color: Colors.white, fontSize: 10.sp))),
          ),
          Positioned(
            right: 14.w,
            child: _buildAvatar(imageUrl: 'https://i.pravatar.cc/100?img=1'),
          ),
          Positioned(
            right: 28.w,
            child: _buildAvatar(imageUrl: 'https://i.pravatar.cc/100?img=2'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar({String? imageUrl, Color? color, Widget? child}) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Colors.grey.shade200,
        border: Border.all(color: const Color(0xFFE8E4DF), width: 1.5.w),
      ),
      alignment: Alignment.center,
      child: imageUrl != null
          ? ClipOval(
              child: Image.network(imageUrl, width: 24.w, height: 24.w, fit: BoxFit.cover),
            )
          : child,
    );
  }
}
