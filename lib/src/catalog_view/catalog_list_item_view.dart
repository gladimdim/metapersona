import 'package:flutter/material.dart';
import 'package:metapersona/src/posts/catalog.dart';

class CatalogListItemView extends StatelessWidget {
  final CatalogPostItem postItem;

  const CatalogListItemView({Key? key, required this.postItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.0,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Image.network("${postItem.getFullThumbnail()}")),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          postItem.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: postItem.tags.map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chip(label: Text(e)),
                        )).toList(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
