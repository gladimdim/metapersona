import 'package:flutter/material.dart';
import 'package:metapersona/src/catalog/date_published_view.dart';
import 'package:metapersona/src/components/markdown_viewer.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:metapersona/src/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MicroContentView extends StatefulWidget {
  final MicroBlogItem micro;
  final String? imageFolder;
  final bool fullHeader;
  final int microId;
  final bool disableMiniScroll;
  final VoidCallback? onNavigateToMicro;
  final VoidCallback? onCopyPathToMicro;

  const MicroContentView(
      {Key? key,
      required this.micro,
      this.imageFolder,
      this.fullHeader = false,
      this.onCopyPathToMicro,
      required this.microId,
      this.disableMiniScroll = false,
      this.onNavigateToMicro})
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
      child: Column(
        children: [
          if (!expanded)
            Expanded(
              flex: 5,
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: widget.disableMiniScroll
                            ? IgnorePointer(
                                child: MarkdownViewer(
                                  content: widget.micro.content,
                                  imageDirectory: widget.imageFolder,
                                ),
                              )
                            : MarkdownViewer(
                                content: widget.micro.content,
                                imageDirectory: widget.imageFolder,
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.micro.dateAdded != null)
                            DatePublishedView(date: widget.micro.dateAdded!),
                          Wrap(
                            children: [
                              if (!expanded && widget.onNavigateToMicro != null)
                                IconButton(
                                    onPressed: widget.onNavigateToMicro,
                                    icon: const Icon(Icons.open_in_new)),
                              if (!expanded && widget.onCopyPathToMicro != null)
                                IconButton(
                                    onPressed: widget.onCopyPathToMicro,
                                    icon: const Icon(Icons.copy)),
                              if (links.isNotEmpty)
                                IconButton(
                                    onPressed: _expandPressed,
                                    icon: const Icon(Icons.info)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (links.isNotEmpty && expanded)
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
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
                                    child: Text(e),
                                    onPressed: () => _openLink(e)),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          if (expanded)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: _expandPressed, icon: const Icon(Icons.info)),
              ],
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
