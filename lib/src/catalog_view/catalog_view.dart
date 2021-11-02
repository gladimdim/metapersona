import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metapersona/src/catalog_view/catalog_list_item_view.dart';
import 'package:metapersona/src/posts/post.dart';

class CatalogView extends StatelessWidget {
  const CatalogView({Key? key}) : super(key: key);
  static const String routeName = "/catalog";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All posts"),
      ),
      body: FutureBuilder(
        future: Catalog.initFromUrl("./"),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.done && data.hasData) {
            final Catalog catalog = data.data as Catalog;
            return ListView(
              children: catalog.posts
                  .map(
                    (e) => GestureDetector(
                      onTap: () => onListItemClicked(e, context),
                      child: CatalogListItemView(post: e),
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

  void onListItemClicked(Post post, BuildContext context) {
    Navigator.restorablePushNamed(context, "${CatalogView.routeName}/posts/${post.markdownContentUrl}");
  }
}
