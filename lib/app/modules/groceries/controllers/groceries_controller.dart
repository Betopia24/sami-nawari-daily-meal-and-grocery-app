import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_assets.dart';
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
