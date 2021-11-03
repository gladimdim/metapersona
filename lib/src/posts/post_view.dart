import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:metapersona/src/posts/post.dart';
import 'package:metapersona/src/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PostView extends StatelessWidget {
  static String routeNamePrefix = "/catalog/posts/";
  final String postId;

  const PostView({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Post.fromIdUrl(getRootUrlPrefix() + routeNamePrefix, postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final Post post = snapshot.data as Post;
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
              selectable: true,
              data: "# ${post.title}\n" + post.markdownContent,
              imageDirectory: getRootUrlPrefix() + routeNamePrefix + postId,
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(postId),
            ),
            body: Column(
              children: [
                const Text("Loading"),
                const CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}
