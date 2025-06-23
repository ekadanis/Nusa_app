import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point') // Wajib untuk isolate background
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔕 [Background] Message received: ${message.messageId}");
  // Optional: handle logic for background messages
}

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// 🔧 Inisialisasi FCM dan lokal notifikasi
  static Future<void> init() async {
    // Minta permission dari user
    await _messaging.requestPermission();

    // Local notification setup
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(initSettings);
  }

  /// 📲 Listener saat app sedang dibuka (foreground)
  static void setupOnMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'fcm_channel',
              'FCM Notifications',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }

  /// 📬 Listener saat user klik notifikasi (background / terminated)
  static Future<void> setupOnMessageOpenedAppListener() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📬 Notifikasi diklik: ${message.data}");
      // TODO: Navigasi atau handle data jika perlu
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("🚀 App dibuka dari notifikasi: ${initialMessage.data}");
      // TODO: Navigasi atau handle initial message
    }
  }

  /// 🔐 Ambil token akses dari service account (untuk kirim notifikasi)
  static Future<AccessCredentials> _getAccessToken() async {
    final serviceAccountPath = dotenv.env['FCM_SECRET_PATH'];
    if (serviceAccountPath == null) {
      throw Exception("FCM_SECRET_PATH not found");
    }

    final serviceAccountJson = await rootBundle.loadString(serviceAccountPath);
    final serviceAccount =
        ServiceAccountCredentials.fromJson(serviceAccountJson);

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(serviceAccount, scopes);
    return client.credentials;
  }

  /// 🚀 Kirim notifikasi push ke device FCM tertentu
  static Future<bool> sendNotification({
    required String deviceToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final credentials = await _getAccessToken();
    final accessToken = credentials.accessToken.data;

    final projectId = dotenv.env['FCM_PROJECT_ID'];
    if (projectId == null) {
      throw Exception("FCM_PROJECT_ID not found");
    }

    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

    final message = {
      'message': {
        'token': deviceToken,
        'notification': {'title': title, 'body': body},
        'data': data ?? {},
      }
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('✅ Notifikasi berhasil dikirim!');
      return true;
    } else {
      print('❌ Gagal kirim notifikasi: ${response.body}');
      return false;
    }
  }
}
