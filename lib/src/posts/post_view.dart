import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:metapersona/src/posts/post.dart';
import 'package:url_launcher/url_launcher.dart';



class PostView extends StatelessWidget {
  static const String routeNamePrefix = "/catalog";
  final Post post;
  const PostView({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Markdown(
        onTapLink: (text, link, title) async {
          if (link == null) {
            return;
          }
          await launch(link);
        },
        data: post.content,
      ),
    );
  }
}
