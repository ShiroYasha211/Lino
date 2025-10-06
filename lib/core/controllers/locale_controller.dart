import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  static const String _localeKey = 'selected_locale';

  final _currentLocale = const Locale('ar', 'SA').obs;

  Locale get currentLocale => _currentLocale.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);

      if (savedLocale != null) {
        final parts = savedLocale.split('_');
        if (parts.length == 2) {
          _currentLocale.value = Locale(parts[0], parts[1]);
        }
      } else {
        // Auto-detect system locale
        _detectSystemLocale();
      }
    } catch (e) {
      // Default to Arabic if error
      _currentLocale.value = const Locale('ar', 'SA');
    }
  }

  void _detectSystemLocale() {
    final systemLocale = Get.deviceLocale;

    if (systemLocale != null) {
      // Check if system is Arabic
      if (systemLocale.languageCode == 'ar') {
        _currentLocale.value = const Locale('ar', 'SA');
      } else {
        // Default to English for non-Arabic systems
        _currentLocale.value = const Locale('en', 'US');
      }
    } else {
      // Default to Arabic
      _currentLocale.value = const Locale('ar', 'SA');
    }

    _saveLocale();
  }

  Future<void> changeLocale(Locale locale) async {
    _currentLocale.value = locale;
    Get.updateLocale(locale);
    await _saveLocale();
  }

  Future<void> _saveLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _localeKey,
        '${_currentLocale.value.languageCode}_${_currentLocale.value.countryCode}',
      );
    } catch (e) {
      // Handle error silently
    }
  }

  bool get isArabic => _currentLocale.value.languageCode == 'ar';
  bool get isEnglish => _currentLocale.value.languageCode == 'en';

  Future<void> toggleLanguage() async {
    if (isArabic) {
      await changeLocale(const Locale('en', 'US'));
    } else {
      await changeLocale(const Locale('ar', 'SA'));
    }
  }
}
