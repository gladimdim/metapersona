import 'package:flutter/material.dart';
import 'package:metapersona/src/posts/catalog.dart';

class CatalogListItemView extends StatelessWidget {
  final CatalogPostItem postItem;

  const CatalogListItemView({Key? key, required this.postItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(postItem.title, style: Theme.of(context).textTheme.headline6,),
    );
  }
}
