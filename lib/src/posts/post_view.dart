import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:metapersona/src/posts/post.dart';
import 'package:metapersona/src/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PostView extends StatelessWidget {
  static String routeNamePrefix = "/catalog/posts/";
  static String postsPath = "catalog/posts/";
  final String postId;

  const PostView({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Post.fromIdUrl(getRootUrlPrefix() + postsPath, postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final Post post = snapshot.data as Post;
          return Scaffold(
            appBar: AppBar(
              title: Text(post.title),
              actions: [
                IconButton(onPressed: () => _copyLink(post), icon: Icon(Icons.copy)),
                IconButton(onPressed: () => _sharePost(post), icon: Icon(Icons.share)),
              ],
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
              imageDirectory: getRootUrlPrefix() + postsPath + postId,
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

  void _copyLink(Post post) {
    Clipboard.setData(ClipboardData(text: Uri.base.toString()));
  }

  void _sharePost(Post post) {
    Share.share(Uri.base.toString(), subject: post.title);
  }

}
