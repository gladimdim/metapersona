import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metapersona/src/components/language_selector.dart';
import 'package:metapersona/src/components/list_search_refresh.dart';
import 'package:metapersona/src/localization/my_localization.dart';
import 'package:metapersona/src/microblogging/micro_content_view.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:metapersona/src/utils.dart';

class MicroBlogPage extends StatefulWidget {
  static String routeName = "/micro";
  static String routePrefix = "/micro/";
  static String microsPath = "micro/";
  final String? microId;

  const MicroBlogPage({Key? key, this.microId}) : super(key: key);

  @override
  State<MicroBlogPage> createState() => _MicroBlogPageState();
}

class _MicroBlogPageState extends State<MicroBlogPage> {
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
        title: Text(widget.microId == null
            ? AppLocalizations.of(context)!.labelMetaProfile
            : "${AppLocalizations.of(context)!.titleMicroItemView} #${widget.microId}"),
        actions: [
          if (mcBlog != null && widget.microId == null)
            LanguageSelector(
              languages: getAllLanguages(),
              onSelected: (newLangs) => _setSearchByLanguage(newLangs),
            ),
        ],
      ),
      body: micro != null
          ? Hero(
              tag: micro.content,
              child: MicroContentView(
                micro: micro,
                imageFolder: getRootUrlPrefix() +
                    MicroBlogPage.microsPath +
                    MicroBlog.storageFolderPath,
                microId: reversedIndexOfMicro(micro, mcBlog!.micros),
                onCopyPathToMicro: () => _onCopyPathToMicro(context, micro),
              ),
            )
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
                              child: Hero(
                                tag: shownPosts![index].content,
                                child: MicroContentView(
                                  micro: shownPosts![index],
                                  imageFolder: getRootUrlPrefix() +
                                      MicroBlogPage.microsPath +
                                      MicroBlog.storageFolderPath,
                                  onNavigateToMicro: () => _navigateToMicro(
                                      context, shownPosts![index]),
                                  onCopyPathToMicro: () => _onCopyPathToMicro(
                                      context, shownPosts![index]),
                                  microId: reversedIndexOfMicro(
                                      shownPosts![index], mcBlog!.micros),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: gridPerAxisCount(context),
                                  childAspectRatio: 1.5),
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

  void _navigateToMicro(BuildContext context, MicroBlogItem micro) {
    var index = indexOfMicro(micro, mcBlog!.micros);
    var newIndex = reversedIndex(mcBlog!.micros, index);
    Navigator.restorablePushNamed(
        context, "${MicroBlogPage.routeName}/$newIndex");
  }

  int indexOfMicro(MicroBlogItem micro, List<MicroBlogItem> micros) {
    return micros.indexOf(micro);
  }

  int reversedIndexOfMicro(MicroBlogItem micro, List<MicroBlogItem> micros) {
    return reversedIndex(micros, indexOfMicro(micro, micros));
  }

  int reversedIndex(List<MicroBlogItem> micros, int index) {
    return micros.length - 1 - index;
  }

  void _onCopyPathToMicro(BuildContext context, MicroBlogItem micro) {
    var index = indexOfMicro(micro, mcBlog!.micros);
    var fixedIndex = reversedIndex(mcBlog!.micros, index);
    var suffix = "${MicroBlogPage.routeName}/$fixedIndex";
    var root = Uri.base.origin;
    var prefix = getRootUrlPrefix();
    var fullUrl = root + prefix + "#" + suffix;
    Clipboard.setData(ClipboardData(text: fullUrl));
  }
}
