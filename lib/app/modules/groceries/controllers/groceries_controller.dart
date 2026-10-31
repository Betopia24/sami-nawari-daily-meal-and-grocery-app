import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../data/models/grocery_list_model.dart';
import '../../../data/network/network.dart';
import '../../../data/network/url.dart';

class GroceryItemModel {
  final String? id;
  final String? groceryListId;
  final String title;
  final String iconAsset;
  final IconData? fallbackIcon;
  final String sizeInfo;
  final String tagInfo;
  final String addedBy;
  final bool isCompleted;
  final String? completedAgo;
  final num? quantity;
  final String? unit;
  final String? category;
  final String? priority;
  final String? notes;

  GroceryItemModel({
    this.id,
    this.groceryListId,
    required this.title,
    required this.iconAsset,
    this.fallbackIcon,
    required this.sizeInfo,
    required this.tagInfo,
    required this.addedBy,
    this.isCompleted = false,
    this.completedAgo,
    this.quantity,
    this.unit,
    this.category,
    this.priority,
    this.notes,
  });

  GroceryItemModel copyWith({
    String? id,
    String? groceryListId,
    String? title,
    String? iconAsset,
    IconData? fallbackIcon,
    String? sizeInfo,
    String? tagInfo,
    String? addedBy,
    bool? isCompleted,
    String? completedAgo,
    num? quantity,
    String? unit,
    String? category,
    String? priority,
    String? notes,
  }) {
    return GroceryItemModel(
      id: id ?? this.id,
      groceryListId: groceryListId ?? this.groceryListId,
      title: title ?? this.title,
      iconAsset: iconAsset ?? this.iconAsset,
      fallbackIcon: fallbackIcon ?? this.fallbackIcon,
      sizeInfo: sizeInfo ?? this.sizeInfo,
      tagInfo: tagInfo ?? this.tagInfo,
      addedBy: addedBy ?? this.addedBy,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAgo: completedAgo ?? this.completedAgo,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
    );
  }

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    final rawName = json['name']?.toString() ?? 'Item';
    final rawCategory = json['category']?.toString() ?? 'OTHER';
    final rawPriority = json['priority']?.toString() ?? 'NO_PRIORITY';
    final rawUnit = json['unit']?.toString() ?? '';
    final rawNotes = json['notes']?.toString() ?? '';

    num parsedQty = 1;
    if (json['quantity'] is num) {
      parsedQty = json['quantity'] as num;
    } else if (json['quantity'] != null) {
      parsedQty = num.tryParse(json['quantity'].toString()) ?? 1;
    }

    final formattedUnit = rawUnit.isNotEmpty ? rawUnit : 'pcs';
    final formattedSize = '$parsedQty $formattedUnit'.trim();

    String tag = '';
    final cleanPriority = rawPriority.trim();
    final cleanCategory = rawCategory.trim();
    if (cleanPriority.isNotEmpty &&
        cleanPriority.toUpperCase() != 'NO_PRIORITY' &&
        cleanPriority.toLowerCase() != 'no priority') {
      tag = cleanPriority;
    } else if (cleanCategory.isNotEmpty &&
        cleanCategory.toUpperCase() != 'OTHER') {
      tag = cleanCategory;
    } else if (rawNotes.trim().isNotEmpty) {
      final n = rawNotes.trim();
      tag = n.length > 12 ? '${n.substring(0, 10)}...' : n;
    }

    String addedByName = 'Me';
    if (json['addedBy'] is Map) {
      addedByName = json['addedBy']['name']?.toString() ?? 'Me';
    } else if (json['addedByName'] != null) {
      addedByName = json['addedByName'].toString();
    }

    final isDone = json['status']?.toString().toUpperCase() == 'COMPLETED';

    String? timeAgoText;
    if (isDone) {
      timeAgoText = 'Recently';
      if (json['updatedAt'] != null) {
        final dt = DateTime.tryParse(json['updatedAt'].toString());
        if (dt != null) {
          final diff = DateTime.now().difference(dt);
          if (diff.inMinutes < 60) {
            timeAgoText = '${diff.inMinutes.clamp(1, 60)}m ago';
          } else if (diff.inHours < 24) {
            timeAgoText = '${diff.inHours}h ago';
          } else {
            timeAgoText = '${diff.inDays}d ago';
          }
        }
      }
    }

    final icon = _iconForNameOrCategory(rawName, rawCategory);

    return GroceryItemModel(
      id: json['id']?.toString(),
      groceryListId: json['groceryListId']?.toString(),
      title: rawName,
      iconAsset: AppAssets.veganEmojiIcon,
      fallbackIcon: icon,
      sizeInfo: formattedSize,
      tagInfo: tag,
      addedBy: addedByName,
      isCompleted: isDone,
      completedAgo: timeAgoText,
      quantity: parsedQty,
      unit: rawUnit,
      category: rawCategory,
      priority: rawPriority,
      notes: rawNotes,
    );
  }

  static IconData _iconForNameOrCategory(String name, String category) {
    final lower = '$name $category'.toLowerCase();
    if (lower.contains('avocado') || lower.contains('egg')) {
      return Icons.egg_alt_outlined;
    } else if (lower.contains('bread') ||
        lower.contains('toast') ||
        lower.contains('bakery') ||
        lower.contains('loaf') ||
        lower.contains('sourdough')) {
      return Icons.bakery_dining_outlined;
    } else if (lower.contains('salmon') ||
        lower.contains('fish') ||
        lower.contains('seafood')) {
      return Icons.set_meal_outlined;
    } else if (lower.contains('oil') ||
        lower.contains('water') ||
        lower.contains('juice') ||
        lower.contains('milk') ||
        lower.contains('bottle') ||
        lower.contains('beverage')) {
      return Icons.water_drop_outlined;
    } else if (lower.contains('rice') ||
        lower.contains('cereal') ||
        lower.contains('grain') ||
        lower.contains('pantry') ||
        lower.contains('bag')) {
      return Icons.rice_bowl_outlined;
    } else if (lower.contains('dill') ||
        lower.contains('herb') ||
        lower.contains('vegetable') ||
        lower.contains('salad') ||
        lower.contains('spinach') ||
        lower.contains('tomato') ||
        lower.contains('onion') ||
        lower.contains('grass') ||
        lower.contains('green')) {
      return Icons.grass_outlined;
    } else if (lower.contains('yogurt') ||
        lower.contains('icecream') ||
        lower.contains('dairy') ||
        lower.contains('cheese')) {
      return Icons.icecream_outlined;
    } else if (lower.contains('meat') ||
        lower.contains('beef') ||
        lower.contains('chicken') ||
        lower.contains('steak')) {
      return Icons.kebab_dining_outlined;
    } else if (lower.contains('apple') ||
        lower.contains('fruit') ||
        lower.contains('banana') ||
        lower.contains('orange')) {
      return Icons.apple_outlined;
    }
    return Icons.shopping_bag_outlined;
  }
}

class GroceriesController extends GetxController {
  // Loading states
  final RxBool isLoading = true.obs;
  final RxBool isActionLoading = false.obs;

  // Active Grocery List
  final RxString activeGroceryListId = ''.obs;

  // Grocery Lists State
  final RxList<GroceryListModel> groceryLists = <GroceryListModel>[].obs;

  // Items State (Live from API)
  final RxList<GroceryItemModel> pendingItems = <GroceryItemModel>[].obs;
  final RxList<GroceryItemModel> recentlyUsedItems = <GroceryItemModel>[].obs;

  // Backward compatibility alias for views referencing completedItems
  RxList<GroceryItemModel> get completedItems => recentlyUsedItems;

  /// Returns the currently active GroceryListModel
  GroceryListModel? get activeGroceryList {
    if (groceryLists.isEmpty) return null;
    final found = groceryLists
        .firstWhereOrNull((l) => l.id == activeGroceryListId.value);
    return found ?? groceryLists.first;
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroceryLists();
  }

  /// Pull-to-refresh active list
  Future<void> refreshActiveList() async {
    if (activeGroceryListId.value.isNotEmpty) {
      await fetchGroceryListDetails(activeGroceryListId.value);
    } else {
      await fetchGroceryLists();
    }
  }

  /// Fetch all grocery lists from backend: GET /grocery
  Future<void> fetchGroceryLists({bool keepActive = true}) async {
    try {
      isLoading.value = true;
      // Do NOT show previous or static items while loading (per user instruction)
      pendingItems.clear();
      recentlyUsedItems.clear();

      final response = await NetworkCaller.getRequest(Urls.grocery);
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final rawData =
            body is Map && body['data'] is List ? body['data'] as List : [];
        final parsedLists = rawData
            .map((item) =>
                GroceryListModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();

        if (parsedLists.isNotEmpty) {
          groceryLists.assignAll(parsedLists);
          String targetId = parsedLists.first.id;
          if (keepActive && activeGroceryListId.value.isNotEmpty) {
            final found = parsedLists.any((l) => l.id == activeGroceryListId.value);
            if (found) {
              targetId = activeGroceryListId.value;
            }
          }
          activeGroceryListId.value = targetId;
          await fetchGroceryListDetails(targetId);
          return;
        }
      }

      // If user has zero lists, create default initial list
      await _createInitialList();
    } catch (e) {
      debugPrint('Error fetching grocery lists: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Automatically creates a default list if account has no grocery lists yet
  Future<void> _createInitialList() async {
    try {
      final body = {
        'name': "This Week's Groceries",
        'description': 'Family grocery planner',
      };
      final res = await NetworkCaller.postRequest(Urls.grocery, body: body);
      if (res.isSuccess && res.responseData != null) {
        final resData = res.responseData;
        final data =
            resData is Map && resData['data'] is Map ? resData['data'] as Map : null;
        if (data != null) {
          final listModel = GroceryListModel.fromJson(Map<String, dynamic>.from(data));
          groceryLists.assignAll([listModel]);
          activeGroceryListId.value = listModel.id;
          await fetchGroceryListDetails(listModel.id);
          return;
        }
      }
    } catch (e) {
      debugPrint('Error creating initial list: $e');
    }

    // Fallback in-memory list if offline/unauthorized
    if (groceryLists.isEmpty) {
      groceryLists.add(
        GroceryListModel(
          id: 'local_1',
          name: "This Week's Groceries",
          icon: Icons.shopping_cart_outlined,
        ),
      );
      activeGroceryListId.value = 'local_1';
    }
  }

  /// Fetch single grocery list details with items: GET /grocery/:groceryListId
  Future<void> fetchGroceryListDetails(String listId) async {
    if (listId.isEmpty) return;
    try {
      isLoading.value = true;
      pendingItems.clear();
      recentlyUsedItems.clear();

      final response =
          await NetworkCaller.getRequest(Urls.groceryListDetails(listId));
      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData;
        final data =
            body is Map && body['data'] is Map ? body['data'] as Map : null;
        if (data != null) {
          // Update the grocery list model with fresh details (name, members, stats)
          final updatedList =
              GroceryListModel.fromJson(Map<String, dynamic>.from(data));
          final idx = groceryLists.indexWhere((l) => l.id == updatedList.id);
          if (idx != -1) {
            groceryLists[idx] = updatedList;
          } else {
            groceryLists.add(updatedList);
          }

          final rawItems = data['items'] is List ? data['items'] as List : [];
          final newPending = <GroceryItemModel>[];
          final newCompleted = <GroceryItemModel>[];

          for (final it in rawItems) {
            if (it is Map) {
              final item =
                  GroceryItemModel.fromJson(Map<String, dynamic>.from(it));
              if (item.isCompleted) {
                newCompleted.add(item);
              } else {
                newPending.add(item);
              }
            }
          }

          pendingItems.assignAll(newPending);
          recentlyUsedItems.assignAll(newCompleted);
        }
      }
    } catch (e) {
      debugPrint('Error fetching grocery list items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Switch the active grocery list
  void setActiveList(int index) {
    if (index >= 0 && index < groceryLists.length) {
      if (index != 0) {
        final list = groceryLists.removeAt(index);
        groceryLists.insert(0, list);
      }
      final activeList = groceryLists[0];
      activeGroceryListId.value = activeList.id;
      fetchGroceryListDetails(activeList.id);
    }
  }

  /// Create a new grocery list via API: POST /grocery
  Future<bool> createNewListApi({
    required String name,
    String description = '',
    dynamic icon,
  }) async {
    if (name.trim().isEmpty) return false;
    try {
      isActionLoading.value = true;
      final body = {
        'name': name.trim(),
        'description':
            description.trim().isEmpty ? 'Grocery List' : description.trim(),
      };

      final response = await NetworkCaller.postRequest(Urls.grocery, body: body);
      if (response.isSuccess && response.responseData != null) {
        final resData = response.responseData;
        final data =
            resData is Map && resData['data'] is Map ? resData['data'] as Map : null;
        final newId = data?['id']?.toString();

        Get.snackbar(
          'Success',
          'Grocery list "$name" created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 80.h, left: 16.w, right: 16.w),
        );

        if (newId != null && newId.isNotEmpty) {
          activeGroceryListId.value = newId;
        }
        await fetchGroceryLists(keepActive: false);
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message.isNotEmpty
              ? response.message
              : 'Failed to create list',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          margin: EdgeInsets.only(bottom: 80.h, left: 16.w, right: 16.w),
        );
      }
    } catch (e) {
      debugPrint('Error creating grocery list: $e');
    } finally {
      isActionLoading.value = false;
    }
    return false;
  }

  /// Legacy helper for local insertion
  void createNewList(GroceryListModel newList) {
    createNewListApi(name: newList.name, description: newList.description);
  }

  /// Toggle item completion: PATCH /grocery/:groceryListId/item/:itemId
  Future<void> toggleItemCompletion(GroceryItemModel item) async {
    final currentCompleted = item.isCompleted;
    final newStatus = currentCompleted ? 'PENDING' : 'COMPLETED';

    // Optimistic UI update
    if (currentCompleted) {
      recentlyUsedItems.removeWhere(
        (e) => (e.id != null && e.id == item.id) || e.title == item.title,
      );
      final restored =
          item.copyWith(isCompleted: false, completedAgo: null);
      pendingItems.insert(0, restored);
    } else {
      pendingItems.removeWhere(
        (e) => (e.id != null && e.id == item.id) || e.title == item.title,
      );
      final completed =
          item.copyWith(isCompleted: true, completedAgo: 'Just now');
      recentlyUsedItems.insert(0, completed);
    }

    // Call API if item has an id
    if (item.id != null && item.id!.isNotEmpty && !item.id!.startsWith('local_')) {
      final listId = item.groceryListId?.isNotEmpty == true
          ? item.groceryListId!
          : activeGroceryListId.value;

      if (listId.isNotEmpty) {
        final response = await NetworkCaller.patchRequest(
          Urls.groceryItemUpdate(listId, item.id!),
          body: {'status': newStatus},
        );

        if (!response.isSuccess) {
          // Rollback if request failed
          if (currentCompleted) {
            pendingItems.removeWhere((e) => e.id == item.id);
            recentlyUsedItems.insert(0, item);
          } else {
            recentlyUsedItems.removeWhere((e) => e.id == item.id);
            pendingItems.insert(0, item);
          }
          Get.snackbar(
            'Error',
            response.message.isNotEmpty
                ? response.message
                : 'Failed to update item status',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 80.h, left: 16.w, right: 16.w),
          );
        }
      }
    }
  }

  /// Quick toggle item from recently used section
  void quickSelectRecentItem(GroceryItemModel item) {
    HapticFeedback.lightImpact();
    toggleItemCompletion(item);
  }

  /// Add a new item to grocery list: POST /grocery/:groceryListId/item
  Future<bool> addGroceryItem({
    required String name,
    num? quantity,
    String? unit,
    String? category,
    String? priority,
    String? notes,
    IconData? fallbackIcon,
    bool showSuccessSnackbar = false,
  }) async {
    if (name.trim().isEmpty) return false;

    // Ensure valid active list
    if (activeGroceryListId.value.isEmpty ||
        !groceryLists.any((l) => l.id == activeGroceryListId.value)) {
      if (groceryLists.isNotEmpty) {
        activeGroceryListId.value = groceryLists.first.id;
      } else {
        await _createInitialList();
      }
    }

    final listId = activeGroceryListId.value;
    if (listId.isEmpty) return false;

    // Normalize priority for backend enum: HIGH, MEDIUM, LOW, NO_PRIORITY
    String formattedPriority = (priority ?? 'NO_PRIORITY').toUpperCase();
    if (formattedPriority == 'NO PRIORITY') formattedPriority = 'NO_PRIORITY';
    if (!['HIGH', 'MEDIUM', 'LOW', 'NO_PRIORITY'].contains(formattedPriority)) {
      formattedPriority = 'NO_PRIORITY';
    }

    // Normalize unit for backend
    String formattedUnit = unit ?? 'pcs';
    if (formattedUnit.contains('(')) {
      final m = RegExp(r'\((.*?)\)').firstMatch(formattedUnit);
      if (m != null) formattedUnit = m.group(1)!;
    }
    formattedUnit = formattedUnit.trim().toUpperCase();
    if (formattedUnit == 'PCS' || formattedUnit == 'PIECE') formattedUnit = 'PCS';
    if (formattedUnit.isEmpty) formattedUnit = 'PCS';

    // Normalize category
    String formattedCategory = (category ?? 'OTHER').toUpperCase();
    if (formattedCategory == 'CHIKEN') formattedCategory = 'CHICKEN';

    try {
      isActionLoading.value = true;
      final body = {
        'name': name.trim(),
        'quantity': quantity ?? 1,
        'unit': formattedUnit,
        'category': formattedCategory,
        'priority': formattedPriority,
        'notes': notes?.trim() ?? '',
      };

      final response = await NetworkCaller.postRequest(
        Urls.groceryItem(listId),
        body: body,
      );

      if (response.isSuccess && response.responseData != null) {
        final resData = response.responseData;
        final data =
            resData is Map && resData['data'] is Map ? resData['data'] as Map : null;
        if (data != null) {
          final newItem =
              GroceryItemModel.fromJson(Map<String, dynamic>.from(data));
          pendingItems.insert(0, newItem);
        }
        await fetchGroceryListDetails(listId);

        if (showSuccessSnackbar) {
          Get.snackbar(
            'Added to list',
            '$name added to ${groceryLists.isNotEmpty ? groceryLists.first.name : "grocery list"}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.primary,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          );
        }
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message.isNotEmpty
              ? response.message
              : 'Failed to add item',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      debugPrint('Error adding grocery item: $e');
      Get.snackbar(
        'Error',
        'Failed to add item: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isActionLoading.value = false;
    }
    return false;
  }

  /// Update item details: PATCH /grocery/:groceryListId/item/:itemId
  Future<bool> updateGroceryItem({
    required GroceryItemModel oldItem,
    required String name,
    num? quantity,
    String? unit,
    String? category,
    String? priority,
    String? notes,
  }) async {
    final itemId = oldItem.id;
    final listId = oldItem.groceryListId?.isNotEmpty == true
        ? oldItem.groceryListId!
        : activeGroceryListId.value;

    if (itemId == null || itemId.isEmpty || itemId.startsWith('local_') || listId.isEmpty) {
      final newItem = oldItem.copyWith(
        title: name,
        sizeInfo: '${quantity ?? 1} ${unit ?? 'pcs'}',
        tagInfo: priority ?? '',
        notes: notes,
      );
      updateItem(oldItem, newItem);
      return true;
    }

    try {
      isActionLoading.value = true;
      final body = {
        'name': name.trim(),
        'quantity': quantity ?? 1,
        'unit': (unit ?? 'PCS').toUpperCase(),
        'category': (category ?? 'OTHER').toUpperCase(),
        'priority': (priority ?? 'NO_PRIORITY').toUpperCase(),
        'notes': notes?.trim() ?? '',
      };

      final response = await NetworkCaller.patchRequest(
        Urls.groceryItemUpdate(listId, itemId),
        body: body,
      );

      if (response.isSuccess) {
        await fetchGroceryListDetails(listId);
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message.isNotEmpty
              ? response.message
              : 'Failed to update item',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      debugPrint('Error updating grocery item: $e');
      Get.snackbar(
        'Error',
        'Failed to update item: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isActionLoading.value = false;
    }
    return false;
  }

  /// Local update helper
  void updateItem(GroceryItemModel oldItem, GroceryItemModel newItem) {
    final index = pendingItems.indexWhere((e) => e.title == oldItem.title);
    if (index != -1) {
      pendingItems[index] = newItem;
    } else {
      final completedIndex =
          recentlyUsedItems.indexWhere((e) => e.title == oldItem.title);
      if (completedIndex != -1) {
        recentlyUsedItems[completedIndex] = newItem;
      }
    }
  }

  /// Delete grocery item: DELETE /grocery/:groceryListId/item/:itemId
  Future<bool> deleteGroceryItem(GroceryItemModel item) async {
    final itemId = item.id;
    final listId = item.groceryListId?.isNotEmpty == true
        ? item.groceryListId!
        : activeGroceryListId.value;

    pendingItems.remove(item);
    recentlyUsedItems.remove(item);

    if (itemId != null && itemId.isNotEmpty && !itemId.startsWith('local_') && listId.isNotEmpty) {
      final response = await NetworkCaller.deleteRequest(
        Urls.groceryItemUpdate(listId, itemId),
      );
      return response.isSuccess;
    }
    return true;
  }
}
