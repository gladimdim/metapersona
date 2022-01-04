import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:metapersona/src/catalog/catalog_view.dart';
import 'package:metapersona/src/components/bordered_bottom.dart';
import 'package:metapersona/src/components/main_view_card_item.dart';
import 'package:metapersona/src/experience/experience_page.dart';
import 'package:metapersona/src/microblogging/microblog_page.dart';
import 'package:metapersona/src/settings/settings_view.dart';
import 'package:metapersona/src/views/latest_news_view.dart';

class MainProfileView extends StatelessWidget {
  static const String routeName = "/mainProfile";

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BorderedBottom(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
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
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Dmytro Gladkyi",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                "Flutter Developer 💙 since 2018",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                "JavaScript developer since 2012",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MainMenuCardItem(

                          child: Text(AppLocalizations.of(context)!.viewMyArticles, style: Theme.of(context).textTheme.subtitle1,),
                          onPress: () => _viewMyPostsPressed(context),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MainMenuCardItem(

                          child: Text(AppLocalizations.of(context)!.viewShortPosts, style: Theme.of(context).textTheme.subtitle1,),
                          onPress: () => _viewMicros(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MainMenuCardItem(
                    child: Text(AppLocalizations.of(context)!.viewExperiencePage, style: Theme.of(context).textTheme.subtitle1,),
                    onPress: () => _viewExperience(context),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LatestNewsView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _viewMyPostsPressed(BuildContext context) {
    Navigator.restorablePushNamed(context, CatalogView.routeName);
  }

  void _viewMicros(BuildContext context) {
    Navigator.restorablePushNamed(context, MicroBlogPage.routeName);
  }

  void _viewExperience(BuildContext context) {
    Navigator.restorablePushNamed(context, ExperiencePage.routeName);
  }
}
