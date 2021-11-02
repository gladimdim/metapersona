import 'package:flutter/material.dart';
import 'package:metapersona/src/posts/post.dart';

class CatalogListItemView extends StatelessWidget {
  final Post post;

  const CatalogListItemView({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(post.title, style: Theme.of(context).textTheme.headline6,),
    );
  }
}
