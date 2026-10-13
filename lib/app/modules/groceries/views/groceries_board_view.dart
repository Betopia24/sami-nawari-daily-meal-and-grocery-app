import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/app_colors.dart';
import 'package:get/get.dart';
import '../widgets/groceries_tab_bar.dart';
import '../widgets/add_grocery_item_bottom_sheet.dart';
import '../widgets/groceries_section_header.dart';
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
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(14.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Inspiration',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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
                                    final list = controller.groceryLists[index];
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
                        padding: EdgeInsets.only(top: 42.h),
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
                                              lists[0].sharedWithFamily ? 3 : 1,
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

                                // Items Grid (Pending)
                                Obx(
                                  () => _buildItemsGrid(
                                    items: controller.pendingItems,
                                    isCompleted: false,
                                  ),
                                ),

                                // Recently Used (Completed) Section
                                Obx(() {
                                  final recent = controller.recentlyUsedItems;
                                  if (recent.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 24.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.history_rounded,
                                                size: 18.sp,
                                                color: AppColors.primary,
                                              ),
                                              SizedBox(width: 6.w),
                                              Text(
                                                'Recently Used',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6.w,
                                                  vertical: 2.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10.r),
                                                ),
                                                child: Text(
                                                  '${recent.length}',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Tap to restore',
                                            style: GoogleFonts.outfit(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.h),
                                      _buildItemsGrid(
                                        items: recent,
                                        isCompleted: true,
                                      ),
                                    ],
                                  );
                                }),

                                SizedBox(
                                  height: 100.h,
                                ), // Bottom padding for navigation bar and search bar
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
                    ],
                  ),
                ],
              ),
            ),

            // Floating Search Bar
            Positioned(
              bottom: 0, 
              left: 20.w,
              right: 20.w,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: const FloatingSearchBar(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsGrid({
    required List<GroceryItemModel> items,
    required bool isCompleted,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    final List<Widget> rows = [];
    for (int i = 0; i < items.length; i += 3) {
      if (i > 0) {
        rows.add(SizedBox(height: 12.h));
      }
      final rowItems =
          items.sublist(i, (i + 3 > items.length) ? items.length : i + 3);
      rows.add(
        Row(
          children: [
            for (int col = 0; col < 3; col++) ...[
              if (col > 0) SizedBox(width: 12.w),
              Expanded(
                child: col < rowItems.length
                    ? AspectRatio(
                        aspectRatio: 0.80,
                        child: GroceryItemCard(
                          title: rowItems[col].title,
                          iconAsset: rowItems[col].iconAsset,
                          fallbackIcon: rowItems[col].fallbackIcon,
                          sizeInfo: rowItems[col].sizeInfo,
                          tagInfo: rowItems[col].tagInfo,
                          addedBy: rowItems[col].addedBy,
                          isCompleted: isCompleted,
                          completedAgo: rowItems[col].completedAgo ??
                              (isCompleted ? 'Recently' : null),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            controller.toggleItemCompletion(rowItems[col]);
                          },
                          onLongPress: () {
                            HapticFeedback.heavyImpact();
                            Get.bottomSheet(
                              AddGroceryItemBottomSheet(
                                initialItemName: rowItems[col].title,
                                initialItemIcon: rowItems[col].fallbackIcon,
                                itemToEdit: rowItems[col],
                              ),
                              isScrollControlled: true,
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      children: rows,
    );
  }
}
