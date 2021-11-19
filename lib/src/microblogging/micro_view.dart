import 'package:flutter/material.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:flutter_markdown/flutter_markdown.dart'
    deferred as flutter_markdown;

class MicroView extends StatelessWidget {
  final MicroBlogItem micro;
  final int lineHeight = 50;

  const MicroView({Key? key, required this.micro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = micro.content.split("\n\n").length.toDouble();
    height = height > 1 ? height : 2;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: lineHeight * height),
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: flutter_markdown.loadLibrary(),
              builder: (context, data) {
                if (data.connectionState == ConnectionState.done) {
                  return flutter_markdown.Markdown(data: micro.content);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
