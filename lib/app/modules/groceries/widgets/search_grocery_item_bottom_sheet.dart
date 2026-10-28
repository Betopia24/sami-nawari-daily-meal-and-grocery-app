import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/app_colors.dart';
import '../controllers/groceries_controller.dart';
import 'add_grocery_item_bottom_sheet.dart';

class SearchGroceryItemBottomSheet extends StatefulWidget {
  const SearchGroceryItemBottomSheet({super.key});

  @override
  State<SearchGroceryItemBottomSheet> createState() => _SearchGroceryItemBottomSheetState();
}

class _SearchGroceryItemBottomSheetState extends State<SearchGroceryItemBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final isNotEmpty = _searchController.text.isNotEmpty;
      if (_isSearching != isNotEmpty) {
        setState(() {
          _isSearching = isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC), // Off-white cream color
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Dynamic Content Area (Suggestions or Results)
          !_isSearching 
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: AppColors.primary, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'You probably need',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Suggested Chips
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildSuggestedChip('Organic avocados', Icons.eco_outlined, true),
                        _buildSuggestedChip('Sourdough bread', Icons.bakery_dining_outlined, true),
                        _buildSuggestedChip('Salmon fillet', Icons.set_meal_outlined, true),
                        _buildSuggestedChip('Olive Oil', Icons.water_drop_outlined, true),
                        _buildSuggestedChip('Arborio Rice', Icons.rice_bowl_outlined, true),
                        _buildSuggestedChip('Fresh Dill', Icons.grass_outlined, true),
                      ],
                    ),
                  ],
                )
              : _buildSearchResults(),

          SizedBox(height: 24.h),

          // Search Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFF0F0F0)),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. bread',
                hintStyle: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFAAAAAA),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    'assets/icons/search_icon.svg',
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  _addItemDirectly(val.trim(), Icons.shopping_bag_outlined);
                }
              },
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  void _openItemDetails(String label, IconData icon) {
    Get.back();
    Get.bottomSheet(
      AddGroceryItemBottomSheet(
        initialItemName: label,
        initialItemIcon: icon,
      ),
      isScrollControlled: true,
    );
  }

  void _addItemDirectly(String label, IconData icon) {
    final controller = Get.find<GroceriesController>();
    controller.addGroceryItem(
      name: label,
      fallbackIcon: icon,
    );
    Get.back();
  }

  Widget _buildSuggestedChip(String label, IconData icon, bool outlined) {
    return GestureDetector(
      onTap: () => _addItemDirectly(label, icon),
      onLongPress: () => _openItemDetails(label, icon),
      child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : const Color(0xFFE8F5E9),
        border: outlined ? Border.all(color: AppColors.primary, width: 1) : null,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.primary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      ),
    );
  }

  int? _selectedResultIndex;

  Widget _buildSearchResults() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 0.9,
      children: [
        _buildResultCard('Bread 1', Icons.bakery_dining, 0),
        _buildResultCard('Sourdough bread', Icons.bakery_dining_outlined, 1),
        _buildResultCard('Bread 2', Icons.bakery_dining, 2),
        _buildResultCard('Bread 3', Icons.bakery_dining, 3),
        _buildResultCard('Bread 4', Icons.bakery_dining, 4),
      ],
    );
  }

  Widget _buildResultCard(String label, IconData icon, int index) {
    final isSelected = _selectedResultIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedResultIndex = index;
        });
        _addItemDirectly(label, icon);
      },
      onLongPress: () {
        setState(() {
          _selectedResultIndex = index;
        });
        _openItemDetails(label, icon);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF8F1) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFF0F0F0),
          ),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: isSelected ? AppColors.primary : AppColors.textDark,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
