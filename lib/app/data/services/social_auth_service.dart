import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../network/network.dart';
import '../network/url.dart';
import '../network/local_storage.dart';
import '../network/jwt_helper.dart';
import '../../routes/app_routes.dart';
import 'notification_service.dart';

class SocialAuthService {
  SocialAuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Default Web client ID from google-services.json for Firebase backend token exchange
  static const String _serverClientId =
      '1003764253086-u5pupgn16j6c82k0rlnmul5dv6g9picb.apps.googleusercontent.com';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _serverClientId,
    scopes: ['email', 'profile'],
  );

  /// Performs Google Sign-In, retrieves Firebase ID token, and sends to backend
  static Future<bool> signInWithGoogle() async {
    try {
      // Sign out first to allow user to pick account cleanly
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User dismissed the Google sign-in dialog
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw Exception('Failed to obtain Firebase ID Token from Google.');
      }

      return await sendTokenToBackend(idToken);
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      Get.snackbar(
        'Google Sign-In Failed',
        e.toString().replaceAll('Exception:', '').trim(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }
  }

  /// Performs Apple Sign-In, retrieves Firebase ID token, and sends to backend
  static Future<bool> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      UserCredential userCredential;
      if (kIsWeb) {
        userCredential = await _auth.signInWithPopup(appleProvider);
      } else {
        userCredential = await _auth.signInWithProvider(appleProvider);
      }

      final String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw Exception('Failed to obtain Firebase ID Token from Apple.');
      }

      return await sendTokenToBackend(idToken);
    } catch (e) {
      debugPrint('Apple Sign-In Error: $e');
      Get.snackbar(
        'Apple Sign-In Failed',
        e.toString().replaceAll('Exception:', '').trim(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }
  }

  /// Sends the Firebase ID Token to backend {{baseUrl}}/auth/social-login
  static Future<bool> sendTokenToBackend(String firebaseIdToken) async {
    try {
      final response = await NetworkCaller.postRequest(
        Urls.socialLogin,
        body: {
          'token': firebaseIdToken,
        },
        requiresToken: false,
      );

      if (response.isSuccess) {
        final data = response.responseData;
        final responseData = data is Map ? data['data'] : null;

        final accessToken = responseData?['accessToken']?.toString();
        final refreshToken = responseData?['refreshToken']?.toString();
        final id = responseData?['id']?.toString() ??
            responseData?['userId']?.toString() ??
            responseData?['user']?['id']?.toString();
        final role = responseData?['user']?['role']?.toString() ??
            responseData?['role']?.toString();

        if (role != null && role.isNotEmpty) {
          await LocalStorage.saveRole(role);
        }

        if (accessToken != null && accessToken.isNotEmpty) {
          await LocalStorage.saveAccessToken(accessToken);
          _extractAndSaveUserFromJwt(accessToken);
        }
        if (refreshToken != null && refreshToken.isNotEmpty) {
          await LocalStorage.saveRefreshToken(refreshToken);
        }
        if (id != null && id.isNotEmpty) {
          await LocalStorage.saveId(id);
        }

        // Sync FCM device token with backend
        NotificationService.syncFcmToken();

        Get.snackbar(
          'Success',
          data?['message']?.toString() ?? 'Logged in successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        );

        Get.offAllNamed(Routes.navbar);
        return true;
      } else {
        final errorMessage = response.errorMessage;
        Get.snackbar(
          'Social Sign-In Failed',
          errorMessage.isNotEmpty
              ? errorMessage
              : 'Failed to authenticate with backend.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Backend connection error: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }
  }

  static void _extractAndSaveUserFromJwt(String token) {
    try {
      final map = JwtHelper.decodePayload(token);
      if (map != null) {
        LocalStorage.saveUser(map);
        final userId = JwtHelper.getUserId(token);
        if (userId != null) {
          LocalStorage.saveId(userId);
        }
        final role = JwtHelper.getRole(token) ?? map['role']?.toString();
        if (role != null && role.isNotEmpty) {
          LocalStorage.saveRole(role);
        }
      }
    } catch (_) {}
  }
}
