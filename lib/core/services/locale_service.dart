import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const String _localeKey = 'selected_locale';

  static Future<Locale> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);

      if (savedLocale != null) {
        final parts = savedLocale.split('_');
        if (parts.length == 2) {
          return Locale(parts[0], parts[1]);
        }
      }

      // Auto-detect system locale or default to Arabic
      return _detectSystemLocale();
    } catch (e) {
      return const Locale('ar', 'SA');
    }
  }

  static Locale _detectSystemLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // Check if system is Arabic
    if (systemLocale.languageCode == 'ar') {
      return const Locale('ar', 'SA');
    } else {
      // Default to English for non-Arabic systems
      return const Locale('en', 'US');
    }
  }

  static Future<void> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _localeKey,
        '${locale.languageCode}_${locale.countryCode}',
      );
    } catch (e) {
      // Handle error silently
    }
  }
}
