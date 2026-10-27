import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../data/models/bookmark_model.dart';
import '../../../../data/network/network.dart';
import '../../../../data/network/url.dart';

class SavedreceipeController extends GetxController {
  final RxList<BookmarkFoodItem> savedRecipes = <BookmarkFoodItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookmarks();
  }

  /// Fetch all saved bookmarks from API
  Future<void> fetchBookmarks() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await NetworkCaller.getRequest(Urls.bookmarks);
      if (response.isSuccess && response.responseData != null) {
        final bookmarkResponse =
            BookmarkResponseModel.fromJson(response.responseData);
        savedRecipes.assignAll(bookmarkResponse.data);
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load saved recipes';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error fetching bookmarks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove bookmark with optimistic UI update and API call
  Future<void> removeBookmark(int index) async {
    if (index < 0 || index >= savedRecipes.length) return;
    final item = savedRecipes[index];

    // Optimistic removal
    savedRecipes.removeAt(index);

    try {
      final response = await NetworkCaller.postRequest(
        Urls.toggleBookmark,
        body: {'foodId': item.id},
      );

      if (response.isSuccess) {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Removed',
          '${item.name.isNotEmpty ? item.name : "Recipe"} removed from bookmarks',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      } else {
        // Rollback on failure
        savedRecipes.insert(index, item);
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update bookmark',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      savedRecipes.insert(index, item);
      debugPrint('Error removing bookmark: $e');
    }
  }

  void removeRecipe(int index) => removeBookmark(index);
}
