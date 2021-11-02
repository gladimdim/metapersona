import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PostView extends StatelessWidget {
  static const String routeNamePrefix = "/catalog/post/";
  final String postUrl;

  const PostView({Key? key, required this.postUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, data) => Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: FutureBuilder(builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final String markdownString = snapshot.data as String;
            return Markdown(
              onTapLink: (text, link, title) async {
                if (link == null) {
                  return;
                }
                await launch(link);
              },
              data: markdownString,
            );
          } else {
            return Column(
              children: [
                Text("Loading"),
                CircularProgressIndicator(),
              ],
            );
          }
        }),
      ),
    );
  }
}
