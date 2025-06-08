import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'app/view/app.dart';
import 'bootstrap.dart';
import 'database/shared_preferences_service.dart';

void main() async {
  await setup();
  await bootstrap(() => const App());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
 // await Firebase.initializeApp();
  
  await SharedPreferencesService.init();
  // await dotenv.load();
}
