import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:metapersona/src/catalog/catalog_view.dart';
import 'package:metapersona/src/experience/experience_page.dart';
import 'package:metapersona/src/full_profile_view/full_profile_view.dart';
import 'package:metapersona/src/metapersonas/metapersonas_page.dart';
import 'package:metapersona/src/microblogging/microblog_page.dart';
import 'package:metapersona/src/posts/post_view.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'package:google_fonts/google_fonts.dart';

class MetaPersonaApp extends StatelessWidget {
  const MetaPersonaApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'metapersona',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('uk'),
          ],
          locale: settingsController.locale,
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(textTheme: GoogleFonts.merriweatherTextTheme()),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  if (routeSettings.name!.indexOf(PostView.routeNamePrefix) ==
                      0) {
                    final split =
                        routeSettings.name!.split(PostView.routeNamePrefix)[1];
                    return PostView(postId: split.split("/").last);
                  }
                  if (routeSettings.name!.indexOf(MicroBlogPage.routePrefix) == 0) {
                    final split = routeSettings.name!.split(MicroBlogPage.routePrefix)[1];
                    return MicroBlogPage(microId: split);
                  }
                  if (routeSettings.name == SettingsView.routeName) {
                    return SettingsView(controller: settingsController);
                  }
                  if (FullProfileView.routeName == routeSettings.name) {
                    return const FullProfileView();
                  }
                  if (CatalogView.routeName == routeSettings.name) {
                    return const CatalogView();
                  }
                  if (ExperiencePage.routeName == routeSettings.name) {
                    return const ExperiencePage();
                  }
                  if (MicroBlogPage.routeName == routeSettings.name) {
                    return const MicroBlogPage();
                  }
                  return const MetaPersonasPage();
                  // return const FullProfileView();
                });
          },
        );
      },
    );
  }
}
