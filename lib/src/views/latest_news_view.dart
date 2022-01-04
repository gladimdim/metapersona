import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:metapersona/src/catalog/catalog_list_item_view.dart';
import 'package:metapersona/src/catalog/catalog_view.dart';
import 'package:metapersona/src/localization/my_localization.dart';
import 'package:metapersona/src/metapersonas/meta_persona.dart';
import 'package:metapersona/src/microblogging/micro_content_view.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:metapersona/src/microblogging/microblog_page.dart';
import 'package:metapersona/src/posts/catalog.dart';
import 'package:metapersona/src/utils.dart';

class LatestNewsView extends StatefulWidget {
  final MetaPersona? persona;

  const LatestNewsView({Key? key, this.persona}) : super(key: key);

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
                            child: CatalogListItemView(
                              postItem: postItem,
                              persona: widget.persona,
                            ),
                            onTap: () {
                              if (widget.persona == null) {
                                Navigator.restorablePushNamed(context,
                                    "${CatalogView.routeName}/posts/${postItem.id}");
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CatalogView(
                                              persona: widget.persona!,
                                            )));
                              }
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
                                imageFolder: getRootUrlPrefix(widget.persona) +
                                    MicroBlogPage.microsPath +
                                    MicroBlog.storageFolderPath,
                                microId: 0,
                              ),
                            ),
                            onTap: () {
                              if (widget.persona == null) {
                                Navigator.restorablePushNamed(
                                    context, MicroBlogPage.routeName);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MicroBlogPage(
                                          persona: widget.persona!)),
                                );
                              }
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
        .runOnce(() => Catalog.initFromUrl(getRootUrlPrefix(widget.persona)));

    return catalog.posts.first;
  }

  Future<MicroBlogItem> _fetchMicros() async {
    final MicroBlog result = await _microsFetch
        .runOnce(() => MicroBlog.initFromUrl(getRootUrlPrefix(widget.persona)));
    return result.micros.first;
  }
}
