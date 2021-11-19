import 'package:flutter/material.dart';
import 'package:metapersona/src/components/language_selector.dart';
import 'package:metapersona/src/components/search_box.dart';
import 'package:metapersona/src/localization/my_localization.dart';
import 'package:metapersona/src/microblogging/micro_view.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:async/async.dart';
import 'package:metapersona/src/utils.dart';

class MicroBlogView extends StatefulWidget {
  static String routeName = "/micro";

  const MicroBlogView({Key? key}) : super(key: key);

  @override
  State<MicroBlogView> createState() => _MicroBlogViewState();
}

class _MicroBlogViewState extends State<MicroBlogView> {
  final AsyncMemoizer _catalogFetch = AsyncMemoizer();
  String? _searchQuery;
  MicroBlog? mcBLog;
  List<MicroBlogItem>? shownPosts;
  Set<String> _languages = {};

  @override
  void initState() {
    super.initState();
    _execCatalogFetch();
  }

  @override
  Widget build(BuildContext context) {
    print(shownPosts?.length);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.labelAllPosts),
        actions: [
          if (mcBLog != null)
            LanguageSelector(
                languages: getAllLanguages(),
                onSelected: (newLangs) => _setSearchByLanguage(newLangs)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SearchBox(
                  onSearchChange: _execSearch,
                ),
              )),
          Expanded(
            flex: 10,
            child: shownPosts == null
                ? Container()
                : ListView.builder(
                    itemCount: shownPosts!.length,
                    itemBuilder: (context, index) {
                      return MicroView(
                        micro: shownPosts![index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Set<String> getAllLanguages() {
    var blog = mcBLog;
    if (blog == null) {
      return {MicroBlogItem.defaultLanguage};
    }
    var result = blog.micros
        .where((element) => element.languageEmoji != null)
        .map<String>((e) => e.languageEmoji!)
        .toList();
    return result.toSet();
  }

  _execCatalogFetch() async {
    final result = await _catalogFetch
        .runOnce(() => MicroBlog.initFromUrl(getRootUrlPrefix()));
    setState(() {
      mcBLog = result;
      shownPosts = mcBLog!.micros;
    });
  }

  List<MicroBlogItem> filteredItems(List<MicroBlogItem> allPosts) {
    var noSearch = _searchQuery?.isEmpty ?? true;
    if (_searchQuery == null || noSearch) {
      return allPosts;
    }
    var normalizedQuery = _searchQuery!.toLowerCase();
    var result = allPosts
        .where((e) => e.content.toLowerCase().contains(normalizedQuery))
        .toList();
    return result;
  }

  List<MicroBlogItem> filterByLanguage(List<MicroBlogItem> posts) {
    return posts
        .where((element) =>
            element.languageEmoji != null &&
            _languages.contains(element.languageEmoji))
        .toList();
  }

  List<MicroBlogItem> applyAllFilters(List<MicroBlogItem> allPosts) {
    var bySearch = filteredItems(allPosts);
    var byLanguage = filterByLanguage(bySearch);
    return byLanguage;
  }

  void _execSearch(String searchQuery) {
    if (_searchQuery == searchQuery) {
      return;
    }
    _searchQuery = searchQuery;
    updateShownPosts();
  }

  void updateShownPosts() {
    var blog = mcBLog;
    if (blog == null) {
      return;
    }
    setState(() {
      shownPosts = applyAllFilters(blog.micros);
    });
  }

  void _setSearchByLanguage(Set<String> newLangs) {
    _languages = newLangs;

    setState(() {
      updateShownPosts();
    });
  }
}
