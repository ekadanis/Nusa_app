import 'package:flutter/foundation.dart';

class PlatformConfig {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb;
  
  // Features yang available berdasarkan platform
  static bool get supportCamera => !kIsWeb;
  static bool get supportImagePicker => true; // Web support basic image picker
  static bool get supportGeolocator => !kIsWeb; // Web membutuhkan HTTPS
  static bool get supportPermissionHandler => !kIsWeb;
  static bool get supportSpeechToText => !kIsWeb;
  static bool get supportTTS => !kIsWeb;
  
  // Web-specific configurations
  static bool get requiresHTTPS => kIsWeb;
  static String get webImagePickerMessage => 
    "Select an image from your device";
}
