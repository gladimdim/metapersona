import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:metapersona/src/catalog_view/catalog_view.dart';
import 'package:metapersona/src/components/bordered_bottom.dart';
import 'package:metapersona/src/settings/settings_view.dart';

class MainProfileView extends StatelessWidget {
  static const String routeName = "/";

  const MainProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profilePageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BorderedBottom(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(45),
                        ),
                        child: Image.asset(
                          "assets/images/profile/green_round_avatar.jpg",
                          width: 128,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Dmytro Gladkyi",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                              "Flutter Developer 💙 since 2018",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),Text(
                              "JavaScript developer since 2012",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(AppLocalizations.of(context)!.viewMyArticles),
                  ),
                  onPressed: () => _viewMyPostsPressed(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewMyPostsPressed(BuildContext context) {

    Navigator.restorablePushNamed(context, CatalogView.routeName);
  }
}
