import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {

  final String _themeMode = "themeMode";

  Future<ThemeMode> themeMode() async {
    final instance = await SharedPreferences.getInstance();
    final mode = instance.getString(_themeMode);
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
    instance.setString(_themeMode, theme.name);
  }
}
