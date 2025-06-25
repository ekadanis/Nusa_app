import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<SharedPreferences> get _instance async =>
      prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences? prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    prefs = await _instance;
    return prefs ?? await SharedPreferences.getInstance();
  }

  static Future<void> setIsFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', value);
  }

  static Future<bool> getIsFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_first_time') ?? true;
  }


  static Future<void> clearAllPrefs() async {
    await prefs?.clear();
  }

}
