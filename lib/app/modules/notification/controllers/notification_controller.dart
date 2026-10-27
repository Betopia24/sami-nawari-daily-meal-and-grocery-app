import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/network/network.dart';
import '../../../data/network/url.dart';

class NotificationController extends GetxController {
  final RxList<NotificationItemModel> notifications =
      <NotificationItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isMarkingAllAsRead = false.obs;
  final RxString errorMessage = ''.obs;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;

  final List<String> baseFilters = [
    'All',
    'Read',
    'Unread',
    'Marketplace',
    'Order',
  ];

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
    fetchNotifications();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Total count of unread notifications
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  /// Dynamic filter label for UI (e.g. "Unread (3)")
  String getFilterLabel(String filter) {
    if (filter == 'Unread') {
      final count = unreadCount;
      return count > 0 ? 'Unread ($count)' : 'Unread';
    }
    return filter;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Filtered list of notifications based on selected filter and search query
  List<NotificationItemModel> get filteredNotifications {
    final query = searchQuery.value.trim().toLowerCase();
    final filter = selectedFilter.value.toLowerCase();

    return notifications.where((item) {
      // Search matching
      if (query.isNotEmpty) {
        final titleMatch = item.title.toLowerCase().contains(query);
        final messageMatch = item.message.toLowerCase().contains(query);
        if (!titleMatch && !messageMatch) return false;
      }

      // Filter matching
      if (filter == 'all') return true;
      if (filter == 'read') return item.isRead;
      if (filter.startsWith('unread')) {
        return !item.isRead;
      }

      return item.type.toLowerCase() == filter;
    }).toList();
  }

  /// Fetch notifications from backend: GET Urls.notifications ('/notifications')
  Future<void> fetchNotifications({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await NetworkCaller.getRequest(Urls.notifications);
      if (response.isSuccess && response.responseData != null) {
        final model = NotificationResponseModel.fromJson(response.responseData);
        notifications.assignAll(model.data);
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load notifications';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Mark all notifications as read: PATCH Urls.readAllNotifications ('/notifications/read-all')
  Future<void> markAllAsRead() async {
    if (notifications.isEmpty || unreadCount == 0) return;
    isMarkingAllAsRead.value = true;

    // Optimistic update
    final backup = notifications.map((e) => e.copyWith()).toList();
    for (var item in notifications) {
      item.isRead = true;
    }
    notifications.refresh();

    try {
      final response =
          await NetworkCaller.patchRequest(Urls.readAllNotifications);
      if (response.isSuccess) {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Success',
          'All notifications marked as read',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      } else {
        // Rollback
        notifications.assignAll(backup);
        Get.closeCurrentSnackbar();
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to mark notifications as read',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      notifications.assignAll(backup);
      debugPrint('Error marking all notifications as read: $e');
    } finally {
      isMarkingAllAsRead.value = false;
    }
  }

  /// Mark single notification as read: PATCH Urls.singleReadNotification ('/notifications/:id/read')
  Future<void> markAsRead(String notificationId) async {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;
    final item = notifications[index];
    if (item.isRead) return;

    // Optimistic update
    item.isRead = true;
    notifications.refresh();

    try {
      final url = Urls.getSingleReadNotificationUrl(notificationId);
      final response = await NetworkCaller.patchRequest(url);
      if (!response.isSuccess) {
        // Rollback if request failed
        item.isRead = false;
        notifications.refresh();
        debugPrint(
            'Failed to mark notification as read: ${response.errorMessage}');
      }
    } catch (e) {
      item.isRead = false;
      notifications.refresh();
      debugPrint('Error marking notification as read: $e');
    }
  }
}
