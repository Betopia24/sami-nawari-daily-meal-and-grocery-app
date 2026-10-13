import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../data/models/grocery_list_model.dart';

class GroceryItemModel {
  final String title;
  final String iconAsset;
  final IconData? fallbackIcon;
  final String sizeInfo;
  final String tagInfo;
  final String addedBy;
  final bool isCompleted;
  final String? completedAgo;

  GroceryItemModel({
    required this.title,
    required this.iconAsset,
    this.fallbackIcon,
    required this.sizeInfo,
    required this.tagInfo,
    required this.addedBy,
    this.isCompleted = false,
    this.completedAgo,
  });

  GroceryItemModel copyWith({
    String? title,
    String? iconAsset,
    IconData? fallbackIcon,
    String? sizeInfo,
    String? tagInfo,
    String? addedBy,
    bool? isCompleted,
    String? completedAgo,
  }) {
    return GroceryItemModel(
      title: title ?? this.title,
      iconAsset: iconAsset ?? this.iconAsset,
      fallbackIcon: fallbackIcon ?? this.fallbackIcon,
      sizeInfo: sizeInfo ?? this.sizeInfo,
      tagInfo: tagInfo ?? this.tagInfo,
      addedBy: addedBy ?? this.addedBy,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAgo: completedAgo ?? this.completedAgo,
    );
  }
}

class GroceriesController extends GetxController {
  // Grocery Lists State
  final groceryLists = <GroceryListModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // Add some initial dummy lists for UI
    groceryLists.addAll([
      GroceryListModel(
        id: '1',
        name: "This Week's Groceries",
        icon: Icons.shopping_cart_outlined,
      ),
      GroceryListModel(
        id: '2',
        name: "BBQ Party",
        icon: Icons.outdoor_grill_outlined,
      ),
      GroceryListModel(
        id: '3',
        name: "Monthly Staples",
        icon: Icons.inventory_2_outlined,
      ),
    ]);
  }

  void createNewList(GroceryListModel newList) {
    // Insert at the top (index 0)
    groceryLists.insert(0, newList);
  }

  void setActiveList(int index) {
    if (index >= 0 && index < groceryLists.length && index != 0) {
      final list = groceryLists.removeAt(index);
      groceryLists.insert(0, list);
    }
  }

  // Recently used items for quick future selection
  final recentlyUsedItems = <GroceryItemModel>[
    GroceryItemModel(
      title: 'Cherry tomatoes',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.circle_outlined,
      sizeInfo: '250 g',
      tagInfo: 'Low',
      addedBy: 'Amara',
      isCompleted: true,
      completedAgo: '3h ago',
    ),
    GroceryItemModel(
      title: 'Free Range Eggs',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.egg_outlined,
      sizeInfo: '12 pcs',
      tagInfo: 'Low',
      addedBy: 'Rafi',
      isCompleted: true,
      completedAgo: '5h ago',
    ),
    GroceryItemModel(
      title: 'Coconut Milk',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.water_drop_outlined,
      sizeInfo: '2 Can',
      tagInfo: 'Low',
      addedBy: 'Amara',
      isCompleted: true,
      completedAgo: '6h ago',
    ),
  ].obs;

  void toggleItemCompletion(GroceryItemModel item) {
    if (item.isCompleted) {
      recentlyUsedItems.removeWhere(
        (e) => e.title.trim().toLowerCase() == item.title.trim().toLowerCase(),
      );
      completedItems.removeWhere(
        (e) => e.title.trim().toLowerCase() == item.title.trim().toLowerCase(),
      );
      pendingItems.insert(0, item.copyWith(isCompleted: false, completedAgo: null));
    } else {
      pendingItems.remove(item);
      final completedItem = item.copyWith(isCompleted: true, completedAgo: 'Just now');
      completedItems.insert(0, completedItem);

      // Automatically populate into recently used items list
      addToRecentlyUsed(completedItem);
    }
  }

  void addToRecentlyUsed(GroceryItemModel item) {
    // Remove if already in recently used items (by title) to avoid duplicates and bring to front
    recentlyUsedItems.removeWhere(
      (e) => e.title.trim().toLowerCase() == item.title.trim().toLowerCase(),
    );
    recentlyUsedItems.insert(
      0,
      item.copyWith(isCompleted: true, completedAgo: 'Just now'),
    );
  }

  void quickSelectRecentItem(GroceryItemModel item) {
    HapticFeedback.lightImpact();
    final index = pendingItems.indexWhere(
      (e) => e.title.trim().toLowerCase() == item.title.trim().toLowerCase(),
    );

    if (index != -1) {
      // Toggle off if already in list
      pendingItems.removeAt(index);
      Get.snackbar(
        'Removed from list',
        '${item.title} removed from grocery list',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.grey.shade900,
        colorText: Colors.white,
        margin: EdgeInsets.only(bottom: 80.h, left: 16.w, right: 16.w),
      );
    } else {
      // Add to pendingItems
      pendingItems.insert(0, item.copyWith(isCompleted: false, completedAgo: null));
      Get.snackbar(
        'Added to list',
        '${item.title} added to grocery list',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        margin: EdgeInsets.only(bottom: 80.h, left: 16.w, right: 16.w),
      );
    }
  }

  void updateItem(GroceryItemModel oldItem, GroceryItemModel newItem) {
    final index = pendingItems.indexOf(oldItem);
    if (index != -1) {
      pendingItems[index] = newItem;
    } else {
      final completedIndex = completedItems.indexOf(oldItem);
      if (completedIndex != -1) {
        completedItems[completedIndex] = newItem;
      }
    }
  }

  final pendingItems = <GroceryItemModel>[
    GroceryItemModel(
      title: 'Organic avocados',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.egg_alt_outlined,
      sizeInfo: '4 pcs',
      tagInfo: 'HIGH',
      addedBy: 'Rafi',
    ),
    GroceryItemModel(
      title: 'Sourdough bread',
      iconAsset: AppAssets.burgerEmojiIcon,
      fallbackIcon: Icons.bakery_dining_outlined,
      sizeInfo: '1 loaf',
      tagInfo: 'HIGH',
      addedBy: 'Rafi',
    ),
    GroceryItemModel(
      title: 'Salmon fillet',
      iconAsset: AppAssets.takeoutEmojiIcon,
      fallbackIcon: Icons.set_meal_outlined,
      sizeInfo: '500 g',
      tagInfo: 'Fresh only',
      addedBy: 'Rafi',
    ),
    GroceryItemModel(
      title: 'Olive Oil',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.water_drop_outlined,
      sizeInfo: '1 Bottle',
      tagInfo: 'HIGH',
      addedBy: 'Rafi',
    ),
    GroceryItemModel(
      title: 'Arborio Rice',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.rice_bowl_outlined,
      sizeInfo: '1 Bag',
      tagInfo: 'HIGH',
      addedBy: 'Rafi',
    ),
    GroceryItemModel(
      title: 'Fresh Dill',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.grass_outlined,
      sizeInfo: '1 Bundle',
      tagInfo: 'HIGH',
      addedBy: 'Rafi',
    ),
    GroceryItemModel(
      title: 'Greek Yogurt',
      iconAsset: AppAssets.takeoutEmojiIcon,
      fallbackIcon: Icons.icecream_outlined,
      sizeInfo: '2 pcs',
      tagInfo: 'Low fat',
      addedBy: 'Rafi',
    ),
  ].obs;

  final completedItems = <GroceryItemModel>[
    GroceryItemModel(
      title: 'Cherry tomatoes',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.circle_outlined,
      sizeInfo: '250 g',
      tagInfo: 'Low',
      addedBy: 'Amara',
      isCompleted: true,
      completedAgo: '3h ago',
    ),
    GroceryItemModel(
      title: 'Free Range Eggs',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.egg_outlined,
      sizeInfo: '12 pcs',
      tagInfo: 'Low',
      addedBy: 'Rafi',
      isCompleted: true,
      completedAgo: '5h ago',
    ),
    GroceryItemModel(
      title: 'Coconut Milk',
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: Icons.water_drop_outlined,
      sizeInfo: '2 Can',
      tagInfo: 'Low',
      addedBy: 'Amara',
      isCompleted: true,
      completedAgo: '6h ago',
    ),
  ].obs;
}
