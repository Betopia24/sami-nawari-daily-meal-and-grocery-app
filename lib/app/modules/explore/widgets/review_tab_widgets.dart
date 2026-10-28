import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';

class ReviewSummaryCard extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final Map<int, int> ratingPercentages; // 5 -> 78, 4 -> 15, etc

  const ReviewSummaryCard({
    super.key,
    required this.rating,
    required this.totalReviews,
    required this.ratingPercentages,
  });

  Widget _buildProgressBar(int stars, int percentage) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 12.w,
            child: Text(
              '$stars',
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Icon(Icons.star, size: 10.sp, color: Colors.orange.shade400),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                  Expanded(flex: 100 - percentage, child: const SizedBox()),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 25.w,
            child: Text(
              '$percentage%',
              textAlign: TextAlign.right,
              style: GoogleFonts.outfit(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Left side: Big rating
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  rating.toStringAsFixed(1),
                  style: GoogleFonts.outfit(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    height: 1.1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating.floor() ? Icons.star : Icons.star_border,
                      size: 14.sp,
                      color: Colors.orange.shade400,
                    );
                  }),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$totalReviews reviews',
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          // Right side: Progress bars
          Expanded(
            flex: 3,
            child: Column(
              children: [
                for (int i = 5; i >= 1; i--)
                  _buildProgressBar(i, ratingPercentages[i] ?? 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewItemCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String timeAgo;
  final double rating;
  final String text;

  const ReviewItemCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.timeAgo,
    required this.rating,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: (imagePath.startsWith('http://') || imagePath.startsWith('https://'))
                    ? NetworkImage(imagePath) as ImageProvider
                    : AssetImage(imagePath.isNotEmpty ? imagePath : 'assets/images/homereceipecardimage2.jpg') as ImageProvider,
                backgroundColor: Colors.grey.shade200,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: GoogleFonts.outfit(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating.floor() ? Icons.star : Icons.star_border,
                    size: 14.sp,
                    color: Colors.orange.shade400,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
