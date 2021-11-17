import 'package:flutter/material.dart';
import 'package:metapersona/src/catalog/catalog_list_item_view.dart';
import 'package:metapersona/src/posts/catalog.dart';
import 'package:metapersona/src/utils.dart';
import 'package:metapersona/src/extensions/list.dart';

class ResponsiveCatalogListView extends StatelessWidget {
  final List<CatalogPostItem> posts;
  final Function(CatalogPostItem) onItemClicked;

  const ResponsiveCatalogListView(
      {Key? key, required this.posts, required this.onItemClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final splitPosts = split(posts, context);
    return ListView.builder(
      itemCount: splitPosts.length,
      itemBuilder: (context, index) {
        final rowPosts = splitPosts[index];
        return Row(
          children: rowPosts
              .map(
                (post) => Expanded(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 220),
                    child: InkWell(
                      onTap: () => onItemClicked(
                        post,
                      ),
                      child: CatalogListItemView(postItem: post),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  List<List<CatalogPostItem>> split(
      List<CatalogPostItem> posts, BuildContext context) {
    var splitBy = isNarrow(context) ? 1 : 2;

    return posts.divideBy(splitBy);
  }
}
