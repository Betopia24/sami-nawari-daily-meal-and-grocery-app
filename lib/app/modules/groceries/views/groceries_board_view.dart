import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_assets.dart';

import 'package:get/get.dart';
import '../widgets/groceries_progress_card.dart';
import '../widgets/groceries_tab_bar.dart';
import '../widgets/add_grocery_item_bottom_sheet.dart';
import '../widgets/groceries_section_header.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/groceries_filter_chips.dart';
import '../widgets/grocery_item_card.dart';
import '../controllers/groceries_controller.dart';
import '../widgets/floating_search_bar.dart';
import '../widgets/meal_inspiration_bottom_sheet.dart';

class GroceriesBoardView extends GetView<GroceriesController> {
  const GroceriesBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Groceries',
                        style: GoogleFonts.outfit(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Shopping Planner',
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        const MealInspirationBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      color: Colors.transparent, // Ensures the touch area is padded
                      child: Icon(Icons.auto_awesome, color: AppColors.primary, size: 24.sp),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const GroceriesProgressCard(),
                    ),

                    SizedBox(height: 12.h),

                    // View All Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(() {
                            if (controller.groceryLists.isNotEmpty) {
                              return PopupMenuButton<int>(
                                onSelected: (int index) {
                                  controller.setActiveList(index);
                                },
                                offset: Offset(0, 30.h),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View All',
                                      style: GoogleFonts.outfit(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.primary,
                                      size: 16.sp,
                                    ),
                                  ],
                                ),
                                itemBuilder: (BuildContext context) {
                                  return List.generate(
                                    controller.groceryLists.length,
                                    (index) {
                                      final list =
                                          controller.groceryLists[index];
                                      return PopupMenuItem<int>(
                                        value: index,
                                        child: Row(
                                          children: [
                                            if (list.icon is IconData)
                                              Icon(
                                                list.icon as IconData,
                                                size: 16.sp,
                                                color: AppColors.textPrimary,
                                              )
                                            else if (list.icon is String)
                                              Text(
                                                list.icon as String,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                ),
                                              )
                                            else
                                              SizedBox(
                                                width: 16.sp,
                                                height: 16.sp,
                                              ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Text(
                                                list.name,
                                                style: GoogleFonts.outfit(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Tab Bar and Main Board Content Layered seamlessly
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 1. Inactive Tabs (drawn furthest behind, receives shadow)
                        Positioned(
                          top: 0,
                          left: 20.w,
                          right: 0,
                          child: const GroceriesTabBar(isBackground: true),
                        ),

                        // 2. Main Board Content (drawn middle, casts shadow onto inactive tabs)
                        Padding(
                          padding: EdgeInsets.only(
                            top: 42.h,
                          ), // Push down to make room for TabBar
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 15,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 24.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Section Header
                                  Obx(() {
                                    final lists = controller.groceryLists;
                                    if (lists.isEmpty) {
                                      return const GroceriesSectionHeader(
                                        title: "No Grocery Lists",
                                        peopleCount: 0,
                                      );
                                    }

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: GroceriesSectionHeader(
                                            title: lists[0].name,
                                            peopleCount:
                                                lists[0].sharedWithFamily
                                                ? 3
                                                : 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),

                                  SizedBox(height: 16.h),

                                  // Subtitle
                                  Obx(() => Text(
                                    '${controller.pendingItems.length} Items',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF7D7A75),
                                    ),
                                  )),

                                  SizedBox(height: 16.h),

                                  // Items Grid
                                  Obx(
                                    () => GridView.count(
                                      crossAxisCount: 3,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      mainAxisSpacing: 12.h,
                                      crossAxisSpacing: 12.w,
                                      childAspectRatio: 0.80,
                                      children: controller.pendingItems
                                          .map(
                                            (item) => GroceryItemCard(
                                              title: item.title,
                                              iconAsset: item.iconAsset,
                                              fallbackIcon: item.fallbackIcon,
                                              sizeInfo: item.sizeInfo,
                                              tagInfo: item.tagInfo,
                                              addedBy: item.addedBy,
                                              isCompleted: item.isCompleted,
                                              completedAgo: item.completedAgo,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 100.h,
                                  ), // Bottom padding for navigation bar
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 3. Active Tab (drawn second, on top, hiding the shadow beneath it)
                        Positioned(
                          top: 0,
                          left: 20.w,
                          right: 0,
                          child: const GroceriesTabBar(isBackground: false),
                        ),
                      ], // close stack children
                    ), // close stack
                  ], // close column children
                ), // close column
                  ), // close singlechildscrollview
                  // Floating Search Bar
                  Positioned(
                    bottom: 0, // Padding handles inset
                    left: 20.w,
                    right: 20.w,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: const FloatingSearchBar(),
                    ),
                  ),
                ],
              ),
            ), // close expanded
          ], // close outer column children
        ), // close outer column
      ), // close safearea
    ); // close scaffold
  }

}
