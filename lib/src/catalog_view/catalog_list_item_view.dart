import 'package:flutter/material.dart';
import 'package:metapersona/src/catalog_view/date_published_view.dart';
import 'package:metapersona/src/components/bordered_bottom.dart';
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
            postItem.thumbnail == null
                ? Container()
                : Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Image.network("${postItem.getFullThumbnail()}"),
                    ),
                  ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            BorderedBottom(
                              color: Colors.grey[200]!,
                              child: Text(
                                postItem.title,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            if (postItem.dateAdded != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DatePublishedView(date: postItem.dateAdded!),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: postItem.tags
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Chip(label: Text(e), elevation: 5.0,),
                                ))
                            .toList(),
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
