import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nusa_app/core/services/fcm_service.dart';
import 'package:nusa_app/firebase_options.dart';
import 'app/view/app.dart';
import 'bootstrap.dart';
import 'database/shared_preferences_service.dart';
import 'services/network_service.dart';
import 'services/google_auth_service.dart';

void main() async {
  await setup();
  await bootstrap(() => const App());
}

Future<void> setup() async {
  print("Start initializing");
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/firebase/.env");
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  print("Firebase Messaging Background Handler Initialized");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesService.init();
  print("Firebase Initialized");

  // Initialize Google Sign-In
  await GoogleAuthService.initialize();
  print("Google Sign-In Initialized");

  // Initialize Network Service
  await NetworkService().initialize();
  print("Network Service Initialized");

  // Initialize Firestore database with comprehensive seeding
  // This includes: Users, Categories, Destinations, Articles, and Forum posts
  // Comment out this line after first run to avoid recreating data
  // await FirestoreService.initializeDatabase();

  //initialize local notifications and fcm listener
  await FCMService.init();
  await FCMService.setupOnMessageOpenedAppListener();
  print("Local Notifications Initialized");

}
