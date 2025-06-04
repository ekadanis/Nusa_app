import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/view/app.dart';
import 'bootstrap.dart';
import 'database/shared_preferences_service.dart';

void main() async {
  await setup();
  await bootstrap(() => const App());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();

  // ✅ Tambahkan ini untuk load .env khusus NusaBot
  //await dotenv.load(fileName: '.env');
}
