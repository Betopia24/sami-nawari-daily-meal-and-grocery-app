import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'jwt_helper.dart';

/// Helper class for managing persistent app data using SharedPreferences
class LocalStorage {
  LocalStorage._();

  static SharedPreferences? _prefs;

  /// Call in main() to initialize SharedPreferences upfront
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Internal getter ensuring _prefs is initialized lazily if not done in main()
  static Future<SharedPreferences> get _instance async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // STORAGE KEYS
  // ---------------------------------------------------------------------------
  static const String idKey = 'id';
  static const String userIdKey = 'userId';
  static const String accessTokenKey = 'accessToken';
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refreshToken';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';
  static const String onboardingCompletedKey = 'onboarding_completed';

  // ---------------------------------------------------------------------------
  // AUTH & TOKEN CONVENIENCE METHODS (id, accessToken, refreshToken)
  // ---------------------------------------------------------------------------

  /// Save user id
  static Future<bool> saveId(String id) async {
    final prefs = await _instance;
    await prefs.setString(userIdKey, id);
    return await prefs.setString(idKey, id);
  }

  /// Get user id
  static Future<String?> getId() async {
    final prefs = await _instance;
    return prefs.getString(idKey) ?? prefs.getString(userIdKey);
  }

  /// Synchronous ID getter
  static String? get idSync => _prefs?.getString(idKey) ?? _prefs?.getString(userIdKey);

  /// Save access token
  static Future<bool> saveToken(String token) async {
    final prefs = await _instance;
    await prefs.setString(accessTokenKey, token);
    return await prefs.setString(tokenKey, token);
  }

  /// Save access token (alias)
  static Future<bool> saveAccessToken(String token) => saveToken(token);

  /// Get access token
  static Future<String?> getToken() async {
    final prefs = await _instance;
    return prefs.getString(accessTokenKey) ?? prefs.getString(tokenKey);
  }

  /// Get access token (alias)
  static Future<String?> getAccessToken() => getToken();

  /// Synchronous access token getter
  static String? get tokenSync => _prefs?.getString(accessTokenKey) ?? _prefs?.getString(tokenKey);
  static String? get accessTokenSync => tokenSync;

  /// Check if user has an active, non-expired access token
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null || token.trim().isEmpty) return false;

    // Check if JWT token is expired
    if (JwtHelper.isExpired(token)) {
      await clearAuthData();
      return false;
    }
    return true;
  }

  /// Synchronous check if current token in memory is valid and not expired
  static bool get isLoggedInSync {
    final token = tokenSync;
    if (token == null || token.trim().isEmpty) return false;
    return !JwtHelper.isExpired(token);
  }

  /// Alias for isLoggedIn()
  static Future<bool> hasValidAccessToken() => isLoggedIn();

  /// Save refresh token
  static Future<bool> saveRefreshToken(String refreshToken) async {
    final prefs = await _instance;
    await prefs.setString('refresh_token', refreshToken);
    return await prefs.setString(refreshTokenKey, refreshToken);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await _instance;
    return prefs.getString(refreshTokenKey) ?? prefs.getString('refresh_token');
  }

  /// Synchronous refresh token getter
  static String? get refreshTokenSync =>
      _prefs?.getString(refreshTokenKey) ?? _prefs?.getString('refresh_token');

  /// Save complete auth data (id, accessToken, refreshToken)
  static Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String id,
    String? role,
    Map<String, dynamic>? userData,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveId(id);
    if (role != null) {
      final prefs = await _instance;
      await prefs.setString(roleKey, role);
    }
    if (userData != null) {
      await saveUser(userData);
    }
  }

  /// Save user data as Map / JSON
  static Future<bool> saveUser(Map<String, dynamic> userData) async {
    final prefs = await _instance;
    return await prefs.setString(userKey, jsonEncode(userData));
  }

  /// Save user role
  static Future<bool> saveRole(String role) async {
    final prefs = await _instance;
    return await prefs.setString(roleKey, role);
  }

  /// Get user role
  static Future<String?> getRole() async {
    final prefs = await _instance;
    return prefs.getString(roleKey);
  }

  /// Synchronous role getter
  static String? get roleSync => _prefs?.getString(roleKey);

  /// Get user data as Map / JSON
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await _instance;
    final userStr = prefs.getString(userKey);
    if (userStr == null || userStr.isEmpty) return null;
    try {
      return jsonDecode(userStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Clear all authentication-related data (e.g., on logout)
  static Future<void> clearAuthData() async {
    final prefs = await _instance;
    final currentUserId = prefs.getString(idKey) ?? prefs.getString(userIdKey);
    if (currentUserId != null) {
      await prefs.remove('pending_seller_approval_$currentUserId');
    }
    await prefs.remove(idKey);
    await prefs.remove(userIdKey);
    await prefs.remove(accessTokenKey);
    await prefs.remove(tokenKey);
    await prefs.remove(refreshTokenKey);
    await prefs.remove('refresh_token');
    await prefs.remove(userKey);
    await prefs.remove(roleKey);
    await prefs.remove('pending_seller_approval');
  }

  /// User-scoped pending seller request management
  static Future<void> setPendingSellerApproval(String? userId, bool isPending) async {
    final prefs = await _instance;
    await prefs.remove('pending_seller_approval'); // remove legacy global key
    if (userId != null && userId.isNotEmpty) {
      if (isPending) {
        await prefs.setBool('pending_seller_approval_$userId', true);
      } else {
        await prefs.remove('pending_seller_approval_$userId');
      }
    }
  }

  static Future<bool> isPendingSellerApproval(String? userId) async {
    if (userId == null || userId.isEmpty) return false;
    final prefs = await _instance;
    await prefs.remove('pending_seller_approval'); // remove legacy global key
    return prefs.getBool('pending_seller_approval_$userId') ?? false;
  }

  // ---------------------------------------------------------------------------
  // GENERIC DATA HELPERS
  // ---------------------------------------------------------------------------

  /// Save String value
  static Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return await prefs.setString(key, value);
  }

  /// Get String value
  static Future<String?> getString(String key, {String? defaultValue}) async {
    final prefs = await _instance;
    return prefs.getString(key) ?? defaultValue;
  }

  /// Save Boolean value
  static Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return await prefs.setBool(key, value);
  }

  /// Get Boolean value
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _instance;
    return prefs.getBool(key) ?? defaultValue;
  }

  /// Save Integer value
  static Future<bool> setInt(String key, int value) async {
    final prefs = await _instance;
    return await prefs.setInt(key, value);
  }

  /// Get Integer value
  static Future<int?> getInt(String key, {int? defaultValue}) async {
    final prefs = await _instance;
    return prefs.getInt(key) ?? defaultValue;
  }

  /// Save Double value
  static Future<bool> setDouble(String key, double value) async {
    final prefs = await _instance;
    return await prefs.setDouble(key, value);
  }

  /// Get Double value
  static Future<double?> getDouble(String key, {double? defaultValue}) async {
    final prefs = await _instance;
    return prefs.getDouble(key) ?? defaultValue;
  }

  /// Save `List<String>`
  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _instance;
    return await prefs.setStringList(key, value);
  }

  /// Get `List<String>`
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _instance;
    return prefs.getStringList(key);
  }

  /// Save custom Map/Object as JSON
  static Future<bool> saveJson(String key, Map<String, dynamic> data) async {
    final prefs = await _instance;
    return await prefs.setString(key, jsonEncode(data));
  }

  /// Get custom Map/Object from JSON
  static Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await _instance;
    final jsonStr = prefs.getString(key);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Check if a key exists
  static Future<bool> containsKey(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }

  /// Remove a specific key
  static Future<bool> remove(String key) async {
    final prefs = await _instance;
    return await prefs.remove(key);
  }

  /// Clear all stored data
  static Future<bool> clearAll() async {
    final prefs = await _instance;
    return await prefs.clear();
  }
}
