import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/firebase_options.dart';
import 'app/view/app.dart';
import 'bootstrap.dart';
import 'database/shared_preferences_service.dart';
import 'services/firestore_service.dart';
import 'services/network_service.dart';
import 'services/google_auth_service.dart';

void main() async {
  await setup();
  await bootstrap(() => const App());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesService.init();  
  
  // Initialize Google Sign-In
  await GoogleAuthService.initialize();
  
  // Initialize Network Service
  await NetworkService().initialize();
  
  // Initialize Firestore database with comprehensive seeding
  // This includes: Users, Categories, Destinations, Articles, and Forum posts
  // Comment out this line after first run to avoid recreating data

}
