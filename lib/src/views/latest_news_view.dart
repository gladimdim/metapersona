import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:metapersona/src/catalog/catalog_list_item_view.dart';
import 'package:metapersona/src/catalog/catalog_view.dart';
import 'package:metapersona/src/localization/my_localization.dart';
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
                AppLocalizations.of(context)!.labelLatestNews,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Column(
                children: [
                  FutureBuilder(
                    future: _fetchCatalog(),
                    builder: (context, data) {
                      if (data.connectionState != ConnectionState.done) {
                        return Row(
                          children: [
                            Text(AppLocalizations.of(context)!
                                .labelLoadingCatalog),
                            const CircularProgressIndicator(),
                          ],
                        );
                      } else if (data.connectionState == ConnectionState.done &&
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
                        return Text(AppLocalizations.of(context)!
                            .labelFailedToFetchCatalog);
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _fetchMicros(),
                    builder: (context, data) {
                      if (data.connectionState != ConnectionState.done) {
                        return Row(
                          children: [
                            Text(AppLocalizations.of(context)!
                                .labelLoadingMicros),
                            const CircularProgressIndicator(),
                          ],
                        );
                      } else if (data.connectionState == ConnectionState.done &&
                          data.hasData) {
                        final MicroBlogItem postItem =
                            data.data as MicroBlogItem;
                        return ConstrainedBox(
                          constraints:
                              BoxConstraints.tight(const Size(400, 200)),
                          child: InkWell(
                            child: IgnorePointer(
                              child: MicroContentView(
                                micro: postItem,
                                imageFolder: getRootUrlPrefix() +
                                    MicroBlogPage.microsPath +
                                    MicroBlog.storageFolderPath,
                                microId: 0,
                              ),
                            ),
                            onTap: () {
                              Navigator.restorablePushNamed(
                                  context, MicroBlogPage.routeName);
                            },
                          ),
                        );
                      } else {
                        return Text(AppLocalizations.of(context)!
                            .labelFailedToFetchMicros);
                      }
                    },
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
