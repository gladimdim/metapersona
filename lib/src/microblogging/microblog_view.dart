import 'package:flutter/material.dart';
import 'package:metapersona/src/components/language_selector.dart';
import 'package:metapersona/src/components/list_search_refresh.dart';
import 'package:metapersona/src/localization/my_localization.dart';
import 'package:metapersona/src/microblogging/full_micro_content_view.dart';
import 'package:metapersona/src/microblogging/micro_content_view.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:metapersona/src/utils.dart';

class MicroBlogView extends StatefulWidget {
  static String routeName = "/micro";
  static String routePrefix = "/micro/";
  static String microsPath = "micro/";
  final String? microId;

  const MicroBlogView({Key? key, this.microId}) : super(key: key);

  @override
  State<MicroBlogView> createState() => _MicroBlogViewState();
}

class _MicroBlogViewState extends State<MicroBlogView> {
  String? _searchQuery;
  MicroBlog? mcBlog;
  List<MicroBlogItem>? shownPosts;
  Set<String> _languages = {};
  MicroBlogItem? microItem;

  @override
  void initState() {
    super.initState();
    _execCatalogFetch();
  }

  @override
  Widget build(BuildContext context) {
    final micro = microItem;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.labelMetaProfile),
        actions: [
          if (mcBlog != null)
            LanguageSelector(
              languages: getAllLanguages(),
              onSelected: (newLangs) => _setSearchByLanguage(newLangs),
            ),
        ],
      ),
      body: micro != null
          ? FullMicroContentView(micro: micro)
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListSearchRefreshView(
                    onTextSearch: _applySearchByText,
                    onRefreshDataPressed: _refreshData,
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: shownPosts == null
                      ? Container()
                      : GridView.builder(
                          itemCount: shownPosts!.length,
                          itemBuilder: (context, index) {
                            return ConstrainedBox(
                              constraints:
                                  BoxConstraints.loose(const Size(400, 300)),
                              child: MicroContentView(
                                micro: shownPosts![index],
                                imageFolder: getRootUrlPrefix() +
                                    MicroBlogView.microsPath +
                                    MicroBlog.storageFolderPath,
                                  onNavigateToMicro: () => _navigateToMicro(context, index),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: gridPerAxisCount(context),
                                  childAspectRatio: 2),
                        ),
                ),
              ],
            ),
    );
  }

  bool hasData() {
    return shownPosts != null;
  }

  MicroBlogItem? getRealMicroObjectByStringId(String? micro) {
    if (micro == null) {
      return null;
    }
    if (mcBlog == null) {
      return null;
    }

    var integer = int.tryParse(micro);
    if (integer == null) {
      return null;
    }

    if (mcBlog!.micros.length < integer) {
      return null;
    }
    return mcBlog!.micros[mcBlog!.micros.length - 1 - integer];
  }

  void _refreshData() async {
    await _execCatalogFetch();
    updateShownPosts();
  }

  Set<String> getAllLanguages() {
    var blog = mcBlog;
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
    final result = await MicroBlog.initFromUrl(getRootUrlPrefix());
    setState(() {
      mcBlog = result;
      _languages = getAllLanguages();
      shownPosts = mcBlog!.micros;
      microItem = getRealMicroObjectByStringId(widget.microId);
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

  void _applySearchByText(String searchQuery) {
    if (_searchQuery == searchQuery) {
      return;
    }
    _searchQuery = searchQuery;
    updateShownPosts();
  }

  void updateShownPosts() {
    var blog = mcBlog;
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

  void _navigateToMicro(BuildContext context, int index) {
    var reversedIndex = mcBlog!.micros.length - 1 - index;
    Navigator.restorablePushNamed(context, "${MicroBlogView.routeName}/$reversedIndex");
  }
}
