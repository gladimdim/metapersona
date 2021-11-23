import 'package:flutter/material.dart';
import 'package:metapersona/src/components/markdown_viewer.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:metapersona/src/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MicroContentView extends StatefulWidget {
  final MicroBlogItem micro;
  final String? imageFolder;
  final bool fullHeader;
  final VoidCallback onNavigateToMicro;

  const MicroContentView(
      {Key? key,
      required this.micro,
      this.imageFolder,
      this.fullHeader = false,
      required this.onNavigateToMicro})
      : super(key: key);

  @override
  State<MicroContentView> createState() => _MicroContentViewState();
}

class _MicroContentViewState extends State<MicroContentView> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var links = getUrlLinksFromMarkdown(widget.micro.content);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          if (!expanded)
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MarkdownViewer(
                  content: widget.micro.content,
                  imageDirectory: widget.imageFolder,
                ),
              ),
            ),
          if (links.isNotEmpty && expanded)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: links
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Text("*${links.indexOf(e).toString()}: "),
                            Expanded(
                              child: ElevatedButton(
                                  child: Text(e), onPressed: () => _openLink(e)),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: widget.onNavigateToMicro,
                      icon: const Icon(Icons.open_in_new)),
                  if (links.isNotEmpty)
                    IconButton(
                        onPressed: _expandPressed,
                        icon: const Icon(Icons.info)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _expandPressed() {
    setState(() {
      expanded = !expanded;
    });
  }

  _openLink(String url) async {
    await launch(url);
  }
}
