import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {

  final String _themeKey = "themeMode";
  final String _localeKey = "locale";
  Future<ThemeMode> themeMode() async {
    final instance = await SharedPreferences.getInstance();
    final mode = instance.getString(_themeKey);
    if (mode == null) {
      return ThemeMode.system;
    } else {
      return mode == "dark" ? ThemeMode.dark : ThemeMode.light;
    }
  }


  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_themeKey, theme.name);
  }

  Future<void> updateLocale(Locale newLocale) async {

    final instance = await SharedPreferences.getInstance();
    await instance.setString(_localeKey, newLocale.languageCode);
  }

  Future<Locale> readLocale() async {

    final instance = await SharedPreferences.getInstance();
    final localeString = instance.getString(_localeKey);
    return Locale(localeString ?? "en");

  }
}
