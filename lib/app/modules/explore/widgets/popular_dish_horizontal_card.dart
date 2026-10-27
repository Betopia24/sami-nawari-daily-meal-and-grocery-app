import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';

/// A compact card for the "Popular Dishes" horizontal scroll list on the
/// view-menu page. Shows dish image, title, price, and optional "Popular" badge.
class PopularDishHorizontalCard extends StatelessWidget {
  final String name;
  final String image;
  final double price;
  final bool isPopular;
  final VoidCallback? onTap;

  const PopularDishHorizontalCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    this.isPopular = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: _buildImage(image),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        '\$$price',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      if (isPopular)
                        Text(
                          'Popular',
                          style: GoogleFonts.outfit(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF5A623),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        height: 100.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Image.asset(
          'assets/images/homelunchcardimage.png',
          height: 100.h,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      path.isNotEmpty ? path : 'assets/images/homelunchcardimage.png',
      height: 100.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Image.asset(
        'assets/images/homelunchcardimage.png',
        height: 100.h,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
