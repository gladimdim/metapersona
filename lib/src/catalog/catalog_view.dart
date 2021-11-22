import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:metapersona/src/catalog/responsive_catalog_list_view.dart';
import 'package:metapersona/src/components/list_search_refresh.dart';
import 'package:metapersona/src/posts/catalog.dart';
import 'package:metapersona/src/utils.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({Key? key}) : super(key: key);
  static String routeName = "/catalog";

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  AsyncMemoizer _catalogFetch = AsyncMemoizer();
  String? _searchQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.labelAllPosts),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListSearchRefreshView(
              onTextSearch: _execSearch,
              onRefreshDataPressed: _refreshData,
            ),
          ),
          Expanded(
            flex: 10,
            child: FutureBuilder(
              future: _execCatalogFetch(),
              builder: (context, data) {
                if (data.connectionState == ConnectionState.done &&
                    data.hasData) {
                  final Catalog catalog = data.data as Catalog;
                  final viewablePosts = filteredItems(catalog.posts);
                  return ResponsiveCatalogListView(
                    posts: viewablePosts,
                    onItemClicked: (post) => onListItemClicked(post, context),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _refreshData() async {
    setState(() {
      _catalogFetch = AsyncMemoizer();
    });
  }

  _execCatalogFetch() {
    return _catalogFetch.runOnce(() => Catalog.initFromUrl(getRootUrlPrefix()));
  }

  List<CatalogPostItem> filteredItems(List<CatalogPostItem> allPosts) {
    var noSearch = _searchQuery?.isEmpty ?? true;
    if (_searchQuery == null || noSearch) {
      return allPosts;
    }
    var normalizedQuery = _searchQuery!.toLowerCase();
    var result = allPosts.where((e) {
      return e.title.toLowerCase().contains(normalizedQuery) ||
          e.tags
              .where(
                  (element) => element.toLowerCase().contains(normalizedQuery))
              .isNotEmpty;
    }).toList();
    return result;
  }

  void _execSearch(String searchQuery) {
    if (_searchQuery == searchQuery) {
      return;
    }
    setState(() {
      _searchQuery = searchQuery;
    });
  }

  void onListItemClicked(CatalogPostItem post, BuildContext context) {
    Navigator.restorablePushNamed(
        context, "${CatalogView.routeName}/posts/${post.id}");
  }
}
