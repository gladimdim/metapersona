import 'package:flutter/material.dart';
import 'package:metapersona/src/catalog/date_published_view.dart';
import 'package:metapersona/src/components/bordered_bottom.dart';
import 'package:metapersona/src/metapersonas/meta_persona.dart';
import 'package:metapersona/src/posts/catalog.dart';
import 'package:metapersona/src/utils.dart';

class CatalogListItemView extends StatelessWidget {
  final CatalogPostItem postItem;
  final MetaPersona? persona;
  const CatalogListItemView({Key? key, required this.postItem, this.persona})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 10.0,
        child: Row(
          children: [
            postItem.thumbnail == null
                ? Container()
                : Expanded(
                    flex: isNarrow(context) ? 1 : 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Image.network("${postItem.getFullThumbnail(persona)}"),
                    ),
                  ),
            Expanded(
              flex: isNarrow(context) ? 5 : 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                              child: Chip(
                                label: Text(
                                  e,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                elevation: 5.0,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
