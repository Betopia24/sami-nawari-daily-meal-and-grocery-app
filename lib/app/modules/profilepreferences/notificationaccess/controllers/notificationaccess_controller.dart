import 'package:get/get.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../routes/app_routes.dart';

class NotificationaccessController extends GetxController {
  final List<Map<String, String>> notificationOptions = [
    {
      'iconPath': AppAssets.recipeEmojiIcon,
      'title': 'Meal Reminders',
      'subtitle': 'Breakfast, lunch, and dinner on time',
    },
    {
      'iconPath': AppAssets.cartEmojiIcon,
      'title': 'Shopping Reminders',
      'subtitle': 'Never forget items on your grocery list',
    },
    {
      'iconPath': AppAssets.communityEmojiIcon,
      'title': 'Family Updates',
      'subtitle': 'Know when family members update shared lists',
    },
    {
      'iconPath': AppAssets.promoEmojiIcon,
      'title': 'Exclusive Deals',
      'subtitle': 'Offers from nearby homemade food sellers',
    },
  ];

  void allowNotification() {
    print('Notification allowed');
    Get.offAllNamed(Routes.foodpreferences);
  }

  void skip() {
    print('Notification skipped');
    Get.offAllNamed(Routes.foodpreferences);
  }
}
