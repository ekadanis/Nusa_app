// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:nusa_app/services/firestore_service.dart';

// class FirebaseMessagingService {
//   static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   static Future<void> initialize(String uid, String? displayName) async {
//     //need permission
//     await _fcm.requestPermission();

//     //get token
//     final token = await _fcm.getToken();
//     debugPrint("FCM TOKEN: $token");

//     if (token != null) {
//       await FirestoreService.saveFcmToken(uid, token);
//     }

//     //handle notif while on foreground
//     FirebaseMessaging.onMessage.listen((message) {
//       final notif = message.notification;
//       if (notif != null) {
//         debugPrint('NOtifikasi diterima: ${notif.title} - ${notif.body}');
//       }
//     });

//     //handle token fresh
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//       debugPrint("succesfully renewed token ");
//       await FirestoreService.saveFcmToken(uid, newToken);
//     });
//   }

//   static Future<void> sendNotification({
//     required String token,
//     required String title, 
//     required String body,
//   }) async {
//     const String serverKey = 
//   }
// }
