import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        title: Text("All posts"),
      ),
      body: FutureBuilder(
        future: Catalog.initFromUrl(getRootUrlPrefix()),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.done && data.hasData) {
            final Catalog catalog = data.data as Catalog;
            return ListView(
              children: catalog.posts
                  .map(
                    (e) => InkWell(
                      onTap: () => onListItemClicked(e, context),
                      child: CatalogListItemView(postItem: e),
                    ),
                  )
                  .toList(),
            );
          } else {
            return CircularProgressIndicator();
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
