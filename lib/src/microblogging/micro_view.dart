import 'package:flutter/material.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:flutter_markdown/flutter_markdown.dart'
    deferred as flutter_markdown;

class MicroView extends StatelessWidget {
  final MicroBlogItem micro;

  const MicroView({Key? key, required this.micro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Text(micro.content);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // child: Text(micro.content),
          child: Center(
            child: FutureBuilder(
              future: flutter_markdown.loadLibrary(),
              builder: (context, data) {
                if (data.connectionState == ConnectionState.done) {
                  return flutter_markdown.Markdown(data: micro.content);
                } else {
                  return Text("Loading");
                }
              }
            ),
          ),
        ),
      ),
    );
  }
}
