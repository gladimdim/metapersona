import 'package:flutter/material.dart';
import 'package:metapersona/src/localization/my_localization.dart';

import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            child: DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Select language"),
              DropdownButton<Locale>(
                // Read the selected themeMode from the controller
                value: controller.locale,
                // Call the updateThemeMode method any time the user selects a theme.
                onChanged: controller.updateLocalization,
                items: const [
                  DropdownMenuItem(
                    value: Locale("en"),
                    child: Text('English 🇺🇸'),
                  ),
                  DropdownMenuItem(
                    value: Locale("uk"),
                    child: Text('Українська 🇺🇦'),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
