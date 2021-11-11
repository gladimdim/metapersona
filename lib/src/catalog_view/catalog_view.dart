import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:metapersona/src/catalog_view/catalog_list_item_view.dart';
import 'package:metapersona/src/posts/catalog.dart';
import 'package:metapersona/src/utils.dart';

class CatalogView extends StatelessWidget {
  const CatalogView({Key? key}) : super(key: key);
  static String routeName = "/catalog";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.labelAllPosts),
      ),
      body: FutureBuilder(
        future: Catalog.initFromUrl(getRootUrlPrefix()),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.done && data.hasData) {
            final Catalog catalog = data.data as Catalog;
            return ListView.builder(
              itemCount: catalog.posts.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => onListItemClicked(catalog.posts[index], context),
                child: CatalogListItemView(postItem: catalog.posts[index]),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void onListItemClicked(CatalogPostItem post, BuildContext context) {
    Navigator.restorablePushNamed(
        context, "${CatalogView.routeName}/posts/${post.id}");
  }
}
