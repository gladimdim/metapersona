import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'
    deferred as flutter_markdown;
import 'package:url_launcher/url_launcher.dart';

class MarkdownViewer extends StatelessWidget {
  final String content;
  final String? imageDirectory;
  final EdgeInsets contentPadding;

  const MarkdownViewer(
      {Key? key,
      required this.content,
      this.imageDirectory,
      this.contentPadding = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: flutter_markdown.loadLibrary(),
      builder: (context, data) => flutter_markdown.Markdown(
        padding: contentPadding,
        onTapLink: (text, link, title) async {
          if (link == null) {
            return;
          }
          await launch(link);
        },
        selectable: true,
        data: content,
        imageDirectory: imageDirectory,
      ),
    );
  }
}
