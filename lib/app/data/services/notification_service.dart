import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../firebase_options.dart';
import '../../modules/notification/controllers/notification_controller.dart';
import '../../routes/app_routes.dart';
import '../network/local_storage.dart';
import '../network/network.dart';
import '../network/url.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {}
  debugPrint("Handling background notification: ${message.messageId}");
}

class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important push notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  /// Initializes push notifications, permissions, listeners, and token sync
  static Future<void> init() async {
    try {
      // 1. Set background messaging handler (Works when app is killed/background)
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 2. Request user notification permissions
      await _requestPermission();

      // 3. Initialize Flutter Local Notifications for foreground notifications
      await _initLocalNotifications();

      // 4. Configure foreground presentation options (iOS/macOS)
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 5. Setup message listeners (foreground, background tap, terminated tap)
      _setupMessageListeners();

      // 6. Fetch and sync FCM Token with backend
      await syncFcmToken();

      // 7. Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token Refreshed: $newToken');
        syncFcmToken(forceToken: newToken);
      });
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: false,
      carPlay: false,
      announcement: false,
    );
    debugPrint('User notification permission status: ${settings.authorizationStatus}');
  }

  static Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            final data = jsonDecode(payload) as Map<String, dynamic>;
            _handleNotificationNavigation(data);
          } catch (_) {
            _navigateToNotifications();
          }
        } else {
          _navigateToNotifications();
        }
      },
    );

    // Create Android notification channel
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static void _setupMessageListeners() {
    // 1. Foreground messages: When app is ON / Active
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground notification received: ${message.notification?.title}');
      _showLocalNotification(message);

      // Refresh notification controller if active
      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().fetchNotifications();
      }
    });

    // 2. Background message tapped
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification clicked from background: ${message.data}');
      _handleNotificationNavigation(message.data);
    });

    // 3. Terminated app message tapped (App was OFF / Killed)
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App launched from terminated state via notification: ${message.data}');
        _handleNotificationNavigation(message.data);
      }
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] ?? 'New Notification';
    final body = notification?.body ?? message.data['message'] ?? message.data['body'] ?? '';

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      playSound: true,
      enableVibration: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _localNotificationsPlugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  /// Syncs FCM device token with backend (/users/update-profile)
  static Future<void> syncFcmToken({String? forceToken}) async {
    try {
      final token = forceToken ?? await _messaging.getToken();
      if (token == null || token.isEmpty) return;

      // Save token locally
      await LocalStorage.setString('fcm_token', token);
      debugPrint('FCM Device Token: $token');

      // Check if user is logged in
      final isLoggedIn = await LocalStorage.isLoggedIn();
      if (!isLoggedIn) {
        debugPrint('User not logged in yet. Token will sync upon login.');
        return;
      }

      // Send to backend
      final response = await NetworkCaller.patchRequest(
        Urls.updateProfile,
        body: {
          'fcmToken': token,
        },
      );

      if (response.isSuccess) {
        debugPrint('FCM Token successfully synced with backend!');
      } else {
        debugPrint('Failed to sync FCM Token with backend: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('Error syncing FCM token with backend: $e');
    }
  }

  static void _handleNotificationNavigation(Map<String, dynamic> data) {
    try {
      final type = data['type']?.toString().toUpperCase();
      if (type == 'ORDER') {
        Get.toNamed(Routes.mycarts, arguments: {'mycarts_tab': 1});
      } else {
        _navigateToNotifications();
      }
    } catch (_) {
      _navigateToNotifications();
    }
  }

  static void _navigateToNotifications() {
    Get.toNamed(Routes.notification);
  }
}
