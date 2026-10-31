import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../widgets/primary_button.dart';
import 'pantry_item_chip.dart';
import '../controllers/groceries_controller.dart';
import '../views/ai_meal_processing_view.dart';

import '../../../data/network/network.dart';
import '../../../data/network/url.dart';

class MealInspirationBottomSheet extends StatefulWidget {
  const MealInspirationBottomSheet({super.key});

  @override
  State<MealInspirationBottomSheet> createState() => _MealInspirationBottomSheetState();
}

class _MealInspirationBottomSheetState extends State<MealInspirationBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Real items populated dynamically from user's groceries and orders
  final List<String> _currentItems = [];
  final Set<String> _selectedItems = {};
  final List<String> _recentItems = [];

  @override
  void initState() {
    super.initState();
    _loadPantryFromGroceriesController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
    _fetchPantryAndRecentPurchases();
  }

  void _loadPantryFromGroceriesController() {
    if (Get.isRegistered<GroceriesController>()) {
      final gc = Get.find<GroceriesController>();
      for (final itm in gc.pendingItems) {
        final name = itm.title.trim();
        if (name.isNotEmpty && !_currentItems.contains(name)) {
          _currentItems.add(name);
        }
      }
      for (final itm in gc.recentlyUsedItems) {
        final name = itm.title.trim();
        if (name.isNotEmpty && !_recentItems.contains(name) && !_currentItems.contains(name)) {
          _recentItems.add(name);
        }
      }
      if (_selectedItems.isEmpty && _currentItems.isNotEmpty) {
        _selectedItems.addAll(_currentItems.take(3));
      }
    }
  }

  Future<void> _fetchPantryAndRecentPurchases() async {
    try {
      // 1. Fetch user's grocery items from Urls.grocery
      final groceryRes = await NetworkCaller.getRequest(Urls.grocery);
      if (groceryRes.isSuccess && groceryRes.responseData != null) {
        final data = groceryRes.responseData['data'];
        if (data is List) {
          for (final listObj in data) {
            if (listObj is Map && listObj['items'] is List) {
              for (final itm in listObj['items']) {
                final name = itm['name']?.toString() ?? '';
                if (name.isNotEmpty && !_currentItems.contains(name)) {
                  setState(() {
                    _currentItems.add(name);
                  });
                }
              }
            }
          }
        }
      }

      // 2. Fetch user's recent orders from Urls.orders
      final ordersRes = await NetworkCaller.getRequest(Urls.orders);
      if (ordersRes.isSuccess && ordersRes.responseData != null) {
        final data = ordersRes.responseData['data'];
        List orderList = [];
        if (data is Map && data['data'] is List) {
          orderList = data['data'];
        } else if (data is List) {
          orderList = data;
        }
        for (final ord in orderList) {
          if (ord is Map && ord['items'] is List) {
            for (final itm in ord['items']) {
              final foodName = itm['foodName']?.toString() ?? '';
              if (foodName.isNotEmpty &&
                  !_recentItems.contains(foodName) &&
                  !_currentItems.contains(foodName)) {
                setState(() {
                  _recentItems.add(foodName);
                });
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching pantry & recent purchases: $e');
    }
  }

  void _toggleItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  void _showAddPantryItemDialog() {
    final TextEditingController textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        backgroundColor: Colors.white,
        title: Text(
          'Add Pantry Item',
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: GoogleFonts.outfit(fontSize: 16.sp, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g., Olive Oil, Garlic, Pasta',
            hintStyle: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            ),
            onPressed: () {
              final val = textController.text.trim();
              if (val.isNotEmpty) {
                setState(() {
                  if (!_currentItems.contains(val)) {
                    _currentItems.insert(0, val);
                  }
                  _selectedItems.add(val);
                });
                Navigator.pop(ctx);
              }
            },
            child: Text(
              'Add',
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 60.h,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBF9), // Very light beige background matching screenshot
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SafeArea(
          bottom: false, // Bottom is handled by viewInsets
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.primary, size: 24.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Meal Inspiration',
                            style: GoogleFonts.outfit(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(Icons.close, color: AppColors.textSecondary, size: 24.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  
                  Text(
                    'What do you have in your pantry?',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Select the items you currently have. We'll use these items along with your recent purchases to suggest meals.",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Search Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.borderLight, width: 1.w),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.outfit(fontSize: 16.sp, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search Ingredients',
                        hintStyle: GoogleFonts.outfit(fontSize: 16.sp, color: AppColors.textSecondary.withValues(alpha: 0.7)),
                        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary.withValues(alpha: 0.7), size: 20.sp),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Current Items
                  Text(
                    'Your current items',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (_currentItems.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'No pantry items in your list yet. Tap "Add pantry item" below.',
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: _currentItems
                          .where((item) =>
                              _searchQuery.isEmpty ||
                              item.toLowerCase().contains(_searchQuery))
                          .map((item) {
                        final isSelected = _selectedItems.contains(item);
                        return PantryItemChip(
                          text: item,
                          isSelected: isSelected,
                          onTap: () => _toggleItem(item),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 16.h),
                  
                  // Add Pantry Item Button
                  TextButton.icon(
                    onPressed: _showAddPantryItemDialog,
                    icon: Icon(Icons.add, color: AppColors.primary, size: 20.sp),
                    label: Text(
                      'Add pantry item',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  if (_recentItems.isNotEmpty) ...[
                    // Recently Purchased
                    Text(
                      'Recently purchased',
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: _recentItems
                          .where((item) =>
                              _searchQuery.isEmpty ||
                              item.toLowerCase().contains(_searchQuery))
                          .map((item) {
                        final isSelected = _selectedItems.contains(item);
                        return PantryItemChip(
                          text: item,
                          isSelected: isSelected,
                          onTap: () => _toggleItem(item),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 32.h),
                  ] else ...[
                    SizedBox(height: 16.h),
                  ],
                  
                  PrimaryButton(
                    text: 'Get Meal Ideas',
                    showArrow: false,
                    onPressed: () {
                      final selectedList = _selectedItems.toList();
                      Get.back();
                      Get.to(() => AiMealProcessingView(
                        selectedPantryItems: selectedList,
                        recentPurchases: _recentItems.toList(),
                      ));
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
