/// API Endpoints from Postman collection (Sami Nawarir daily meal and grocery)
class Urls {
  Urls._();

  /// Live Server Base URL
  static const String baseUrl = 'http://206.162.244.134:5478/api/v1';

  // ---------------------------------------------------------------------------
  // AUTHENTICATION
  // ---------------------------------------------------------------------------
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendOtp = '/auth/resend-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String socialLogin = '/auth/social-login';
  static const String logout = '/auth/logout';

  // ---------------------------------------------------------------------------
  // USERS & PROFILE
  // ---------------------------------------------------------------------------
  static const String userMe = '/users/me';
  static const String updateProfile = '/users/update-profile';
  static const String updatePassword = '/users/update-password';
  static const String updateLanguageRegion = '/users/update-language-region';
  static const String updateDietaryPreferences =
      '/users/update-dietary-preferences';
  static const String updateAllergies = '/users/update-allergies';
  static const String switchRole = '/users/switch-role';

  // ---------------------------------------------------------------------------
  // FOODS & RECIPES
  // ---------------------------------------------------------------------------
  static const String foods = '/foods';
  static const String sellerFoods = '/foods/seller';
  static const String foodRecipes = '/foods/recipe';
  static const String aiRecommendFoods = '/ai/recommendations/foods';
  static const String aiRecommendRecipes = '/ai/recommendations/recipes';

  // ---------------------------------------------------------------------------
  // EXPLORE & SELLERS
  // ---------------------------------------------------------------------------
  static const String exploreSellers = '/explore/sellers';
  static const String exploreFoods = '/explore/foods';
  static String sellerMenu(String sellerId) =>
      '/explore/sellers/$sellerId/menu';
  static String sellerAbout(String sellerId) =>
      '/explore/sellers/$sellerId/about';
  static String sellerReviews(String sellerId) =>
      '/explore/sellers/$sellerId/reviews';

  // ---------------------------------------------------------------------------
  // CART
  // ---------------------------------------------------------------------------
  static const String cart = '/cart';
  static const String cartQuantity = '/cart/quantity';
  static const String profileDietaryPreferences =
      '/users/update-dietary-preferences';
  static const String profileAlergies = '/users/update-allergies';

  // ---------------------------------------------------------------------------
  // ORDERS
  // ---------------------------------------------------------------------------
  static const String orders = '/orders';
  static const String sellerOrders = '/orders/seller';

  // ---------------------------------------------------------------------------
  // GROCERY
  // ---------------------------------------------------------------------------
  static const String grocery = '/grocery';
  static const String groceryInvitations = '/grocery/invitations';
  static String groceryListDetails(String listId) => '/grocery/$listId';
  static String groceryItem(String listId) => '/grocery/$listId/item';
  static String groceryItemUpdate(String listId, String itemId) =>
      '/grocery/$listId/item/$itemId';

  // ---------------------------------------------------------------------------
  // BOOKMARKS & REVIEWS
  // ---------------------------------------------------------------------------
  static const String bookmarks = '/bookmarks';
  static const String toggleBookmark = '/bookmarks/toggle';
  static const String reviews = '/reviews';
  static const String sellerProfileFavourite = '/bookmarks/sellers/toggle';
  static const String getSellerPrifile = '/bookmarks/sellers';

  // ---------------------------------------------------------------------------
  // NOTIFICATIONS
  // ---------------------------------------------------------------------------
  static const String notifications = '/notifications';
  static const String readAllNotifications = '/notifications/read-all';
  static const String singleReadNotification =
      '/notifications/notification_id/read';

  // ---------------------------------------------------------------------------
  // SELLER MODULE
  // ---------------------------------------------------------------------------
  static const String sellerRequest = '/seller/request';
  static const String sellerProfileMe = '/seller/profile/me';
  static const String changeRole = '/users/switch-role';
  static const String sellerOrderList = '/orders/seller';
  static const String sellerFoodsList = '/foods/seller';
  static const String updateFood = '/foods/seller/food_id';
  static const String deleteFood = '/foods/seller/:foodId';
  static const String orderStatusUpdate = '/orders/seller/order_id/status';
  static const String stripeConnect = '/seller/stripe/connect';
  static const String earningOverview = '/seller/earnings';
  static const String earningHistory = '/seller/earnings/history';

  /// Helper to get the update food endpoint with food ID
  static String getUpdateFoodUrl(String foodId) =>
      updateFood.replaceAll('food_id', foodId);

  /// Helper to get the delete food endpoint with food ID
  static String getDeleteFoodUrl(String foodId) =>
      deleteFood.replaceAll(':foodId', foodId);

  /// Helper to get the order status update endpoint with order ID
  static String getOrderStatusUpdateUrl(String orderId) =>
      orderStatusUpdate.replaceAll('order_id', orderId);

  /// Helper to get the single notification read endpoint with notification ID
  static String getSingleReadNotificationUrl(String notificationId) =>
      singleReadNotification.replaceAll('notification_id', notificationId);
}
