import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:metapersona/src/catalog/catalog_list_item_view.dart';
import 'package:metapersona/src/catalog/catalog_view.dart';
import 'package:metapersona/src/microblogging/micro_content_view.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:metapersona/src/microblogging/microblog_page.dart';
import 'package:metapersona/src/posts/catalog.dart';
import 'package:metapersona/src/utils.dart';

class LatestNewsView extends StatefulWidget {
  const LatestNewsView({Key? key}) : super(key: key);

  @override
  State<LatestNewsView> createState() => _LatestNewsViewState();
}

class _LatestNewsViewState extends State<LatestNewsView> {
  AsyncMemoizer _catalogFetch = AsyncMemoizer();
  AsyncMemoizer _microsFetch = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Latest news",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: FutureBuilder(
                      future: _fetchCatalog(),
                      builder: (context, data) {
                        if (data.connectionState != ConnectionState.done) {
                          return Row(
                            children: const [
                              Text("Loading latest catalog items"),
                              CircularProgressIndicator(),
                            ],
                          );
                        } else if (data.connectionState ==
                                ConnectionState.done &&
                            data.hasData) {
                          final CatalogPostItem postItem =
                              data.data as CatalogPostItem;
                          return ConstrainedBox(
                            constraints:
                            BoxConstraints.tight(const Size(400, 200)),
                            child: InkWell(
                              child: CatalogListItemView(postItem: postItem),
                              onTap: () {
                                Navigator.restorablePushNamed(context,
                                    "${CatalogView.routeName}/posts/${postItem.id}");
                              },
                            ),
                          );
                        } else {
                          return Text("Failed to fetch catalog items");
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FutureBuilder(
                      future: _fetchMicros(),
                      builder: (context, data) {
                        if (data.connectionState != ConnectionState.done) {
                          return Row(
                            children: const [
                              Text("Loading latest micros"),
                              CircularProgressIndicator(),
                            ],
                          );
                        } else if (data.connectionState ==
                                ConnectionState.done &&
                            data.hasData) {
                          final MicroBlogItem postItem =
                              data.data as MicroBlogItem;
                          return ConstrainedBox(
                            constraints:
                                BoxConstraints.tight(const Size(400, 200)),
                            child: InkWell(
                              child: MicroContentView(
                                micro: postItem,
                                microId: 0,
                              ),
                              onTap: () {
                                Navigator.restorablePushNamed(
                                    context, MicroBlogPage.routeName);
                              },
                            ),
                          );
                        } else {
                          return Text("Failed to fetch micros");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<CatalogPostItem> _fetchCatalog() async {
    final Catalog catalog = await _catalogFetch
        .runOnce(() => Catalog.initFromUrl(getRootUrlPrefix()));

    return catalog.posts.first;
  }

  Future<MicroBlogItem> _fetchMicros() async {
    final MicroBlog result = await _microsFetch
        .runOnce(() => MicroBlog.initFromUrl(getRootUrlPrefix()));
    return result.micros.first;
  }
}
