import 'package:flutter/material.dart';
import 'package:metapersona/src/components/bordered_bottom.dart';
import 'package:metapersona/src/posts/post_view.dart';
import 'package:metapersona/src/settings/settings_view.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                      child: Text(
                        "Dmytro Gladkyi",
                        style: Theme.of(context).textTheme.headline6,
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
                    child: Text("View my posts", style: Theme.of(context).textTheme.headline6,),
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

    Navigator.restorablePushNamed(context, PostView.routeNamePrefix);
  }
}
