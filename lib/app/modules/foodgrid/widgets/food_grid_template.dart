import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/utils/app_colors.dart';

class FoodGridTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final bool isLoading;
  final Future<void> Function()? onRefresh;
  final String emptyMessage;

  const FoodGridTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.itemCount,
    required this.itemBuilder,
    this.isLoading = false,
    this.onRefresh,
    this.emptyMessage = 'No items found',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            Divider(color: Colors.grey.shade200, height: 1),
            // Grid / Content
            Expanded(
              child: isLoading && itemCount == 0
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : (itemCount == 0
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  emptyMessage,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : (onRefresh != null
                          ? RefreshIndicator(
                              onRefresh: onRefresh!,
                              color: AppColors.primary,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(24),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final double itemWidth =
                                        (constraints.maxWidth - 16) / 2;
                                    return Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: List.generate(itemCount, (index) {
                                        return SizedBox(
                                          width: itemWidth,
                                          child: itemBuilder(context, index),
                                        );
                                      }),
                                    );
                                  },
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final double itemWidth =
                                      (constraints.maxWidth - 16) / 2;
                                  return Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: List.generate(itemCount, (index) {
                                      return SizedBox(
                                        width: itemWidth,
                                        child: itemBuilder(context, index),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ))),
            ),
          ],
        ),
      ),
    );
  }
}
