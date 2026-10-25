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
  static const String updateDietaryPreferences = '/users/update-dietary-preferences';
  static const String updateAllergies = '/users/update-allergies';
  static const String switchRole = '/users/switch-role';

  // ---------------------------------------------------------------------------
  // FOODS & RECIPES
  // ---------------------------------------------------------------------------
  static const String foods = '/foods';
  static const String sellerFoods = '/foods/seller';
  static const String foodRecipes = '/foods/recipe';

  // ---------------------------------------------------------------------------
  // EXPLORE & SELLERS
  // ---------------------------------------------------------------------------
  static const String exploreSellers = '/explore/sellers';
  static const String exploreFoods = '/explore/foods';

  // ---------------------------------------------------------------------------
  // CART
  // ---------------------------------------------------------------------------
  static const String cart = '/cart';
  static const String cartQuantity = '/cart/quantity';

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

  // ---------------------------------------------------------------------------
  // BOOKMARKS & REVIEWS
  // ---------------------------------------------------------------------------
  static const String bookmarks = '/bookmarks';
  static const String toggleBookmark = '/bookmarks/toggle';
  static const String reviews = '/reviews';

  // ---------------------------------------------------------------------------
  // NOTIFICATIONS
  // ---------------------------------------------------------------------------
  static const String notifications = '/notifications';
  static const String readAllNotifications = '/notifications/read-all';

  // ---------------------------------------------------------------------------
  // SELLER MODULE
  // ---------------------------------------------------------------------------
  static const String sellerRequest = '/seller/request';
  static const String sellerProfileMe = '/seller/profile/me';
}
