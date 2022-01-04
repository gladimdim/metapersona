import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metapersona/src/components/markdown_viewer.dart';
import 'package:metapersona/src/metapersonas/meta_persona.dart';
import 'package:metapersona/src/posts/post.dart';
import 'package:metapersona/src/utils.dart';
import 'package:share_plus/share_plus.dart' deferred as share_plus;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostView extends StatelessWidget {
  static String routeNamePrefix = "/catalog/posts/";
  static String postsPath = "catalog/posts/";
  final String postId;

  final MetaPersona? persona;

  const PostView({Key? key, required this.postId, this.persona})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Post.fromIdUrl(getRootUrlPrefix(persona) + postsPath, postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final Post post = snapshot.data as Post;
          return Scaffold(
            appBar: AppBar(
              title: Text(post.title),
              actions: [
                IconButton(
                    onPressed: () => _copyLink(post),
                    icon: const Icon(Icons.copy)),
                IconButton(
                    onPressed: () => _sharePost(post),
                    icon: const Icon(Icons.share)),
              ],
            ),
            body: Center(
              child: MarkdownViewer(
                content: "# ${post.title}\n" + post.markdownContent,
                imageDirectory:
                    getRootUrlPrefix(persona) + postsPath + postId + "/",
                contentPadding: EdgeInsets.symmetric(
                    horizontal:
                        isNarrow(context) ? 8.0 : calculatePaddings(context)),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(postId),
            ),
            body: Column(
              children: [
                Text(AppLocalizations.of(context)!.labelLoading),
                const CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }

  void _copyLink(Post post) {
    Clipboard.setData(ClipboardData(text: getFullPostUrl()));
  }

  void _sharePost(Post post) async {
    await share_plus.loadLibrary();
    share_plus.Share.share(getFullPostUrl(), subject: post.title);
  }

  String getFullPostUrl() {
    return persona == null
        ? Uri.base.toString()
        : getRootUrlPrefix(persona) + "#/" + postsPath + postId;
  }
}
