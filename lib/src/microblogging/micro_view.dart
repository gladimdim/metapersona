import 'package:flutter/material.dart';
import 'package:metapersona/src/components/markdown_viewer.dart';
import 'package:metapersona/src/microblogging/microblog.dart';

class MicroView extends StatelessWidget {
  final MicroBlogItem micro;
  final int lineHeight = 50;
  final String? imageFolder;

  const MicroView({Key? key, required this.micro, this.imageFolder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = micro.content.split("\n\n").length.toDouble();
    height = height > 1 ? height : 2;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MarkdownViewer(
            content: micro.content,
            imageDirectory: imageFolder,
          ),
        ),
      ),
    );
  }
}