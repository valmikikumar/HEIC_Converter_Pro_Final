import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyConversionCount = 'conversion_count';
  static const String _keyIsPro = 'is_pro';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyDefaultFormat = 'default_format';
  static const String _keyQualityPreset = 'quality_preset';

  static Future<int> getConversionCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyConversionCount) ?? 0;
  }

  static Future<void> incrementConversionCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = await getConversionCount();
    await prefs.setInt(_keyConversionCount, count + 1);
  }

  static Future<bool> isPro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsPro) ?? false;
  }

  static Future<void> setProStatus(bool isPro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsPro, isPro);
  }

  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  static Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode);
  }

  static Future<String> getDefaultFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDefaultFormat) ?? 'jpg';
  }

  static Future<void> setDefaultFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultFormat, format);
  }

  static Future<String> getQualityPreset() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyQualityPreset) ?? 'high';
  }

  static Future<void> setQualityPreset(String preset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyQualityPreset, preset);
  }

  static Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<int> getRemainingConversions() async {
    final isPro = await LocalStorageService.isPro();
    if (isPro) return -1;
    final count = await getConversionCount();
    return 50 - count;
  }

  static Future<bool> canConvert() async {
    final isPro = await LocalStorageService.isPro();
    if (isPro) return true;
    final count = await getConversionCount();
    return count < 50;
  }
}
