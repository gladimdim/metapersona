import 'package:flutter/material.dart';
import 'package:metapersona/src/components/search_box.dart';
import 'package:metapersona/src/localization/my_localization.dart';
import 'package:metapersona/src/microblogging/micro_view.dart';
import 'package:metapersona/src/microblogging/microblog.dart';
import 'package:async/async.dart';
import 'package:metapersona/src/utils.dart';

class MicroBlogView extends StatefulWidget {
  static String routeName = "micro";

  const MicroBlogView({Key? key}) : super(key: key);

  @override
  State<MicroBlogView> createState() => _MicroBlogViewState();
}

class _MicroBlogViewState extends State<MicroBlogView> {
  final AsyncMemoizer _catalogFetch = AsyncMemoizer();
  String? _searchQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.labelAllPosts),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SearchBox(
                  onSearchChange: _execSearch,
                ),
              )),
          Expanded(
            flex: 10,
            child: FutureBuilder(
              future: _execCatalogFetch(),
              builder: (context, data) {
                if (data.connectionState == ConnectionState.done &&
                    data.hasData) {
                  final MicroBlog micro = data.data as MicroBlog;
                  final micros = filteredItems(micro.micros);
                  return ListView.builder(
                    itemCount: micros.length,
                    itemBuilder: (context, index) {
                      return ConstrainedBox(
                        constraints: BoxConstraints.loose(Size(100, 200)),
                        child: MicroView(
                          micro: micros[index],
                        ),
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _execCatalogFetch() {
    return _catalogFetch
        .runOnce(() => MicroBlog.initFromUrl(getRootUrlPrefix()));
  }

  List<MicroBlogItem> filteredItems(List<MicroBlogItem> allPosts) {
    var noSearch = _searchQuery?.isEmpty ?? true;
    if (_searchQuery == null || noSearch) {
      return allPosts;
    }
    var normalizedQuery = _searchQuery!.toLowerCase();
    var result = allPosts
        .where((e) => e.content.toLowerCase().contains(normalizedQuery))
        .toList();
    return result;
  }

  void _execSearch(String searchQuery) {
    if (_searchQuery == searchQuery) {
      return;
    }
    setState(() {
      _searchQuery = searchQuery;
    });
  }
}
